import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/full_screen_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../widgets/skeleton/skeleton.dart';

class PostWidget extends StatefulWidget {
  final String videoUrl;
  final String? postId;
  final dynamic feed;
  const PostWidget({required this.videoUrl, this.postId, this.feed, Key? key}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late VideoPlayerController _controller;
  late HomeTabViewModel homeTabViewModel;
  bool _isManuallyPaused = true; // Flag to track manual pause

  @override
  void initState() {
    super.initState();
    widget.postId != null
        ? homeTabViewModel = Provider.of<HomeTabViewModel>(context, listen: false)
        : null;
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(Utils.getCloudFrontUrl(widget.videoUrl)))
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _isManuallyPaused = false;
        });
      });
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _controller.pause();
          _isManuallyPaused = true;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isManuallyPaused = true;
      } else {
        widget.postId != null ? homeTabViewModel.increaseViews(context, widget.postId!) : null;
        _controller.play();
        _isManuallyPaused = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          setState(() {
            _controller.pause();
          });
        }
        //  else if (!_isManuallyPaused) {
        //   setState(() {
        //     _controller.play();
        //   });
        // }
        else {
          setState(() {
            _controller.play();
          });
        }
      },
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  // _ControlsOverlay(controller: _controller),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.pause();
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenPlayer(
                                videoUrl: widget.videoUrl,
                                feed: widget.feed,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            )
          : Skeleton(
              height: MediaQuery.sizeOf(context).width - 16,
              width: MediaQuery.sizeOf(context).width - 16,
              radius: 0,
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
