import 'package:flutter/material.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;

  const NoteField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Note (optional)',
        hintText: 'Add a note...',
      ),
    );
  }
}
