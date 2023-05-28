import 'package:flutter/material.dart';
import '../../res/color.dart';

class BaseText extends StatelessWidget {
  final String title;
  final TextStyle style;
  final TextAlign textAlign;
  const BaseText(
      {super.key,
      required this.title,
      required this.style,
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return (Text(
      title,
      textAlign: textAlign,
      style: style,
    ));
  }
}

class HeadingText extends StatelessWidget {
  final String title;
  const HeadingText(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    return BaseText(
      title: title,
      style: const TextStyle(
          color: AppColor.darkBlackColor,
          fontWeight: FontWeight.w500,
          fontSize: 24),
    );
  }
}

class SubHeadingText extends StatelessWidget {
  final String title;
  final double fontSize;
  final TextAlign textAlign;
  const SubHeadingText(
    this.title, {
    super.key,
    this.fontSize = 18,
    this.textAlign = TextAlign.start,
  });
  @override
  Widget build(BuildContext context) {
    return BaseText(
      title: title,
      textAlign: textAlign,
      style: TextStyle(
        color: AppColor.darkBlackColor,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
      ),
    );
  }
}

class ParagraphHeadingText extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  const ParagraphHeadingText(this.title,
      {super.key, this.textAlign = TextAlign.start});
  @override
  Widget build(BuildContext context) {
    return BaseText(
      title: title,
      style: const TextStyle(
        color: AppColor.darkBlackColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }
}

class ParagraphText extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  const ParagraphText(this.title,
      {super.key, this.textAlign = TextAlign.start});
  @override
  Widget build(BuildContext context) {
    return BaseText(
      title: title,
      textAlign: textAlign,
      style: const TextStyle(
          color: AppColor.midBlackColor,
          fontWeight: FontWeight.w400,
          fontSize: 14),
    );
  }
}
