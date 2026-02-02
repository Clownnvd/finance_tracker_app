/// DTO for RPC `category_totals` response.
///
/// Expected JSON item:
/// {
///   "category_id": 1,
///   "name": "Food",
///   "total": 450.0,
///   "percent": 30.25
/// }
///
/// Notes:
/// - `total` and `percent` are returned as numeric from Postgres.
/// - Supabase may deserialize numeric as int, double, or String.
/// - Percent is already calculated by DB (0..100).
class CategoryTotalDto {
  final int categoryId;
  final String name;
  final double total;
  final double percent;

  const CategoryTotalDto({
    required this.categoryId,
    required this.name,
    required this.total,
    required this.percent,
  });

  factory CategoryTotalDto.fromJson(Map<String, dynamic> json) {
    final categoryIdRaw = json['category_id'];
    final name = (json['name'] ?? '').toString().trim();
    final totalRaw = json['total'];
    final percentRaw = json['percent'];

    if (categoryIdRaw == null) {
      throw const FormatException('CategoryTotalDto: category_id is missing');
    }
    if (name.isEmpty) {
      throw const FormatException('CategoryTotalDto: name is missing');
    }

    return CategoryTotalDto(
      categoryId: _parseInt(categoryIdRaw),
      name: name,
      total: _parseDouble(totalRaw),
      percent: _parseDouble(percentRaw),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'category_id': categoryId,
      'name': name,
      'total': total,
      'percent': percent,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
