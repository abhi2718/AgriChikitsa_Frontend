import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/helper/video_controls.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/userProfile.screen/feed_user_profile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed_loader.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed_video_player.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/report_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/short_player.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/fullScreenImage.widget/full_screen_image.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/full_screen_video.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/full_screen_youtube_feed.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/helper/active_video_manager.dart';
import 'package:agriChikitsa/widgets/fullScreenPlayer.widget/helper/video_position_manager.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
void showConnectionsBottomSheet(BuildContext context, String title, List<dynamic> users) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.darkBlackColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Remix.close_line, color: AppColor.darkBlackColor),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: users.isEmpty
                    ? Center(
                        child: Text(
                          "No users found",
                          style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: users.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, indent: 16, endIndent: 16),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          if (user is Map) {
                            final name = user['name'] ?? user['userHandler'] ?? "User";
                            final handler = user['userHandler'] ?? "";
                            final profileImage = user['profileImage'];
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColor.lightColor,
                                backgroundImage:
                                    (profileImage != null && profileImage.toString().isNotEmpty)
                                        ? NetworkImage(profileImage)
                                        : null,
                                child: (profileImage == null || profileImage.toString().isEmpty)
                                    ? const Icon(Icons.person, color: AppColor.extraDark)
                                    : null,
                              ),
                              title: Text(
                                name,
                                style: GoogleFonts.inter(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              subtitle: handler.isNotEmpty
                                  ? Text(
                                      handler,
                                      style: GoogleFonts.inter(
                                          fontSize: 13, color: Colors.grey[600]),
                                    )
                                  : null,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FeedUserProfile(account: user),
                                  ),
                                );
                              },
                            );
                          } else {
                            return ListTile(
                              title: Text(user.toString()),
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class FeedUserProfile extends HookWidget {
  const FeedUserProfile({super.key, required this.account});
  final dynamic account;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<FeedUserProfileViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.tabController = useTabController(initialLength: 2);
      useViewModel.fetchUserFeeds(context, account['_id']);
    }, []);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
          account['userHandler'] ?? "N/A",
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      imageUrl: account['profileImage'],
                      progressIndicatorBuilder: (context, url, downloadProgress) => Skeleton(
                        height: 80,
                        width: 80,
                        radius: 0,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 80,
                      fit: BoxFit.cover,
                      height: 80,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                            return Text(
                              useViewModel.feedList.length.toString(),
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                            );
                          }),
                          Text(
                            AppLocalization.of(context).getTranslatedValue("postsTile").toString(),
                            style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                        final followersList = provider.connections != null &&
                                provider.connections['followers'] != null
                            ? provider.connections['followers']
                            : [];
                        return InkWell(
                          onTap: () {
                            showConnectionsBottomSheet(
                              context,
                              AppLocalization.of(context)
                                  .getTranslatedValue("followersTitle")
                                  .toString(),
                              followersList,
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                followersList.length.toString(),
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("followersTitle")
                                    .toString(),
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 16,
                      ),
                      Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                        final followingList = provider.connections != null &&
                                provider.connections['following'] != null
                            ? provider.connections['following']
                            : [];
                        return InkWell(
                          onTap: () {
                            showConnectionsBottomSheet(
                              context,
                              AppLocalization.of(context)
                                  .getTranslatedValue("followingTitle")
                                  .toString(),
                              followingList,
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                followingList.length.toString(),
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("followingTitle")
                                    .toString(),
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(account['name']),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                return GestureDetector(
                  onTap: () => provider.followUser(context, account['_id']),
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: dimension['height']! * 0.05,
                    decoration: BoxDecoration(
                      color: provider.isFollowing ? Colors.white : null,
                      border: provider.isFollowing
                          ? Border.all(color: AppColor.extraDark, width: 1.5)
                          : null,
                      gradient: provider.isFollowing
                          ? null
                          : const LinearGradient(
                              begin: Alignment.topCenter,
                              end: AlignmentDirectional.bottomCenter,
                              colors: [
                                Color(0xff114D1E),
                                Color(0xff185616),
                                Color(0xff218817),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: provider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color:
                                  provider.isFollowing ? AppColor.extraDark : AppColor.whiteColor,
                            ),
                          )
                        : Text(
                            provider.isFollowing
                                ? AppLocalization.of(context)
                                    .getTranslatedValue("followingTitle")
                                    .toString()
                                : AppLocalization.of(context)
                                    .getTranslatedValue("followTitle")
                                    .toString(),
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color:
                                  provider.isFollowing ? AppColor.extraDark : AppColor.whiteColor,
                            ),
                          ),
                  ),
                );
              }),
            ),
            const Divider(),
            TabBar(
              controller: useViewModel.tabController,
              indicatorColor: AppColor.darkColor,
              tabs: [
                Tab(
                  text: AppLocalization.of(context).getTranslatedValue("postsTile").toString(),
                ),
                Tab(
                  text: AppLocalization.of(context).getTranslatedValue("videosTitle").toString(),
                ),
              ],
              labelColor: AppColor.darkBlackColor,
            ),
            Expanded(
                child: TabBarView(
              controller: useViewModel.tabController,
              children: [
                Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                  return provider.isLoading
                      // return true
                      ? SizedBox(
                          height: dimension['height']! - 100,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return const FeedLoader();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : provider.feedList.isEmpty ||
                              provider.feedList.every((feed) => feed['mediaType'] != "image")
                          ? SizedBox(
                              height: dimension['height']! - 100,
                              child: Center(
                                child: Text(AppLocalization.of(context)
                                    .getTranslatedValue("noPostYet")
                                    .toString()),
                              ),
                            )
                          : SizedBox(
                              height: dimension['height']! - 100,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...provider.feedList.map((feed) {
                                      return feed['mediaType'] == 'image'
                                          ? UserProfileFeed(
                                              feed: feed,
                                              account: account,
                                            )
                                          : const SizedBox.shrink();
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                }),
                Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                  return provider.isLoading
                      // return true
                      ? SizedBox(
                          height: dimension['height']! - 100,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return const FeedLoader();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : provider.feedList.isEmpty ||
                              provider.feedList.every((feed) =>
                                  feed['mediaType'] != "video" && feed['mediaType'] != "youtube")
                          ? SizedBox(
                              height: dimension['height']! - 100,
                              child: Center(
                                child: Text(AppLocalization.of(context)
                                    .getTranslatedValue("noPostYet")
                                    .toString()),
                              ),
                            )
                          : SizedBox(
                              height: dimension['height']! - 100,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...provider.feedList.map((feed) {
                                      return feed['mediaType'] == 'video' ||
                                              feed['mediaType'] == "youtube"
                                          ? UserProfileFeed(
                                              feed: feed,
                                              account: account,
                                            )
                                          : const SizedBox.shrink();
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                }),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class UserProfileFeed extends StatefulHookWidget {
  const UserProfileFeed({super.key, required this.account, required this.feed});
  final dynamic account;
  final dynamic feed;

  @override
  State<UserProfileFeed> createState() => _UserProfileFeedState();
}

class _UserProfileFeedState extends State<UserProfileFeed> with WidgetsBindingObserver {
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
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<FeedUserProfileViewModel>(context, listen: false);
    final homeTabViewModel = Provider.of<HomeTabViewModel>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      // margin: EdgeInsets.only(
      //     top: 10,
      //     bottom:
      //         feed == useViewModel.feedList.elementAt(useViewModel.feedList.length - 1) ? 30 : 0),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.account['profileImage'],
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
                          title: widget.account['name'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        BaseText(
                          title: widget.account['userHandler'] ?? "@username",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                // GestureDetector(child: Icon(Icons.more_vert)),
                Builder(
                  builder: (context) => PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'report',
                        child: Text(
                          AppLocalization.of(context).getTranslatedValue('reportPost').toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Text('Share'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'report') {
                        showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          enableDrag: true,
                          builder: (BuildContext context) => ReportPostScreen(
                            userId: widget.account['_id'],
                          ),
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                        );
                      } else if (value == 'share') {
                        SharePlus.instance.share(ShareParams(
                            text:
                                "Check out what ${widget.account['name']} posted!\n ${widget.feed["hindiCaption"]}"));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildPostMedia(context, widget.feed, dimension, homeTabViewModel),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // InkWell(
                  //   onTap: handleLike,
                  //   child: Icon(
                  //     isLiked.value ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  //     color: AppColor.iconHeartColor,
                  //   ),
                  // ),
                  const Icon(
                    Icons.favorite_outline_rounded,
                    color: AppColor.iconHeartColor,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(widget.feed['likes'].length.toString())
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // Utils.model(
                      //     context,
                      //     UserComment(
                      //       feedId: feed["_id"],
                      //       setNumberOfComment: setNumberOfComment,
                      //     ));
                    },
                    child: const Icon(Remix.chat_4_line),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(widget.feed['comments'].length.toString())
                ],
              ),
              // InkWell(
              //   onTap: handleBookMark,
              //   child: Icon(
              //     isBookMarked.value ? Remix.bookmark_fill : Remix.bookmark_line,
              //     color: AppColor.darkColor,
              //   ),
              // )
              const Icon(
                Remix.bookmark_line,
                color: AppColor.darkColor,
              )
            ]),
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
                      Text(
                        useViewModel.getTimeAgo(widget.feed['createdAt'], context),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6)),
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
