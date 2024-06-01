import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final int? maxLines;
  const CustomTextWidget(
      {super.key, required this.text, required this.textStyle, required this.maxLines});

  @override
  Widget build(BuildContext context) {
    final pattern = RegExp(r'\B#\w*[a-zA-Z]+\w*');
    final matches = pattern.allMatches(text);

    List<InlineSpan> children = [];

    int currentPosition = 0;
    for (var match in matches) {
      final hashtagText = match.group(0);
      if (hashtagText != null) {
        children.add(TextSpan(
          text: text.substring(currentPosition, match.start),
          style: textStyle,
        ));
        children.add(TextSpan(
          text: hashtagText,
          style: textStyle.copyWith(fontWeight: FontWeight.bold),
        ));
        currentPosition = match.end;
      }
    }

    children.add(TextSpan(
      text: text.substring(currentPosition),
      style: textStyle,
    ));

    return RichText(
      text: TextSpan(children: children),
      maxLines: maxLines,
    );
  }
}
