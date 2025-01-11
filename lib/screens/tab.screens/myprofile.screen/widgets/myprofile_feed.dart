import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/createPost.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/timeline_comment_widget.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/full_screen_youtube.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../model/user_model.dart';
import '../../../../services/auth.dart';
import '../../../../widgets/skeleton/skeleton.dart';

class MyProfileFeed extends StatefulHookWidget {
  final feed;

  const MyProfileFeed({
    super.key,
    required this.feed,
  });

  @override
  State<MyProfileFeed> createState() => _MyProfileFeedState();
}

class _MyProfileFeedState extends State<MyProfileFeed> {
  VideoPlayerController? _currentVideoController;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final useViewModel = Provider.of<MyProfileViewModel>(context, listen: false);
    final homeViewModel = useMemoized(() => Provider.of<HomeTabViewModel>(context, listen: true));
    final userInfo = User.fromJson(authService.userInfo["user"]);
    final numberOfLikes = useState(widget.feed['likes'].length);
    final isLiked = useState(widget.feed['likes'].contains(userInfo.sId));
    final numberOfComments = useState(widget.feed['comments'].length);
    void setNumberOfComment(int count) {
      numberOfComments.value = count;
    }

    void handleLike() {
      useViewModel.toggleLike(
          context, widget.feed["_id"], isLiked.value, userInfo.sId!, homeViewModel);
      if (isLiked.value == true) {
        isLiked.value = false;
        numberOfLikes.value = numberOfLikes.value - 1;
      } else {
        isLiked.value = true;
        numberOfLikes.value = numberOfLikes.value + 1;
      }
    }

