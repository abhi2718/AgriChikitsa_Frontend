import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShortsPlayer extends StatelessWidget {
  const ShortsPlayer({super.key, required this.videoUrl, required this.aspectRatio});
  final String videoUrl;
  final double aspectRatio;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
      ),
      body: Center(
        child: Player(
          videoUrl: videoUrl,
          aspectRatio: aspectRatio,
        ),
      ),
    );
  }
}

class Player extends StatefulWidget {
  const Player({super.key, required this.videoUrl, required this.aspectRatio});
  final String videoUrl;
  final double aspectRatio;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl).toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl), // Unique key for each post
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          _controller.pause(); // Pause video when out of view
        } else {
          _controller.play(); // Play video when in view
        }
      },
      child: YoutubePlayer(
        aspectRatio: widget.aspectRatio,
        controller: _controller,
        bottomActions: const [],
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
      ),
    );
  }
}
