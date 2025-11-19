import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerViewModel extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isLoading = false;
  bool isPlaying = false;
  bool isPaused = false;
  String audioUrl = "";

  void reinitalize() {
    isPaused = false;
    isLoading = false;
    isPlaying = false;
    audioUrl = "";
  }

  void disposeValues() {
    isPaused = false;
    isLoading = false;
    isPlaying = false;
    audioUrl = "";
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setAudioUrl(String url) {
    audioUrl = url;
    notifyListeners();
  }

  AudioPlayerViewModel() {
    _audioPlayer.playerStateStream.listen((state) {
      final playing = state.playing;
      final completed = state.processingState == ProcessingState.completed;

      if (completed) {
        isPlaying = false;
        isPaused = false;
        isLoading = false;
        notifyListeners();
      } else {
        isPlaying = playing;
        notifyListeners();
      }
    });
  }

  Future<void> play(BuildContext context) async {
    try {
      if (audioUrl.isEmpty) return;
      setIsLoading(true);
      await _audioPlayer.setUrl(audioUrl);
      _audioPlayer.play();
      setIsLoading(false);
      isPlaying = true;
      isPaused = false;
      notifyListeners();
    } catch (e) {
      setIsLoading(false);
      if (context.mounted) {
        Utils.toastMessage(
          AppLocalization.of(context).getTranslatedValue("errorMessage").toString(),
        );
      }
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    isPaused = true;
    isPlaying = false;
    notifyListeners();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
    isPaused = false;
    isPlaying = true;
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    isPlaying = false;
    isPaused = false;
    setIsLoading(false);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
