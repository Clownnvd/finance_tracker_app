import 'dart:convert';

/// Helper to build PostgREST/Supabase query strings reliably.
///
/// Why needed:
/// - PostgREST often requires duplicate keys:
///   e.g. date=gte.2024-01-01&date=lte.2024-01-31
/// - Dio's `queryParameters` can overwrite duplicate keys depending on Map behavior.
/// - Building the query string ourselves keeps it deterministic.
///
/// Notes:
/// - This builder URL-encodes values (and keys) safely.
/// - Do NOT include the leading '?' in [build()] output unless you pass [withQuestionMark]=true.
class PostgrestQueryBuilder {
  final List<_QueryPair> _pairs = <_QueryPair>[];

  /// Adds a raw key/value pair (value will be encoded).
  PostgrestQueryBuilder add(String key, String value) {
    _pairs.add(_QueryPair(key, value));
    return this;
  }

  /// Adds a filter in PostgREST format: field=op.value
  ///
  /// Example:
  ///   filter('type', 'eq', 'INCOME') -> type=eq.INCOME
  PostgrestQueryBuilder filter(String field, String op, String value) {
    return add(field, '$op.$value');
  }

  /// Adds ordering:
  ///   order=date.desc
  PostgrestQueryBuilder orderBy(String field, {bool ascending = true}) {
    return add('order', '$field.${ascending ? 'asc' : 'desc'}');
  }

  /// Adds limit:
  ///   limit=3
  PostgrestQueryBuilder limit(int value) {
    return add('limit', value.toString());
  }

  /// Adds select:
  ///   select=id,amount,categories(name,icon)
  PostgrestQueryBuilder select(String value) {
    return add('select', value);
  }

  /// Adds range filter with duplicate keys:
  ///   field=gte.start AND field=lte.end
  ///
  /// Example:
  ///   range('date', startIso, endIso)
  /// -> date=gte.2024-01-01&date=lte.2024-01-31
  PostgrestQueryBuilder range(String field, String start, String end) {
    _pairs.add(_QueryPair(field, 'gte.$start'));
    _pairs.add(_QueryPair(field, 'lte.$end'));
    return this;
  }

  /// Builds the final query string.
  ///
  /// Example output:
  ///   "type=eq.INCOME&month=gte.2024-01-01&month=lte.2024-12-31&order=month.asc"
  String build({bool withQuestionMark = false}) {
    if (_pairs.isEmpty) return withQuestionMark ? '?' : '';

    final qs = _pairs.map((p) {
      final k = Uri.encodeQueryComponent(p.key);
      final v = Uri.encodeQueryComponent(p.value);
      return '$k=$v';
    }).join('&');

    return withQuestionMark ? '?$qs' : qs;
  }

  /// Convenience helper to append query string into a base path.
  ///
  /// Example:
  ///   withQuery('/rest/v1/transactions') -> '/rest/v1/transactions?...'
  String withQuery(String basePath) {
    final qs = build(withQuestionMark: true);
    return '$basePath$qs';
  }

  /// Optional: builds a Map-friendly representation for debugging.
  /// Not used for requests.
  Map<String, List<String>> toMultiMap() {
    final map = <String, List<String>>{};
    for (final p in _pairs) {
      map.putIfAbsent(p.key, () => <String>[]).add(p.value);
    }
    return map;
  }

  @override
  String toString() => jsonEncode(toMultiMap());
}

class _QueryPair {
  final String key;
  final String value;
  const _QueryPair(this.key, this.value);
}
