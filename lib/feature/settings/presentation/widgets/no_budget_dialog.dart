import 'package:flutter/material.dart';

Future<bool?> showNoBudgetDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('No Budget set'),
      content: const Text(
        'You haven’t set a budget for\nany categories. Would you like\nto set one now?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Set Budget'),
        ),
      ],
    ),
  );
}
