/// A small value object representing a specific month in a specific year.
///
/// Why this exists:
/// - Centralizes month range calculations (start/end date).
/// - Prevents timezone-related off-by-one issues when working with `date` (YYYY-MM-DD).
/// - Provides stable keys for caching (e.g., "2024-04").
///
/// Notes:
/// - We use UTC to avoid local timezone shifting the date boundary.
class ReportMonth {
  final int year;

  /// 1..12
  final int month;

  const ReportMonth({
    required this.year,
    required this.month,
  }) : assert(month >= 1 && month <= 12, 'month must be in range 1..12');

  /// Start date of the month in UTC.
  DateTime get startDateUtc => DateTime.utc(year, month, 1);

  /// End date of the month in UTC (last day).
  DateTime get endDateUtc {
    final nextMonth = month == 12 ? 1 : month + 1;
    final nextYear = month == 12 ? year + 1 : year;

    // First day of next month minus 1 day.
    return DateTime.utc(nextYear, nextMonth, 1).subtract(const Duration(days: 1));
  }

  /// Example: "April 2024"
  String get label => '${_monthName(month)} $year';

  /// Example: "2024-04"
  String get key => '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';

  /// ISO date for Supabase/PostgREST: YYYY-MM-DD
  String get startIso => _toIsoDate(startDateUtc);

  /// ISO date for Supabase/PostgREST: YYYY-MM-DD
  String get endIso => _toIsoDate(endDateUtc);

  factory ReportMonth.fromDate(DateTime date) {
    return ReportMonth(year: date.year, month: date.month);
  }

  ReportMonth next() {
    if (month == 12) return ReportMonth(year: year + 1, month: 1);
    return ReportMonth(year: year, month: month + 1);
  }

  ReportMonth previous() {
    if (month == 1) return ReportMonth(year: year - 1, month: 12);
    return ReportMonth(year: year, month: month - 1);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportMonth && other.year == year && other.month == month);

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => 'ReportMonth(year: $year, month: $month)';
}

String _toIsoDate(DateTime utcDate) {
  final y = utcDate.year.toString().padLeft(4, '0');
  final m = utcDate.month.toString().padLeft(2, '0');
  final d = utcDate.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String _monthName(int month) {
  const names = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return names[month - 1];
}
