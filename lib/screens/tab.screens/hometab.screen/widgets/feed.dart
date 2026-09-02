import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/helper/video_controls.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/userProfile.screen/feed_user_profile.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/userProfile.screen/feed_user_profile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/report_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/reshare_post.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/fullScreenImage.widget/full_screen_image.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/full_screen_video.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/full_screen_youtube_feed.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/helper/active_video_manager.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/helper/video_position_manager.dart';
import 'package:agriChikitsa/widgets/like.icon/heart_icon.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../model/user_model.dart';
import '../../../../services/auth.dart';
import '../../myprofile.screen/myprofile_view_model.dart';
import 'comment_widget.dart';

class Feed extends StatefulHookWidget {
  final feed;

  const Feed({
    super.key,
    required this.feed,
  });

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> with WidgetsBindingObserver {
  // Normal video
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;

  // YouTube
  YoutubePlayerController? _youtubeController;

  // Shared UI state
  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  final ValueNotifier<bool> _showControls = ValueNotifier(false);

  String get _feedId => widget.feed['_id'] as String;
  String get _videoUrl => widget.feed['videoUrl'] as String;
  String get _mediaType => widget.feed['mediaType'] as String;

  Size _videoSize = const Size(16, 9);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ActiveVideoManager.instance.addListener(_onActiveVideoChanged);

    if (_mediaType == 'video') {
      _initVideoController();
    }
    // YouTube controller initialized in build via YoutubePlayerBuilder
  }

