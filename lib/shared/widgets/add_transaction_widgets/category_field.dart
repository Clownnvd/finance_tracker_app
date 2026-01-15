import 'package:flutter/material.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

class CategoryField extends StatelessWidget {
  final CategoryEntity? value;
  final VoidCallback onTap;

  const CategoryField({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = value == null ? 'Select category' : value!.name;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
