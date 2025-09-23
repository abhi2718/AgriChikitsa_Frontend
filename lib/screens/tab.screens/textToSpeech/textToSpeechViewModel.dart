import 'dart:developer';

import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';

class TextToSpeechViewModel extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();

  bool isLoading = false;
  bool isSpeaking = false;
  bool isPaused = false;
  String textToRead = "";

  void reinitalize() {
    isSpeaking = false;
    isPaused = false;
    isLoading = false;
    textToRead = "";
  }

  void disposeValues() {
    isSpeaking = false;
    isPaused = false;
    isLoading = false;
    textToRead = "";
  }

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  void setText(String text) {
    textToRead = text;
    notifyListeners();
  }

  TextToSpeechViewModel() {
    _flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      isPaused = false;
      notifyListeners();
    });
  }

  Future<void> speak(BuildContext context, {String languageCode = "hi-IN"}) async {
    try {
      if (textToRead.isEmpty) return;
      setIsLoading(true);
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.setSpeechRate(0.4);
      final maxLen = await _flutterTts.getMaxSpeechInputLength ?? 4000;
      final textToSpeak = textToRead.length > maxLen ? textToRead.substring(0, maxLen) : textToRead;
      await _flutterTts.speak(textToSpeak).then((value) => setIsLoading(false));
      isSpeaking = true;
      isPaused = false;
      notifyListeners();
    } catch (e) {
      setIsLoading(false);
      if (context.mounted) {
        Utils.toastMessage(
            AppLocalization.of(context).getTranslatedValue("errorMessage").toString());
      }
    }
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    isPaused = true;
    notifyListeners();
  }

  Future<void> resume(BuildContext context) async {
    await speak(context);
    isPaused = false;
    notifyListeners();
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    setIsLoading(false);
    isSpeaking = false;
    isPaused = false;
    notifyListeners();
  }
}
