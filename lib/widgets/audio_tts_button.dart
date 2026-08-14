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
    this.iconSize = 24.0,
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
    final activeColor = widget.color ?? AppColor.extraDark;

    if (widget.useElevatedButton) {
      final buttonText = _isPlaying
          ? (AppLocalization.of(context).getTranslatedValue("pauseAudio").toString() == "pauseAudio"
              ? "रुकें"
              : AppLocalization.of(context).getTranslatedValue("pauseAudio").toString())
          : (AppLocalization.of(context).getTranslatedValue("playAudio").toString() == "playAudio"
              ? "सुनें"
              : AppLocalization.of(context).getTranslatedValue("playAudio").toString());

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.tabIconColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: _toggleSpeak,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return IconButton(
      icon: Icon(
        _isPlaying ? Icons.stop_circle_outlined : Icons.volume_up_rounded,
        color: _isPlaying ? Colors.redAccent : activeColor,
        size: widget.iconSize,
      ),
      tooltip: _isPlaying ? "Stop Audio" : "Listen Audio",
      onPressed: _toggleSpeak,
    );
  }
}
