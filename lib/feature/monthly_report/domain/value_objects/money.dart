/// A tiny value object for handling money safely across the app.
///
/// Why:
/// - Avoid passing raw doubles everywhere.
/// - Centralize rounding & arithmetic rules.
/// - Keep domain entities expressive (income/expense/balance are Money).
///
/// Notes:
/// - This is NOT a formatting class for UI widgets.
/// - UI can format using `asFixed(0/2)` or your formatter later.
class Money {
  /// Stored as a double for simplicity.
  /// We normalize to 2 decimal places to reduce floating precision issues.
  final double value;

  const Money._(this.value);

  /// Creates Money and normalizes to 2 decimal places.
  factory Money(double raw) {
    return Money._(_round2(raw));
  }

  static const Money zero = Money._(0.0);

  Money operator +(Money other) => Money(value + other.value);
  Money operator -(Money other) => Money(value - other.value);

  Money abs() => Money(value.abs());

  bool get isNegative => value < 0;
  bool get isZero => value == 0;

  /// Useful for comparing spending, etc.
  bool operator <(Money other) => value < other.value;
  bool operator <=(Money other) => value <= other.value;
  bool operator >(Money other) => value > other.value;
  bool operator >=(Money other) => value >= other.value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Money && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Money($value)';
}

double _round2(double v) {
  // Avoid NaN/Infinity propagating silently.
  if (v.isNaN || v.isInfinite) return 0.0;

  // Round to 2 decimals.
  return (v * 100).roundToDouble() / 100;
}
