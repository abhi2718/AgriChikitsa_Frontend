import 'package:flutter/material.dart';
import 'package:agriChikitsa/widgets/card.widgets/card.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';

class ProfileButton extends StatelessWidget {
  final double width;
  final String title;
  final String leftIcon;
  final void Function()? onPress;

  const ProfileButton({
    super.key,
    this.width = 200,
    required this.title,
    required this.leftIcon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: LightContainer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          width: width,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    leftIcon,
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ParagraphHeadingText(title)
                ],
              ),
              Image.asset(
                "assets/images/arrow.png",
                height: 16,
                width: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
