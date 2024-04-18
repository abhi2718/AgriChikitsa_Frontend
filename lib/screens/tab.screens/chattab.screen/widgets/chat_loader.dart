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
        const SizedBox(
          width: 8,
        ),
        CircleAvatar(
          backgroundImage: const AssetImage('assets/images/botIcon.png'),
          radius: dimension['height']! * 0.035,
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, bottom: 10),
          padding: const EdgeInsets.only(
            top: 14,
          ),
          height: dimension['height']! * 0.05,
          width: dimension['width']! * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.whiteColor,
          ),
          child: Center(
            child: JumpingDots(
              color: AppColor.extraDark,
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
