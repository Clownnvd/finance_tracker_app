/// DTO for "Top Expenses" query from `transactions` table.
///
/// Expected JSON item (based on your PostgREST select):
/// {
///   "id": 1,
///   "amount": 800,
///   "type": "EXPENSE",
///   "date": "2024-04-10",
///   "note": "Rent",
///   "category_id": 3,
///   "categories": { "name": "Housing", "icon": "house" }
/// }
///
/// Notes:
/// - `categories` can be null if FK data missing or select not joined.
/// - `amount` can be int/double/string.
/// - `date` is "YYYY-MM-DD".
class TopExpenseDto {
  final int id;
  final double amount;
  final String type; // should be EXPENSE
  final DateTime date;
  final String? note;

  final int categoryId;
  final String? categoryName;
  final String? categoryIcon;

  const TopExpenseDto({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.categoryId,
    this.note,
    this.categoryName,
    this.categoryIcon,
  });

  factory TopExpenseDto.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final amountRaw = json['amount'];
    final type = (json['type'] ?? '').toString().trim();
    final dateRaw = (json['date'] ?? '').toString().trim();
    final note = json['note']?.toString();

    final categoryIdRaw = json['category_id'];
    final categoriesRaw = json['categories'];

    if (idRaw == null) {
      throw const FormatException('TopExpenseDto: id is missing');
    }
    if (categoryIdRaw == null) {
      throw const FormatException('TopExpenseDto: category_id is missing');
    }
    if (type.isEmpty) {
      throw const FormatException('TopExpenseDto: type is missing');
    }
    if (dateRaw.isEmpty) {
      throw const FormatException('TopExpenseDto: date is missing');
    }

    final parsedDate = DateTime.tryParse(dateRaw);
    if (parsedDate == null) {
      throw FormatException('TopExpenseDto: invalid date: $dateRaw');
    }

    String? categoryName;
    String? categoryIcon;

    // PostgREST embedded object may be a Map, or a List if relationship is 1..n.
    if (categoriesRaw is Map) {
      categoryName = categoriesRaw['name']?.toString();
      categoryIcon = categoriesRaw['icon']?.toString();
    } else if (categoriesRaw is List && categoriesRaw.isNotEmpty) {
      final first = categoriesRaw.first;
      if (first is Map) {
        categoryName = first['name']?.toString();
        categoryIcon = first['icon']?.toString();
      }
    }

    return TopExpenseDto(
      id: _parseInt(idRaw),
      amount: _parseDouble(amountRaw),
      type: type,
      date: parsedDate.toUtc(),
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      categoryId: _parseInt(categoryIdRaw),
      categoryName: categoryName?.trim().isEmpty == true ? null : categoryName?.trim(),
      categoryIcon: categoryIcon?.trim().isEmpty == true ? null : categoryIcon?.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'note': note,
      'category_id': categoryId,
      'categories': <String, dynamic>{
        'name': categoryName,
        'icon': categoryIcon,
      },
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
