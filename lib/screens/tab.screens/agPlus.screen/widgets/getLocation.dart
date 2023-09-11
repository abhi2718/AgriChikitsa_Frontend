import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/location.screen/getCurrentLocation.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/selectCrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Image.asset('assets/svg/Address.png'),
          // ),
          Lottie.asset(
            'assets/lottie/location.json',
            height: dimension['height']! * 0.30,
            width: dimension['width']! * 0.50,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: BaseText(
              title:
                  "To get the right results, it is important to open location of your mobile.",
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          CustomElevatedButton(
              title: "Enable Location",
              onPress: () {
                Utils.model(context, GetCurrentLocation());
              })
        ],
      ),
    );
  }
}
