import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const DashboardHeader({
    super.key,
    required this.title,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: style,
    );
  }
}
