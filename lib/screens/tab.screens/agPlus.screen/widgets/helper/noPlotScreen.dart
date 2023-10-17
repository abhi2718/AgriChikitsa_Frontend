import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            AppLocalizations.of(context)!.noFieldAddedhi,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
