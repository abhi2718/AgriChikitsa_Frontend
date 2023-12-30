import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class ShortsPlayer extends StatefulWidget {
//   const ShortsPlayer({super.key, required this.videoUrl});
//   final String videoUrl;
//   @override
//   State<ShortsPlayer> createState() => _ShortsPlayerState();
// }

// class _ShortsPlayerState extends State<ShortsPlayer> {
//   late YoutubePlayerController _controller;
//   late String videoId;

//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     videoId = "";
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

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

class Player extends StatelessWidget {
  const Player({super.key, required this.videoUrl, required this.aspectRatio});
  final String videoUrl;
  final double aspectRatio;
  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      aspectRatio: aspectRatio,
      controller: YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoUrl).toString(),
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      ),
      bottomActions: const [],
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
    );
  }
}