    final user = widget.feed['user'];
    // final imageName = feed['imgurl'].split(
    //     'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    // final profileImage = user['profileImage'].split(
    //     'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    final dimension = Utils.getDimensions(context, true);
    useEffect(() {
      if (useViewModel.isUserSwitchTheTab) {
        Future.delayed(const Duration(seconds: 2), () {
          useViewModel.setActiveTabIndex(false);
        });
      }
    }, []);
    useEffect(() {
      if (homeViewModel.increaseCommentNumber["id"] == widget.feed['_id']) {
        final count = homeViewModel.increaseCommentNumber["count"];
        numberOfComments.value = count;
      }
    }, [homeViewModel.increaseCommentNumber]);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      color: AppColor.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: user['profileImage'],
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
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          title: user['name'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        BaseText(
                          title: user['userHandler'] ?? "@username",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Utils.model(
                            context,
                            CreatePostScreen(
                              feed: widget.feed,
                              isEdit: widget.feed.containsKey("repostedFrom") ? true : false,
                            ));
                      },
                      child: const Icon(
                        Icons.edit,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return useViewModel.deleteLoader
                              ? AlertDialog(
                                  content: SizedBox(
                                    width: dimension['width'],
                                    height: dimension['height']! * 0.23,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColor.extraDark,
                                      ),
                                    ),
                                  ),
                                )
                              : AlertDialog(
                                  title: BaseText(
                                      title: AppLocalization.of(context)
                                          .getTranslatedValue("postDeleteTitle")
                                          .toString(),
                                      style: const TextStyle()),
                                  content: SizedBox(
                                    width: dimension['width'],
                                    height: dimension['height']! * 0.05,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BaseText(
                                          title: AppLocalization.of(context)
                                              .getTranslatedValue("postDeleteSubTitle")
                                              .toString(),
                                          style: const TextStyle(),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: BaseText(
                                          title: AppLocalization.of(context)
                                              .getTranslatedValue("yes")
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 16, color: AppColor.extraDark)),
                                      onPressed: () {
                                        useViewModel.postDelete(
                                            context, widget.feed['_id'], homeViewModel);
                                      },
                                    ),
                                    TextButton(
                                      child: BaseText(
                                          title: AppLocalization.of(context)
                                              .getTranslatedValue("no")
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 16, color: AppColor.extraDark)),
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      },
                                    ),
                                  ],
                                );
                        },
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // widget.feed['mediaType'] == 'image'
          //     ? SizedBox(
          //         height: dimension["width"]! - 16,
          //         width: dimension["width"]!,
          //         child: CachedNetworkImage(
          //           imageUrl: widget.feed['imgurl'],
          //           progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
          //             height: dimension["width"]! - 16,
          //             width: dimension["width"]! - 16,
          //             radius: 0,
          //           ),
          //           errorWidget: (context, url, error) => const Icon(Icons.error),
          //           fit: BoxFit.fill,
          //         ),
          //       )
          //     : widget.feed['mediaType'] == 'video'
          //         ? PostWidget(videoUrl: widget.feed['videoUrl'])
          //         : Player(videoUrl: widget.feed['videoUrl'], aspectRatio: 16 / 9),

          widget.feed.containsKey("repostedFrom")
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: CustomTextWidget(
                        text: widget.feed["repostDescription"],
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
                        maxLines: homeViewModel.isExpanded(widget.feed['_id']) ? null : 2,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.chatSent, width: 2),
                          borderRadius: BorderRadius.circular(6),
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
                                          imageUrl: widget.feed["repostedFrom"]["user"]
                                              ['profileImage'],
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
                                            title: widget.feed["repostedFrom"]["user"]['name'],
                                            style: const TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w700),
                                          ),
                                          BaseText(
                                            title: widget.feed["repostedFrom"]["user"]
                                                    ['userHandler'] ??
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
                            _buildPostMedia(
                                context, widget.feed["repostedFrom"], dimension, homeViewModel),
                            const SizedBox(
                              height: 16,
                            ),
                            widget.feed["repostedFrom"]["hindiCaption"] != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          text: widget.feed["repostedFrom"]["hindiCaption"],
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                          maxLines: homeViewModel.isExpanded(widget.feed['_id'])
                                              ? null
                                              : 2,
                                        ),
                                        if (widget.feed["repostedFrom"]["hindiCaption"].length >
                                            140)
                                          InkWell(
                                            onTap: () =>
                                                homeViewModel.toggleExpand(widget.feed['_id']),
                                            child: homeViewModel.isExpanded(widget.feed['_id'])
                                                ? Container()
                                                : const BaseText(
                                                    title: "Read More",
                                                    style:
                                                        TextStyle(color: AppColor.hyperlinkColor),
                                                  ),
                                          ),
                                        // Text(
                                        //   home .getTimeAgo(
                                        //       widget.feed["repostedFrom"]['createdAt'], context),
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.bold,
                                        //       color: Colors.black.withOpacity(0.6)),
                                        // ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ))
                  ],
                )
              : _buildPostMedia(context, widget.feed, dimension, homeViewModel),

          // SizedBox(
          //   height: dimension["width"]! - 16,
          //   width: dimension["width"]! - 16,
          //   child: CachedNetworkImage(
          //     imageUrl: feed['imgurl'],
          //     progressIndicatorBuilder: (context, url, downloadProgress) =>
          //         Skeleton(
          //       height: dimension["width"]! - 16,
          //       width: dimension["width"]! - 16,
          //       radius: 0,
          //     ),
          //     errorWidget: (context, url, error) => const Icon(Icons.error),
          //     fit: BoxFit.fill,
          //   ),
          // ),
          Consumer<HomeTabViewModel>(builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.feed['approved']
                        ? InkWell(
                            onTap: handleLike,
                            child: Icon(
                              isLiked.value
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              color: AppColor.iconHeartColor,
                            ),
                          )
                        : const Icon(
                            Icons.favorite_outline_rounded,
                            color: AppColor.iconHeartColor,
                          ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(numberOfLikes.value.toString()),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.feed['approved']
                        ? InkWell(
                            onTap: () {
                              Utils.model(
                                  context,
                                  TimelineUserComment(
                                    feedId: widget.feed["_id"],
                                    setNumberOfComment: setNumberOfComment,
                                  ));
                            },
                            child: const Icon(Remix.chat_4_line),
                          )
                        : const Icon(
                            Remix.chat_4_line,
                            color: AppColor.iconColor,
                          ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(numberOfComments.value.toString())
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(AppLocalization.of(context)
                                      .getTranslatedValue("sharePostOutside")
                                      .toString()),
                                  onTap: () async {
                                    String text = "";
                                    if (widget.feed.containsKey("imgurl") &&
                                        widget.feed['imgurl'].isNotEmpty) {
                                      final xfile = await JankariViewModel()
                                          .shareFiles(widget.feed['imgurl']);
                                      if (widget.feed.containsKey("repostedFrom")) {
                                        text =
                                            "Check out what ${user['name']} posted!\n${widget.feed["repostedFrom"]["hindiCaption"]} \n Download Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                      } else {
                                        if (widget.feed["hindiCaption"] == null) {
                                          text =
                                              "Check out what ${user['name']} posted!\n Download Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                        } else {
                                          text =
                                              "Check out what ${user['name']} posted!\n ${widget.feed["hindiCaption"]}\n Download Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                        }
                                      }
                                      await Share.shareXFiles([xfile], text: text);
                                    } else if (widget.feed['mediaType'] == "video") {
                                      List<String> temp = widget.feed['videoUrl'].split('/');
                                      if (widget.feed.containsKey("repostedFrom")) {
                                        text =
                                            "Check out what ${user['name']} posted!\n${widget.feed["repostedFrom"]["hindiCaption"]}\nLink: https://d36yh71dpxszen.cloudfront.net/${temp[temp.length - 1]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                      } else {
                                        if (widget.feed["hindiCaption"] == null) {
                                          text =
                                              "Check out what ${user['name']} posted!\nLink: https://d36yh71dpxszen.cloudfront.net/${temp[temp.length - 1]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                        } else {
                                          text =
                                              "Check out what ${user['name']} posted!\n ${widget.feed["hindiCaption"]}\nLink: https://d36yh71dpxszen.cloudfront.net/${temp[temp.length - 1]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                        }
                                      }
                                      Share.share(text);
                                    } else {
                                      if (widget.feed.containsKey("repostedFrom")) {
                                        text =
                                            "Check out what ${user['name']} posted!\n${widget.feed["repostedFrom"]["hindiCaption"]}\nLink: ${widget.feed["videoUrl"]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                      } else {
                                        if (widget.feed["hindiCaption"] == null) {
                                          text =
                                              "Check out what ${user['name']} posted!\nLink: ${widget.feed["videoUrl"]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                        } else {
                                          text =
                                              "Check out what ${user['name']} posted!\n ${widget.feed["hindiCaption"]}\nLink: ${widget.feed["videoUrl"]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa";
                                        }
                                      }
                                      Share.share(text);
                                    }
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }),
                            );
                          });
                    },
                    child: const RotatedBox(quarterTurns: 2, child: Icon(Icons.reply_all)))
              ]),
            );
          }),
          widget.feed["hindiCaption"] != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: widget.feed["hindiCaption"],
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
                        maxLines: useViewModel.isExpandedMyPost(widget.feed['_id']) ? null : 2,
                      ),
                      if (widget.feed["hindiCaption"].length > 140)
                        InkWell(
                          onTap: () => useViewModel.toggleExpandMyPosts(widget.feed['_id']),
                          child: useViewModel.isExpandedMyPost(widget.feed['_id'])
                              ? Container()
                              : const BaseText(
                                  title: "Read More",
                                  style: TextStyle(color: AppColor.hyperlinkColor),
                                ),
                        ),
                    ],
                  ),
                )
              : Container(),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildPostMedia(
      BuildContext context, dynamic feed, dynamic dimension, HomeTabViewModel useViewModel) {
    if (feed['mediaType'] == "image") {
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
          height: dimension["width"]! - 16,
          width: dimension["width"]!,
          child: CachedNetworkImage(
            imageUrl: feed['imgurl'],
            progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
              height: dimension["width"]! - 16,
              width: dimension["width"]! - 16,
              radius: 0,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fill,
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
          if (visibilityInfo.visibleFraction > 0.5) {
            if (_currentVideoController != videoController) {
              _currentVideoController?.pause();
              _currentVideoController = videoController;
              videoController.initialize().then((_) {
                videoController.play();
                homeTabViewModel.increaseViews(context, feedId);
              });
            }
          } else if (_currentVideoController == videoController) {
            videoController.pause();
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
        autoPlay: false,
      ),
    );

    return VisibilityDetector(
      key: Key(videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
          youtubeController.play();
          homeTabViewModel.increaseViews(context, feedId);
        } else {
          youtubeController.pause();
        }
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
          IconButton(
            icon: const Icon(
              Icons.fullscreen,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              // setState(() {
              //   _controller.pause();
              // });
              // Utils.model(context, FullScreenYoutube());
              setState(() {
                youtubeController.pause(); // Pause the video before entering fullscreen
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenYoutube(
                    url: videoUrl,
                  ),
                ),
              );
            },
          ),
          // FullScreenButton()
        ],
      ),
    );
  }
}
