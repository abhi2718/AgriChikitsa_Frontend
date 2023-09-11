import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agPlus_view_model.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';

class CreatePlot extends HookWidget {
  const CreatePlot({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/animation_lm8y2fde.json',
            height: dimension['height']! * 0.30,
            width: dimension['width']! * 0.50,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: BaseText(
              title:
                  "To get the right results, it is important to be in the middle of the field while taking the Photo.",
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          CustomElevatedButton(
              title: "Open Camera",
              onPress: () => useViewModel.uploadImage(context))
        ],
      ),
    );
  }
}
