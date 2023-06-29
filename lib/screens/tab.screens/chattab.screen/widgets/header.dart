import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatHeaderWidget extends StatelessWidget {
  const ChatHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      foregroundColor: AppColor.darkBlackColor,
      centerTitle: true,
      title: BaseText(
          title: AppLocalizations.of(context)!.chatPanchamhi,
          style: const TextStyle(color: AppColor.darkBlackColor)),
    );
  }
}
