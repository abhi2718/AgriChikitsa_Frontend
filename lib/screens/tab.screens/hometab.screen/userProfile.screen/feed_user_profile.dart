import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/userProfile.screen/feed_user_profile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed_loader.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed_video_player.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/report_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/short_player.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';

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
                      Column(
                        children: [
                          Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                            return Text(
                              provider.connections == null
                                  ? "0"
                                  : provider.connections['followers'].length.toString(),
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                            );
                          }),
                          Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("followersTitle")
                                .toString(),
                            style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        children: [
                          Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                            return Text(
                              provider.connections == null
                                  ? "0"
                                  : provider.connections['following'].length.toString(),
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                            );
                          }),
                          Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("followingTitle")
                                .toString(),
                            style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ],
                      ),
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
              child: GestureDetector(
                onTap: useViewModel.isFollowing
                    ? null
                    : () => useViewModel.followUser(context, account['_id']),
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: dimension['height']! * 0.06,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: AlignmentDirectional.bottomCenter,
                          colors: [
                            Color(0xff114D1E),
                            Color(0xff185616),
                            Color(0xff218817),
                          ]),
                      borderRadius: BorderRadius.circular(10)),
                  child: Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                    return provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.whiteColor,
                            ),
                          )
                        : provider.isFollowing
                            ? Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("followingTitle")
                                    .toString(),
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.whiteColor),
                              )
                            : Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("followTitle")
                                    .toString(),
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.whiteColor),
                              );
                  }),
                ),
              ),
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

class UserProfileFeed extends StatelessWidget {
  const UserProfileFeed({super.key, required this.account, required this.feed});
  final dynamic account;
  final dynamic feed;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<FeedUserProfileViewModel>(context, listen: false);
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
                        imageUrl: account['profileImage'],
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
                          title: account['name'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        BaseText(
                          title: account['userHandler'] ?? "@username",
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
                            userId: account['_id'],
                          ),
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                        );
                      } else if (value == 'share') {
                        Share.share(
                            "Check out what ${account['name']} posted!\n ${feed["hindiCaption"]}");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          feed['mediaType'] == 'image'
              ? SizedBox(
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
                )
              : feed['mediaType'] == 'video'
                  ? PostWidget(videoUrl: feed['videoUrl'])
                  : Player(videoUrl: feed['videoUrl'], aspectRatio: 16 / 9),
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
                  Text(feed['likes'].length.toString())
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
                  Text(feed['comments'].length.toString())
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
          feed['views'] != 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("${feed['views']} Views"),
                )
              : const SizedBox.shrink(),
          feed["hindiCaption"] != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: feed["hindiCaption"],
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
                        maxLines: useViewModel.isExpanded(feed['_id']) ? null : 2,
                      ),
                      if (feed["hindiCaption"].length > 140)
                        InkWell(
                          onTap: () => useViewModel.toggleExpand(feed['_id']),
                          child: useViewModel.isExpanded(feed['_id'])
                              ? Container()
                              : const BaseText(
                                  title: "Read More",
                                  style: TextStyle(color: AppColor.hyperlinkColor),
                                ),
                        ),
                      Text(
                        useViewModel.getTimeAgo(feed['createdAt'], context),
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
}
