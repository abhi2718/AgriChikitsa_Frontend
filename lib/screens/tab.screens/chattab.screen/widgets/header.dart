import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';

class ChatHeaderWidget extends StatelessWidget {
  const ChatHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      foregroundColor: AppColor.darkBlackColor,
      centerTitle: true,
      title: const BaseText(
          title: "Chat Pancham",
          style: TextStyle(color: AppColor.darkBlackColor)),
    );
  }
}
