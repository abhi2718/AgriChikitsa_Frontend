import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/helper/video_position_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenYoutubeFeed extends StatefulWidget {
  const FullScreenYoutubeFeed({
    super.key,
    required this.videoId,
    required this.url,
    this.startAt = Duration.zero,
  });

  final String videoId;
  final String url;
  final Duration startAt;

  @override
  State<FullScreenYoutubeFeed> createState() => _FullScreenYoutubeFeedState();
}

class _FullScreenYoutubeFeedState extends State<FullScreenYoutubeFeed> {
  late YoutubePlayerController _controller;
  bool _isExiting = false;
  bool _hasStartedPlaying = false;

  // ADD method to _FullScreenYoutubeState:
  void _onControllerUpdate() {
    if (!_hasStartedPlaying &&
        _controller.value.isPlaying &&
        _controller.value.position.inMilliseconds > 0) {
      setState(() => _hasStartedPlaying = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        startAt: widget.startAt.inSeconds,
        hideControls: false,
        enableCaption: false,
        forceHD: false,
      ),
    );
    // Force landscape after controller is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });
    _controller.addListener(_onControllerUpdate);
  }

  Future<void> _exit() async {
    if (_isExiting) return;
    _isExiting = true;

    // Save position before anything else
    VideoPositionManager.instance.save(
      widget.url,
      _controller.value.position,
    );

    _controller.pause();

    // Restore portrait and wait for it to settle
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Let the orientation animation complete before popping
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // Failsafe — if disposed without _exit being called (e.g. OS kill)
    VideoPositionManager.instance.save(
      widget.url,
      _controller.value.position,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    _controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _exit();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: YoutubePlayerBuilder(
          onEnterFullScreen: () {}, // no-op, we handle fullscreen ourselves
          onExitFullScreen: () {}, // no-op
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: const ProgressBarColors(
                  playedColor: AppColor.darkColor,
                ),
              ),
              RemainingDuration(),
              IconButton(
                icon: const Icon(
                  Icons.fullscreen_exit,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _exit,
              ),
            ],
            topActions: const [SizedBox.shrink()],
          ),
          // REPLACE the builder: line inside YoutubePlayerBuilder:
          builder: (context, player) => Stack(
            children: [
              Center(child: player),
              // Black overlay hides thumbnail until video actually starts playing
              if (!_hasStartedPlaying) Container(color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
