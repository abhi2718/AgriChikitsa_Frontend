import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/helper/video_position_manager.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  const FullScreenVideo({
    super.key,
    required this.videoUrl,
    required this.videoSize,
    this.startAt = Duration.zero,
    this.isMuted = false,
  });

  final String videoUrl;
  final Size videoSize;
  final Duration startAt;
  final bool isMuted;

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isExiting = false;

  // ADD inside _FullScreenVideoState, before initState:
  List<DeviceOrientation> _orientationsForSize(Size size) {
    if (size.width >= size.height) {
      // Landscape or square — force landscape
      return [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ];
    } else {
      // Portrait — stay portrait
      return [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    var temp = widget.videoUrl.split('/');
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        "https://d36yh71dpxszen.cloudfront.net/${temp[temp.length - 1]}",
      ),
    );
    _videoController.initialize().then((_) {
      if (!mounted) return;
      _videoController.seekTo(widget.startAt);
      _videoController.setVolume(widget.isMuted ? 0 : 1);
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        allowFullScreen: false,
        allowMuting: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColor.darkColor,
          handleColor: AppColor.darkColor,
        ),
      );
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations(
        _orientationsForSize(widget.videoSize),
      );
    });
  }

  Future<void> _exit() async {
    if (_isExiting) return;
    _isExiting = true;

    VideoPositionManager.instance.save(
      widget.videoUrl,
      _videoController.value.position,
    );

    _videoController.pause();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    VideoPositionManager.instance.save(
      widget.videoUrl,
      _videoController.value.position,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _chewieController?.dispose();
    _videoController.dispose();
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
        body: Stack(
          children: [
            Center(
              child: _chewieController != null
                  ? Chewie(controller: _chewieController!)
                  : const CircularProgressIndicator(
                      color: AppColor.darkColor,
                    ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: GestureDetector(
                  onTap: _exit,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
