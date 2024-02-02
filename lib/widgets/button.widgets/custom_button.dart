import 'package:flutter/material.dart';

import '../text.widgets/text.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.height,
      required this.width,
      required this.color,
      required this.titleColor,
      this.borderRadius = 12,
      this.fontSize = 14,
      required this.title});
  dynamic height;
  dynamic width;
  Color color;
  Color titleColor;
  double borderRadius;
  String title;
  double fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(borderRadius)),
      child: Center(
          child: BaseText(
        title: title,
        style: TextStyle(
            color: titleColor, fontSize: fontSize, fontWeight: FontWeight.w500),
      )),
    );
  }
}
