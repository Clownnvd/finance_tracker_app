import 'package:flutter/material.dart';

typedef ErrorHandler = void Function(Object error, StackTrace stack);

Future<T?> safeAsync<T>(
  BuildContext context,
  Future<T> Function() task, {
  ErrorHandler? onError,
  String? userMessage,
}) async {
  try {
    return await task();
  } catch (e, st) {
    onError?.call(e, st);

    if (context.mounted) {
      final msg = userMessage ?? 'Something went wrong. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
    return null;
  }
}
