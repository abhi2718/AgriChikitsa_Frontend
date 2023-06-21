import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

import '../../../../res/color.dart';
import '../../../../utils/utils.dart';

class ChatLoader extends StatelessWidget {
  const ChatLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, bottom: 10),
          padding: const EdgeInsets.only(
            top: 14,
          ),
          height: dimension['height']! * 0.05,
          width: dimension['width']! * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.chatBubbleColor,
          ),
          child: Center(
            child: JumpingDots(
              color: AppColor.whiteColor,
              radius: 4,
              numberOfDots: 3,
              animationDuration: const Duration(milliseconds: 200),
            ),
          ),
        )
      ],
    );
  }
}
