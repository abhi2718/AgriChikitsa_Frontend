import 'dart:async';

import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/agristick.screen/agristick_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../../../res/color.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../widgets/text.widgets/text.dart';

class AgriStickStatusScreen extends HookWidget {
  const AgriStickStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AgristickViewModel>(context, listen: false);
    useEffect(() {
      Timer(const Duration(milliseconds: 2500), () {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }, []);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.notificationBgColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  useViewModel.agristickStatus
                      ? 'assets/lottie/success.json'
                      : 'assets/lottie/fail.json',
                  height: dimension['height']! * 0.30,
                  width: dimension['width']! * 0.50,
                ),
                BaseText(
                  title: useViewModel.agristickStatus
                      ? AppLocalizations.of(context)!.successAgristickMessagehihi
                      : AppLocalizations.of(context)!.errorMessagehi,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
