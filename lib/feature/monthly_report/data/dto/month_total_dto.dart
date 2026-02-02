/// DTO for `v_month_totals` view response.
///
/// Expected JSON item:
/// {
///   "user_id": "uuid",
///   "type": "INCOME" | "EXPENSE",
///   "month": "2024-04-01",
///   "total": 3500
/// }
///
/// Notes:
/// - Supabase may return numbers as int/double depending on the value.
/// - `month` is a date string (YYYY-MM-DD). We parse to DateTime (UTC).
class MonthTotalDto {
  final String userId;
  final String type; // INCOME | EXPENSE
  final DateTime month; // first day of the month
  final double total;

  const MonthTotalDto({
    required this.userId,
    required this.type,
    required this.month,
    required this.total,
  });

  factory MonthTotalDto.fromJson(Map<String, dynamic> json) {
    final userId = (json['user_id'] ?? '').toString().trim();
    final type = (json['type'] ?? '').toString().trim();
    final monthRaw = (json['month'] ?? '').toString().trim();
    final totalRaw = json['total'];

    if (userId.isEmpty) {
      throw const FormatException('MonthTotalDto: user_id is missing');
    }
    if (type.isEmpty) {
      throw const FormatException('MonthTotalDto: type is missing');
    }
    if (monthRaw.isEmpty) {
      throw const FormatException('MonthTotalDto: month is missing');
    }

    final parsedMonth = DateTime.tryParse(monthRaw);
    if (parsedMonth == null) {
      throw FormatException('MonthTotalDto: invalid month date: $monthRaw');
    }

    final total = _parseDouble(totalRaw);
    return MonthTotalDto(
      userId: userId,
      type: type,
      month: parsedMonth.toUtc(),
      total: total,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user_id': userId,
      'type': type,
      'month': month.toIso8601String(),
      'total': total,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