  // REPLACE _initVideoController with:
  void _initVideoController() {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(Utils.getCloudFrontUrl(_videoUrl)),
    );
    _videoController!.initialize().then((_) {
      if (!mounted) return;
      final saved = VideoPositionManager.instance.get(_videoUrl);
      if (saved > Duration.zero) _videoController!.seekTo(saved);
      _videoController!.setVolume(0); // start muted, unmute on visibility
      final size = _videoController!.value.size;
      if (size.width > 0 && size.height > 0) {
        _videoSize = size;
      }
      if (mounted) setState(() => _videoInitialized = true);
    });
  }

  YoutubePlayerController _buildYoutubeController() {
    final videoId = YoutubePlayer.convertUrlToId(_videoUrl)!;
    final saved = VideoPositionManager.instance.get(_videoUrl);
    return YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        startAt: saved.inSeconds,
        hideControls: false,
        enableCaption: false,
        forceHD: false,
      ),
    );
  }

  void _onActiveVideoChanged() {
    if (!mounted) return;
    if (ActiveVideoManager.instance.activeKey != _feedId) {
      _videoController?.pause();
      _youtubeController?.pause();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _videoController?.pause();
      _youtubeController?.pause();
      ActiveVideoManager.instance.clearAll();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info, HomeTabViewModel vm) {
    if (!mounted) return;
    if (info.visibleFraction >= 0.9) {
      ActiveVideoManager.instance.setActive(_feedId);
      if (_mediaType == 'video') {
        _videoController?.setVolume(_isMuted.value ? 0 : 1);
        _videoController?.play();
      } else if (_mediaType == 'youtube') {
        if (_isMuted.value) {
          _youtubeController?.mute();
        } else {
          _youtubeController?.unMute();
        }
        _youtubeController?.play();
      }
      vm.increaseViews(context, _feedId);
    } else {
      if (_mediaType == 'video') {
        _videoController?.pause();
      } else if (_mediaType == 'youtube') {
        _youtubeController?.pause();
      }
      ActiveVideoManager.instance.clearIfActive(_feedId);
    }
  }

  void _onTap() {
    _showControls.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _showControls.value = false;
    });
  }

  Future<void> _openVideoFullScreen() async {
    final position = _videoController!.value.position;
    _videoController!.pause();
    VideoPositionManager.instance.save(_videoUrl, position);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideo(
          videoUrl: _videoUrl,
          videoSize: _videoSize,
          startAt: position,
          isMuted: _isMuted.value,
        ),
      ),
    );

    if (!mounted) return;
    final resumed = VideoPositionManager.instance.get(_videoUrl);
    await _videoController!.seekTo(resumed);
    _videoController!.play();
  }

  Future<void> _openYoutubeFullScreen() async {
    if (_youtubeController == null) return;
    final position = _youtubeController!.value.position;
    _youtubeController!.pause();
    VideoPositionManager.instance.save(_videoUrl, position);

    final videoId = YoutubePlayer.convertUrlToId(_videoUrl)!;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenYoutubeFeed(
          videoId: videoId,
          url: _videoUrl,
          startAt: position,
        ),
      ),
    );

    if (!mounted) return;
    final resumed = VideoPositionManager.instance.get(_videoUrl);
    _youtubeController!.seekTo(resumed);
    _youtubeController!.play();
  }

  Widget _muteOverlay({required VoidCallback onToggle}) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControls,
      builder: (_, show, __) {
        if (!show) return const SizedBox.shrink();
        return Positioned(
          top: 8,
          right: 8,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isMuted,
            builder: (_, muted, __) => GestureDetector(
              onTap: onToggle,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  muted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ActiveVideoManager.instance.removeListener(_onActiveVideoChanged);
    _isMuted.dispose();
    _showControls.dispose();
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final useViewModel = Provider.of<HomeTabViewModel>(context, listen: false);
    final myProfileViewModel =
        useMemoized(() => Provider.of<MyProfileViewModel>(context, listen: false));
    final feedProfileModel =
        useMemoized(() => Provider.of<FeedUserProfileViewModel>(context, listen: false));
    final userInfo = User.fromJson(authService.userInfo["user"]);
    final numberOfLikes = useState(widget.feed['likes'].length);
    final isLiked = useState(widget.feed['likes'].contains(userInfo.sId));
    var isBookMarked = useState(widget.feed['bookmarks'].contains(userInfo.sId));
    final numberOfComments = useState(widget.feed['comments'].length);
    // useEffect(() {
    //   if (myProfileViewModel.unBookMarkedFeedData["id"] == feed["_id"]) {
    //     isBookMarked.value = false;
    //     Future.delayed(Duration.zero, () {
    //       myProfileViewModel.setRemoveFeedFromHome(false, "");
    //     });
    //   }
    // }, [myProfileViewModel.unBookMarkedFeedData]);
    void setNumberOfComment(int count) {
      numberOfComments.value = count;
    }

    void handleLike() {
      useViewModel.toggleLike(
          context, widget.feed["_id"], myProfileViewModel, isLiked.value, userInfo.sId!);
      if (isLiked.value == true) {
        isLiked.value = false;
        numberOfLikes.value = numberOfLikes.value - 1;
      } else {
        isLiked.value = true;
        numberOfLikes.value = numberOfLikes.value + 1;
      }
    }

    void handleBookMark() {
      useViewModel.toggleTimeline(
          context, widget.feed['_id'], userInfo.sId!, isBookMarked.value, myProfileViewModel);
      isBookMarked.value = !isBookMarked.value;
    }

    final user = widget.feed['user'];
    final dimension = Utils.getDimensions(context, true);
    return Container(
      margin: EdgeInsets.only(
          top: 2,
          bottom: widget.feed == useViewModel.feedList.elementAt(useViewModel.feedList.length - 1)
              ? 30
              : 0),
      child: Container(
        color: AppColor.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Utils.model(
                        context,
                        FeedUserProfile(
                          account: user,
                        )),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: user['profileImage'],
                            progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
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
                  ),
                  // GestureDetector(child: Icon(Icons.more_vert)),
                  Row(
                    children: [
                      userInfo.sId == user["_id"]
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                feedProfileModel.followUser(context, widget.feed['user']['_id']);
                                setState(() {
                                  user["isFollowing"] = !user["isFollowing"];
                                });
                              },
                              child: user.containsKey("isFollowing")
                                  ? user["isFollowing"]
                                      ? Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("followingTitle")
                                              .toString(),
                                          style: const TextStyle(
                                              color: AppColor.darkColor,
                                              fontWeight: FontWeight.bold))
                                      : Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("followTitle")
                                              .toString(),
                                          style: const TextStyle(
                                              color: AppColor.darkColor,
                                              fontWeight: FontWeight.bold))
                                  : Text(
                                      AppLocalization.of(context)
                                          .getTranslatedValue("followTitle")
                                          .toString(),
                                      style: const TextStyle(
                                          color: AppColor.darkColor, fontWeight: FontWeight.bold),
                                    ),
                            ),
                      Builder(
                        builder: (context) => PopupMenuButton(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          itemBuilder: (context) => [
                            userInfo.sId == user["_id"]
                                ? const PopupMenuItem(height: 0, child: SizedBox.shrink())
                                : PopupMenuItem(
                                    value: 'report',
                                    child: Text(
                                      AppLocalization.of(context)
                                          .getTranslatedValue('reportPost')
                                          .toString(),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                            userInfo.sId != user["_id"]
                                ? const PopupMenuItem(height: 0, child: SizedBox.shrink())
                                : PopupMenuItem(
                                    value: 'edit',
                                    child: Text(
                                      AppLocalization.of(context)
                                          .getTranslatedValue('editTitle')
                                          .toString(),
                                      style: const TextStyle(color: AppColor.darkBlackColor),
                                    ),
                                  ),
                            userInfo.sId != user["_id"]
                                ? const PopupMenuItem(height: 0, child: SizedBox.shrink())
                                : PopupMenuItem(
                                    value: 'delete',
                                    child: Text(
                                      AppLocalization.of(context)
                                          .getTranslatedValue('deleteTitle')
                                          .toString(),
                                      style: const TextStyle(color: AppColor.errorColor),
                                    ),
                                  ),
                          ],
                          onSelected: (value) {
                            if (value == 'report') {
                              showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                enableDrag: true,
                                builder: (BuildContext context) => ReportPostScreen(
                                  userId: user['_id'],
                                ),
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                              );
                            }
                            if (value == 'edit') {
                              Utils.model(
                                  context,
                                  CreatePostScreen(
                                    onPostCreated: () {},
                                    feed: widget.feed,
                                    isEdit: widget.feed.containsKey("repostedFrom") ? true : false,
                                  ));
                            }
                            if (value == 'delete') {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return myProfileViewModel.deleteLoader
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
                                                      fontSize: 16, color: AppColor.errorColor)),
                                              onPressed: () {
                                                myProfileViewModel.postDelete(
                                                    context, widget.feed['_id'], useViewModel);
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
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                          maxLines: useViewModel.isExpanded(widget.feed['_id']) ? null : 2,
                        ),
                      ),
                      Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(color: AppColor.chatSent, width: 2),
                                bottom: BorderSide(color: AppColor.chatSent, width: 2)),
                            color: AppColor.whiteColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: () => Utils.model(
                                      context,
                                      FeedUserProfile(
                                        account: widget.feed["repostedFrom"]["user"],
                                      )),
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
                              ),
                              _buildPostMedia(
                                  context, widget.feed["repostedFrom"], dimension, useViewModel),
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
                                            maxLines: useViewModel.isExpanded(widget.feed['_id'])
                                                ? null
                                                : 2,
                                          ),
                                          if (widget.feed["repostedFrom"]["hindiCaption"].length >
                                              140)
                                            InkWell(
                                              onTap: () =>
                                                  useViewModel.toggleExpand(widget.feed['_id']),
                                              child: useViewModel.isExpanded(widget.feed['_id'])
                                                  ? Container()
                                                  : const BaseText(
                                                      title: "Read More",
                                                      style:
                                                          TextStyle(color: AppColor.hyperlinkColor),
                                                    ),
                                            ),
                                          Text(
                                            useViewModel.getTimeAgo(
                                                widget.feed["repostedFrom"]['createdAt'], context),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          )),
                    ],
                  )
                : _buildPostMedia(context, widget.feed, dimension, useViewModel),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HeartButton(
                          isLiked: isLiked.value,
                          onLike: () {
                            handleLike();
                          },
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(numberOfLikes.value.toString())
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Utils.model(
                                context,
                                UserComment(
                                  feedId: widget.feed["_id"],
                                  setNumberOfComment: setNumberOfComment,
                                ));
                          },
                          child: const Icon(Remix.chat_4_line),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(numberOfComments.value.toString())
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    userInfo.sId == user["_id"]
                        ? const SizedBox.shrink()
                        : InkWell(
                            onTap: handleBookMark,
                            child: Icon(
                              isBookMarked.value ? Remix.bookmark_fill : Remix.bookmark_line,
                              color: AppColor.darkColor,
                            ),
                          )
                  ]),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      userInfo.sId ==
                                                  user[
                                                      "_id"] || // Condition 1: Can't reshare own posts
                                              (widget.feed['repostedFrom'] != null &&
                                                  widget.feed['repostedFrom']['user']['_id'] ==
                                                      userInfo.sId)
                                          // Condition 2: Can't reshare posts reshared by others if the original post belongs to me
                                          ? const SizedBox.shrink()
                                          : ListTile(
                                              title: Text(
                                                AppLocalization.of(context)
                                                    .getTranslatedValue("sharePostApp")
                                                    .toString(),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Utils.model(
                                                  context,
                                                  ResharePost(
                                                    feed:
                                                        widget.feed['repostedFrom'] ?? widget.feed,
                                                  ),
                                                );
                                              },
                                            ),
                                      userInfo.sId == user["_id"] ||
                                              (widget.feed['repostedFrom'] != null &&
                                                  widget.feed['repostedFrom']['user']['_id'] ==
                                                      userInfo.sId)
                                          ? const SizedBox.shrink()
                                          : const Divider(),
                                      ListTile(
                                          title: Text(AppLocalization.of(context)
                                              .getTranslatedValue("sharePostOutside")
                                              .toString()),
                                          onTap: () async {
                                            String text = "";
                                            if (widget.feed.containsKey("images") &&
                                                widget.feed['images'].isNotEmpty) {
                                              final xfile = await JankariViewModel().shareFiles(
                                                  widget.feed['images'][0]["originalUrl"]);
                                              if (widget.feed.containsKey("repostedFrom")) {
                                                text =
                                                    "Check out what ${user['name']} posted!\n${widget.feed["repostedFrom"]["hindiCaption"]} \n Download Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                              } else {
                                                if (widget.feed["hindiCaption"] == null) {
                                                  text =
                                                      "Check out what ${user['name']} posted!\n Download Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                                } else {
                                                  text =
                                                      "Check out what ${user['name']} posted!\n ${widget.feed["hindiCaption"]}\n Download Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                                }
                                              }
                                              await SharePlus.instance
                                                  .share(ShareParams(text: text, files: [xfile]));
                                            } else if (widget.feed['mediaType'] == "video") {
                                              final videoCfUrl = Utils.getCloudFrontUrl(widget.feed['videoUrl']);
                              
                                              if (widget.feed.containsKey("repostedFrom")) {
                                                text =
                                                    "Check out what ${user['name']} posted!\n${widget.feed["repostedFrom"]["hindiCaption"]}\nLink: $videoCfUrl\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                              } else {
                                                if (widget.feed["hindiCaption"] == null) {
                                                  text =
                                                      "Check out what ${user['name']} posted!\nLink: $videoCfUrl\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                                } else {
                                                  text =
                                                      "Check out what ${user['name']} posted!\n ${widget.feed["hindiCaption"]}\nLink: $videoCfUrl\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                                }
                                              }
                                              await SharePlus.instance
                                                  .share(ShareParams(text: text));
                                            } else {
                                              if (widget.feed.containsKey("repostedFrom")) {
                                                text =
                                                    "Check out what ${user['name']} posted!\n${widget.feed["repostedFrom"]["hindiCaption"]}\nLink: ${widget.feed["videoUrl"]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                              } else {
                                                if (widget.feed["hindiCaption"] == null) {
                                                  text =
                                                      "Check out what ${user['name']} posted!\nLink: ${widget.feed["videoUrl"]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                                } else {
                                                  text =
                                                      "Check out what ${user['name']} posted!\n ${widget.feed["hindiCaption"]}\nLink: ${widget.feed["videoUrl"]}\nDownload Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa.app";
                                                }
                                              }
                                              await SharePlus.instance
                                                  .share(ShareParams(text: text));
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const RotatedBox(quarterTurns: 2, child: Icon(Icons.reply_all))),
                ],
              ),
            ),
            widget.feed['views'] != 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("${widget.feed['views']} Views"),
                  )
                : const SizedBox.shrink(),
            widget.feed["hindiCaption"] != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: widget.feed["hindiCaption"],
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
                          maxLines: useViewModel.isExpanded(widget.feed['_id']) ? null : 2,
                        ),
                        if (widget.feed["hindiCaption"].length > 140)
                          InkWell(
                            onTap: () => useViewModel.toggleExpand(widget.feed['_id']),
                            child: useViewModel.isExpanded(widget.feed['_id'])
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                useViewModel.getTimeAgo(widget.feed['createdAt'], context),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6)),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
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
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImage(
                images: feed["images"],
                feed: feed,
                useViewModel: useViewModel,
              ),
            ),
          ),
          child: SizedBox(
            height: dimension["width"]! - 16 + 20,
            width: dimension["width"]!,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: feed["images"].isNotEmpty ? feed["images"].length : 1,
                    itemBuilder: (context, pagePosition) {
                      return CachedNetworkImage(
                        imageUrl: feed['images'][pagePosition]["thumbnailUrl"],
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
                if (feed["images"].isNotEmpty && feed["images"].length > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: feed["images"].length,
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
        ),
      );
    }
    if (feed['mediaType'] == "video") {
      return _buildVideoPlayer(useViewModel);
    }
    if (feed['mediaType'] == "youtube") {
      return _buildYoutubePlayer(useViewModel);
    } else {
      return const SizedBox.shrink();
    }
  }

  // REPLACE _buildVideoPlayer:
  Widget _buildVideoPlayer(HomeTabViewModel vm) {
    final aspectRatio = _videoSize.width / _videoSize.height;

    return VisibilityDetector(
      key: Key('video_$_feedId'),
      onVisibilityChanged: (info) => _onVisibilityChanged(info, vm),
      child: AspectRatio(
        aspectRatio: 16 / 9, // card height stays fixed at 16:9
        child: Container(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video centered with correct aspect ratio, no stretch
              Center(
                child: _videoInitialized && _videoController != null
                    ? AspectRatio(
                        aspectRatio: aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : const CircularProgressIndicator(color: AppColor.darkColor),
              ),
              // Tap to show/hide controls
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onTap,
              ),
              // Controls overlay
              ValueListenableBuilder<bool>(
                valueListenable: _showControls,
                builder: (_, show, __) {
                  if (!show || !_videoInitialized || _videoController == null) {
                    return const SizedBox.shrink();
                  }
                  return VideoControls(
                    controller: _videoController!,
                    isMuted: _isMuted,
                    onMuteToggle: () {
                      _isMuted.value = !_isMuted.value;
                      _videoController?.setVolume(_isMuted.value ? 0 : 1);
                    },
                    onFullScreen: _openVideoFullScreen,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYoutubePlayer(HomeTabViewModel vm) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {}, // no-op
      onExitFullScreen: () {}, // no-op
      player: YoutubePlayer(
        controller: _youtubeController ??= _buildYoutubeController(),
        showVideoProgressIndicator: true,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(playedColor: AppColor.darkColor),
          ),
          RemainingDuration(),
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white, size: 30),
            onPressed: _openYoutubeFullScreen,
          ),
        ],
        topActions: const [SizedBox.shrink()],
      ),
      builder: (context, player) {
        // Store controller reference after builder fires
        return VisibilityDetector(
          key: Key('youtube_$_feedId'),
          onVisibilityChanged: (info) => _onVisibilityChanged(info, vm),
          child: GestureDetector(
            onTap: _onTap,
            child: Stack(
              children: [
                player,
                _muteOverlay(
                  onToggle: () {
                    _isMuted.value = !_isMuted.value;
                    if (_isMuted.value) {
                      _youtubeController?.mute();
                    } else {
                      _youtubeController?.unMute();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
