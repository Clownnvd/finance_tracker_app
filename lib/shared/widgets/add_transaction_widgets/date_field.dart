import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final DateTime value;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.value,
    required this.onTap,
  });

  String _fmt(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(),
        ),
        child: Row(
          children: [
            Expanded(child: Text(_fmt(value))),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
}
