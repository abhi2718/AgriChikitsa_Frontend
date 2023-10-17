import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/createPlot.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/location.screen/getCurrentLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/text.widgets/text.dart';

class GetLocation extends HookWidget {
  const GetLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    Future<bool> _onWillPop() async {
      Navigator.pop(context);
      Utils.model(context, CreatePlot());
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.notificationBgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/location.json',
              height: dimension['height']! * 0.30,
              width: dimension['width']! * 0.50,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: BaseText(
                title: AppLocalizations.of(context)!.uploadFieldLocationhi,
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            CustomElevatedButton(
                title: AppLocalizations.of(context)!.enableLocationhi,
                onPress: () {
                  Navigator.pop(context);
                  Utils.model(context, GetCurrentLocation());
                })
          ],
        ),
      ),
    );
  }
}
