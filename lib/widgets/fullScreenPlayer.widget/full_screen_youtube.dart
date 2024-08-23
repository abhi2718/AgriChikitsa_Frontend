import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenYoutube extends StatefulWidget {
  const FullScreenYoutube({super.key, required this.url});
  final String url;

  @override
  State<FullScreenYoutube> createState() => _FullScreenYoutubeState();
}

class _FullScreenYoutubeState extends State<FullScreenYoutube> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _controller = YoutubePlayerController(
      // initialVideoId: YoutubePlayer.convertUrlToId(
      //         "https://d36yh71dpxszen.cloudfront.net/${temp[temp.length - 1]}")
      //     .toString(),
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url).toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}
