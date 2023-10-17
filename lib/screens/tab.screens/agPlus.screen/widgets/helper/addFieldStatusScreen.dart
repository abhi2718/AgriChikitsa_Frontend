import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/text.widgets/text.dart';
import '../../agPlus_view_model.dart';

class FieldStatusScreen extends HookWidget {
  const FieldStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      Timer(Duration(milliseconds: 2500), () {
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
                  useViewModel.fieldStatus
                      ? 'assets/lottie/success.json'
                      : 'assets/lottie/fail.json',
                  height: dimension['height']! * 0.30,
                  width: dimension['width']! * 0.50,
                ),
                BaseText(
                  title: useViewModel.fieldStatus!
                      ? AppLocalizations.of(context)!.successFieldMessagehi
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
