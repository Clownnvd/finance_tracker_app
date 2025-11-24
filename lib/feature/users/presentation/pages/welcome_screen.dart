import 'package:finance_tracking_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget wallet = Assets.icons.walletSolid.svg(
      width: 240,
      height: 120,
      colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn)
    );
    return Scaffold(
      body: Column(
        children: [
          wallet,
          const Text('Welcome'),
          const SizedBox(height: 12),
          const Text('Take control of your finances with us.'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: Text('Get Started')),
        ],
      ),
    );
  }
}
