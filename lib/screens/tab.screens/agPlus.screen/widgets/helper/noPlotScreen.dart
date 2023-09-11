import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class NoPlotScreen extends HookWidget {
  const NoPlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/lottie/clickHere.json'),
          Text(
            "No Plot Added\nTap to Add New Plot",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
