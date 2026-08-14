import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'audio_tts_button.dart';

class HtmlRenderWithAudio extends StatelessWidget {
  final String htmlContent;
  final TextStyle? textStyle;
  final bool showAudioButton;

  const HtmlRenderWithAudio({
    super.key,
    required this.htmlContent,
    this.textStyle,
    this.showAudioButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (htmlContent.trim().isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAudioButton)
          Align(
            alignment: Alignment.centerRight,
            child: AudioTtsButton(
              htmlContent: htmlContent,
              iconSize: 22.0,
            ),
          ),
        HtmlWidget(
          htmlContent,
          textStyle: textStyle,
        ),
      ],
    );
  }
}
