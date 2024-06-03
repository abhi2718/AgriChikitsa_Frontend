import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/userProfile.screen/feed_user_profile.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/custom_test_widget.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed_video_player.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/report_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/short_player.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../model/user_model.dart';
import '../../../../services/auth.dart';
import '../../myprofile.screen/myprofile_view_model.dart';
import 'comment_widget.dart';

class Feed extends HookWidget {
  final feed;

  const Feed({
    super.key,
    required this.feed,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final useViewModel = Provider.of<HomeTabViewModel>(context, listen: false);
    final myProfileViewModel =
        useMemoized(() => Provider.of<MyProfileViewModel>(context, listen: false));
    final userInfo = User.fromJson(authService.userInfo["user"]);
    final numberOfLikes = useState(feed['likes'].length);
    final isLiked = useState(feed['likes'].contains(userInfo.sId));
    var isBookMarked = useState(feed['bookmarks'].contains(userInfo.sId));
    final numberOfComments = useState(feed['comments'].length);
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
          context, feed["_id"], myProfileViewModel, isLiked.value, userInfo.sId!);
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
          context, feed['_id'], userInfo.sId!, isBookMarked.value, myProfileViewModel);
      isBookMarked.value = !isBookMarked.value;
    }

    // useEffect(() {
    //   if (myProfileViewModel.toogleHomeFeed["id"] == feed['_id']) {
    //     isLiked.value = myProfileViewModel.toogleHomeFeed["isLiked"];
    //     if (myProfileViewModel.toogleHomeFeed["isLiked"] == true) {
    //       numberOfLikes.value = numberOfLikes.value + 1;
    //     } else {
    //       numberOfLikes.value = numberOfLikes.value - 1;
    //     }
    //     Future.delayed(Duration.zero, () {
    //       myProfileViewModel.setToogleHomeFeed(false, "");
    //     });
    //   }
    // }, [myProfileViewModel.toogleHomeFeed]);
    final user = feed['user'];
    final dimension = Utils.getDimensions(context, true);
    return Container(
      margin: EdgeInsets.only(
          top: 10,
          bottom:
              feed == useViewModel.feedList.elementAt(useViewModel.feedList.length - 1) ? 30 : 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
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
                    Builder(
                      builder: (context) => PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'report',
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranslatedValue('reportPost')
                                  .toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'report') {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              enableDrag: true,
                              builder: (BuildContext context) => ReportScreen(
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
                        },
                      ),
                    ),
                  ],
                ),
              ),
              feed['mediaType'] == 'image'
                  ? VisibilityDetector(
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
                        width: dimension["width"]! - 16,
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
                    )
                  : feed['mediaType'] == 'video'
                      ? PostWidget(
                          videoUrl: feed['videoUrl'],
                          postId: feed['_id'],
                        )
                      : Player(
                          videoUrl: feed['videoUrl'],
                          aspectRatio: 16 / 9,
                          feedId: feed['_id'],
                        ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: handleLike,
                            child: Icon(
                              isLiked.value
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              color: AppColor.iconHeartColor,
                            ),
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
                                    feedId: feed["_id"],
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
                      InkWell(
                        onTap: handleBookMark,
                        child: Icon(
                          isBookMarked.value ? Remix.bookmark_fill : Remix.bookmark_line,
                          color: AppColor.darkColor,
                        ),
                      )
                    ]),
                    GestureDetector(
                        onTap: () {
                          Share.share(
                              "Check out what ${user['name']} posted!\n ${feed["hindiCaption"]} \n Download Agrichikits App Now - https://play.google.com/store/apps/details?id=com.freshnic.agriChikitsa");
                        },
                        child: const Icon(Icons.reply_all)),
                  ],
                ),
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
        ),
      ),
    );
  }
}
