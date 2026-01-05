import 'package:flutter/material.dart';

class AuthUi {
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void snack(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}

class AuthLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AuthLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black.withOpacity(0.2),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
