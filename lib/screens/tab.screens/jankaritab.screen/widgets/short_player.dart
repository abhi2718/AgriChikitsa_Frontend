import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/full_screen_youtube.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  const Player({super.key, required this.videoUrl, required this.aspectRatio, this.feedId});
  final String videoUrl;
  final double aspectRatio;
  final String? feedId;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late YoutubePlayerController _controller;
  late HomeTabViewModel homeTabViewModel;
  bool _hasIncreasedView = false;
  bool _controllerInitialized = false;

  @override
  void initState() {
    super.initState();

    if (widget.feedId != null) {
      homeTabViewModel = Provider.of<HomeTabViewModel>(context, listen: false);
    }

    try {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl).toString(),
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      _controller.addListener(_videoListener);
      _controllerInitialized = true;
    } catch (e) {
      _controllerInitialized = false;
    }
  }

  void _videoListener() {
    if (_controller.value.isPlaying && !_hasIncreasedView && widget.feedId != null) {
      homeTabViewModel.increaseViews(context, widget.feedId!);
      _hasIncreasedView = true;
    }
  }

  @override
  void dispose() {
    if (_controllerInitialized) {
      _controller.removeListener(_videoListener);
      _controller.pause();
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (_controllerInitialized) {
          if (info.visibleFraction == 0) {
            _controller.pause();
          } else {
            _controller.play();
          }
        }
      },
      child: YoutubePlayer(
        aspectRatio: widget.aspectRatio,
        controller: _controller,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          IconButton(
            icon: const Icon(
              Icons.fullscreen,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              if (_controllerInitialized) {
                _controller.pause();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenYoutube(url: widget.videoUrl),
                ),
              );
            },
          ),
        ],
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
      ),
    );
  }
}
