import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ResharePost extends StatefulHookWidget {
  const ResharePost({super.key, required this.feed});
  final dynamic feed;

  @override
  State<ResharePost> createState() => _ResharePostState();
}

class _ResharePostState extends State<ResharePost> {
  VideoPlayerController? _currentVideoController;
  final TextEditingController _controller = TextEditingController();
  void _validate() {
    setState(() {
      if (_controller.text.isEmpty) {
        _errorText = 'This cannot be empty!';
      } else {
        _errorText = null;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_currentVideoController != null && _currentVideoController!.value.isInitialized) {
      _currentVideoController!.dispose();
    }
  }

  String? _errorText;
  @override
  Widget build(BuildContext context) {
    final authService = useMemoized(() => Provider.of<AuthService>(context, listen: false));
    final createPostModel = useMemoized(() => Provider.of<CreatePostModel>(context, listen: false));
    final user = User.fromJson(authService.userInfo["user"]);
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<HomeTabViewModel>(context, listen: false);
    final numberOfLikes = useState(widget.feed['likes'].length);
    final isLiked = useState(widget.feed['likes'].contains(user.sId));
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(),
      body: Consumer<HomeTabViewModel>(builder: (context, provider, child) {
        return provider.repostLoader
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.darkColor,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: const BoxDecoration(color: AppColor.whiteColor),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: user.profileImage!,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Skeleton(
                                      height: 40,
                                      width: 40,
                                      radius: 0,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    width: 40,
                                    fit: BoxFit.cover,
                                    height: 40,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                BaseText(
                                  title: user.name!,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            TextField(
                              controller: _controller,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 1,
                              decoration: InputDecoration(
                                  hintText: AppLocalization.of(context)
                                      .getTranslatedValue("shareYourThoughts")
                                      .toString(),
                                  hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
                                  border: InputBorder.none,
                                  errorText: _errorText),
                            ),
                            Container(
                                // height: 300,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.chatSent, width: 2),
                                  color: AppColor.whiteColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.feed["user"]['profileImage'],
                                                  progressIndicatorBuilder:
                                                      (context, url, downloadProgress) => Skeleton(
                                                    height: 40,
                                                    width: 40,
                                                    radius: 0,
                                                  ),
                                                  errorWidget: (context, url, error) =>
                                                      const Icon(Icons.error),
                                                  width: 40,
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  BaseText(
                                                    title: widget.feed["user"]['name'],
                                                    style: const TextStyle(
                                                        fontSize: 14, fontWeight: FontWeight.w700),
                                                  ),
                                                  BaseText(
                                                    title: widget.feed["user"]['userHandler'] ??
                                                        "@username",
                                                    style: const TextStyle(
                                                        fontSize: 14, fontWeight: FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    _buildPostMedia(context, widget.feed, dimension, useViewModel),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      isLiked.value
                                                          ? Icons.favorite_rounded
                                                          : Icons.favorite_outline_rounded,
                                                      color: AppColor.iconHeartColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 6,
                                                    ),
                                                    Text(numberOfLikes.value.toString())
                                                  ],
                                                ),
                                              ]),
                                        ],
                                      ),
                                    ),
                                    widget.feed['views'] != 0
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Text("${widget.feed['views']} Views"),
                                          )
                                        : const SizedBox.shrink(),
                                    widget.feed["hindiCaption"] != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomTextWidget(
                                                  text: widget.feed["hindiCaption"],
                                                  textStyle: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black),
                                                  maxLines:
                                                      useViewModel.isExpanded(widget.feed['_id'])
                                                          ? null
                                                          : 2,
                                                ),
                                                if (widget.feed["hindiCaption"].length > 140)
                                                  InkWell(
                                                    onTap: () => useViewModel
                                                        .toggleExpand(widget.feed['_id']),
                                                    child:
                                                        useViewModel.isExpanded(widget.feed['_id'])
                                                            ? Container()
                                                            : const BaseText(
                                                                title: "Read More",
                                                                style: TextStyle(
                                                                    color: AppColor.hyperlinkColor),
                                                              ),
                                                  ),
                                                Text(
                                                  useViewModel.getTimeAgo(
                                                      widget.feed['createdAt'], context),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black.withOpacity(0.6)),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const Spacer(),
                  InkWell(
                      onTap: _controller.text.trim().isEmpty
                          ? () {
                              _validate();
                            }
                          : () {
                              _validate();
                              useViewModel.resharePost(context, widget.feed["_id"],
                                  _controller.text.trim(), createPostModel);
                            },
                      child: GradientButton(
                          height: dimension['height']! * 0.08,
                          width: dimension['width']!,
                          title: AppLocalization.of(context)
                              .getTranslatedValue("submitButton")
                              .toString())),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
      }),
    );
  }

  Widget _buildPostMedia(
      BuildContext context, dynamic feed, dynamic dimension, HomeTabViewModel useViewModel) {
    if (feed['mediaType'] == "image") {
      final PageController pageController = PageController();
      return VisibilityDetector(
        key: Key(feed['_id']),
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            return;
          } else {
            if (!useViewModel.hasIncreasedViewForImage) {
              useViewModel.increaseViews(context, feed['_id']);
            }
          }
        },
        child: SizedBox(
          height: dimension["width"]! - 16 + 20,
          width: dimension["width"]!,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: feed["imgurls"].isNotEmpty ? feed["imgurls"].length : 1,
                  itemBuilder: (context, pagePosition) {
                    return CachedNetworkImage(
                      imageUrl: feed["imgurls"].isNotEmpty
                          ? feed['imgurls'][pagePosition]
                          : feed['imgurl'],
                      progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                        height: dimension["width"]! - 16,
                        width: dimension["width"]! - 16,
                        radius: 0,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              if (feed["imgurls"].isNotEmpty) // Add dots only if there are multiple images
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: feed["imgurls"].length,
                    effect: const SlideEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColor.extraDark,
                      dotColor: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    if (feed['mediaType'] == "video") {
      return _buildVideoPlayer(feed['videoUrl'], useViewModel, feed["_id"]);
    }
    if (feed['mediaType'] == "youtube") {
      return _buildYoutubePlayer(feed['videoUrl'], useViewModel, feed["_id"]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildVideoPlayer(String videoUrl, HomeTabViewModel homeTabViewModel, String feedId) {
    var temp = videoUrl.split('/');
    final videoController = VideoPlayerController.networkUrl(
        Uri.parse("https://d36yh71dpxszen.cloudfront.net/${temp[temp.length - 1]}"));

    return VisibilityDetector(
        key: Key(videoUrl),
        onVisibilityChanged: (visibilityInfo) {
          if (_currentVideoController != videoController) {
            _currentVideoController?.pause();
            _currentVideoController = videoController;
            videoController.initialize().then((_) {
              videoController.play();
            });
          }
        },
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: ChewieController(
              videoPlayerController: videoController,
              autoPlay: false,
              looping: false,
            ),
          ),
        ));
  }

  Widget _buildYoutubePlayer(String videoUrl, HomeTabViewModel homeTabViewModel, String feedId) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    final youtubeController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );

    return VisibilityDetector(
      key: Key(videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        youtubeController.play();
      },
      child: YoutubePlayer(
        controller: youtubeController,
        showVideoProgressIndicator: true,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(playedColor: AppColor.darkColor),
          ),
          // FullScreenButton()
        ],
      ),
    );
  }
}
