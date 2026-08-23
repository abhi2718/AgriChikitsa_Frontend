import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../l10n/app_localizations.dart';
import '../res/color.dart';
import '../utils/utils.dart';

class AudioTtsButton extends StatefulWidget {
  final String htmlContent;
  final Color? color;
  final double iconSize;
  final bool useElevatedButton;

  const AudioTtsButton({
    super.key,
    required this.htmlContent,
    this.color,
    this.iconSize = 20.0,
    this.useElevatedButton = false,
  });

  @override
  State<AudioTtsButton> createState() => _AudioTtsButtonState();
}

class _AudioTtsButtonState extends State<AudioTtsButton> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _flutterTts.setStartHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    });

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    _flutterTts.setErrorHandler((msg) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    _flutterTts.setCancelHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _toggleSpeak() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    } else {
      final textToSpeak = Utils.cleanHtmlTags(widget.htmlContent);
      if (textToSpeak.isEmpty) return;

      final localeStr = AppLocalization.of(context).locale.toString();
      final language = localeStr == "hi" ? "hi-IN" : "en-US";

      await _flutterTts.setLanguage(language);
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setPitch(1.0);

      final result = await _flutterTts.speak(textToSpeak);
      if (result == 1) {
        if (mounted) {
          setState(() {
            _isPlaying = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Utils.cleanHtmlTags(widget.htmlContent).trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onTap: _toggleSpeak,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: AppColor.tabIconColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.volume_up_rounded,
          color: widget.color ?? Colors.white,
          size: widget.iconSize,
        ),
      ),
    );
  }
}
