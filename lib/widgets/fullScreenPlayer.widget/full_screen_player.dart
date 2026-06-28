import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  const FullScreenPlayer({super.key, required this.videoUrl, this.feed});
  final String videoUrl;
  final dynamic? feed;
  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late VideoPlayerController _controller;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(Utils.getCloudFrontUrl(widget.videoUrl)))
      ..addListener(() {
        setState(() {});
      })
      ..initialize().then((value) => _controller.play());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    isExpanded = false;
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void toggleCaption() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final user = widget.feed['user'];
    return Container(
      width: dimension["width"],
      height: dimension["height"],
      color: AppColor.darkBlackColor,
      child: Stack(
        children: [
          _controller.value.isInitialized
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller),
                        Opacity(
                          opacity: _controller.value.isPlaying ? 0 : 1,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 50.0,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                  color: AppColor.darkColor,
                )),
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.whiteColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Positioned(
              bottom: 20, // Position the container at the bottom
              left: 10,
              right: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user['profileImage']),
                    radius: 25,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user['userHandler'] ?? "@username",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        widget.feed["hindiCaption"] != null
                            ? GestureDetector(
                                onTap: toggleCaption,
                                child: CustomTextWidget(
                                  text: widget.feed["hindiCaption"],
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.whiteColor),
                                  maxLines: isExpanded ? null : 2,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
