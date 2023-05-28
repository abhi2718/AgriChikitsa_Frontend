import 'package:flutter/material.dart';
import 'package:agriChikitsa/res/color.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double elevation;
  final Color cardColor;
  const CustomCard(
      {super.key,
      required this.child,
      this.padding = 10.0,
      this.borderColor = AppColor.lightColor,
      this.borderWidth = 1,
      this.borderRadius = 6,
      this.elevation = 4,
      this.cardColor = AppColor.whiteColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class LightContainer extends StatelessWidget {
  final Widget child;
  final double padding;
  const LightContainer({super.key, required this.child, this.padding = 10});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      cardColor: AppColor.lightColor,
      padding: padding,
      borderColor: AppColor.darkColor,
      child: child,
    );
  }
}

class WhiteContainer extends StatelessWidget {
  final Widget child;
  final double padding;
  const WhiteContainer({super.key, required this.child, this.padding = 10});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      cardColor: AppColor.whiteColor,
      padding: padding,
      borderColor: AppColor.darkColor,
      child: child,
    );
  }
}
