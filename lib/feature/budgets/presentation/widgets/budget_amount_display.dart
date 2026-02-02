import 'package:flutter/material.dart';

class BudgetAmountDisplay extends StatelessWidget {
  final String amountText;

  const BudgetAmountDisplay({
    super.key,
    required this.amountText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        amountText,
        style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
