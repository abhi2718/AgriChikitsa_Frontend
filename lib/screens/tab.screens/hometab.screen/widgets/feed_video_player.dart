import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostWidget extends StatefulWidget {
  final String videoUrl;

  const PostWidget({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late VideoPlayerController _controller;
  bool _isManuallyPaused = false; // Flag to track manual pause

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isManuallyPaused = true;
      } else {
        _controller.play();
        _isManuallyPaused = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl), // Unique key for each post
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          _controller.pause(); // Pause video when out of view
        } else if (!_isManuallyPaused) {
          _controller.play(); // Play video when in view if not manually paused
        }
        setState(() {});
      },
      child: _controller.value.isInitialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50.0, // Adjust size as needed
                  ),
                  onPressed: _togglePlayPause,
                ),
              ],
            )
          : Container(), // Placeholder while video is loading
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
