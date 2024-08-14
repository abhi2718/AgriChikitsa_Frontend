import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../widgets/skeleton/skeleton.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.feedId != null
        ? homeTabViewModel = Provider.of<HomeTabViewModel>(context, listen: false)
        : null;
    _controller = YoutubePlayerController(
      // initialVideoId: YoutubePlayer.convertUrlToId(
      //         "https://d36yh71dpxszen.cloudfront.net/${temp[temp.length - 1]}")
      //     .toString(),
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl).toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _controller.addListener(() {
      if (_controller.value.isPlaying && !_hasIncreasedView && widget.feedId != null) {
        homeTabViewModel.increaseViews(context, widget.feedId!);
        _hasIncreasedView = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(widget.videoUrl), // Unique key for each post
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            _controller.pause();
          } else {
            // _controller.play(); // Play video when in view
          }
        },
        child:
            // _controller.value.isReady
            // ?
            YoutubePlayer(
          aspectRatio: widget.aspectRatio,
          controller: _controller,
          bottomActions: const [],
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          onReady: () {},
        )
        // : Skeleton(
        //     height: MediaQuery.sizeOf(context).width - 16,
        //     width: MediaQuery.sizeOf(context).width - 16,
        //     radius: 0,
        //   ),
        );
  }
}
