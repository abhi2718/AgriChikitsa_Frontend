import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import '../../../../model/user_model.dart';
import '../../../../services/auth.dart';
import '../../../../widgets/skeleton/skeleton.dart';
import '../../hometab.screen/hometab_view_model.dart';
import 'timeline_comment_widget.dart';

class BookmarkFeed extends HookWidget {
  final feed;

  const BookmarkFeed({
    super.key,
    required this.feed,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final useViewModel =
        Provider.of<MyProfileViewModel>(context, listen: false);
    final homeViewModel =
        useMemoized(() => Provider.of<HomeTabViewModel>(context, listen: true));
    final userInfo = User.fromJson(authService.userInfo["user"]);
    final numberOfLikes = useState(feed['likes'].length);
    final isLiked = useState(feed['likes'].contains(userInfo.sId));
    final isBookMarked = useState(feed['bookmarks'].contains(userInfo.sId));
    final numberOfComments = useState(feed['comments'].length);
    void setNumberOfComment(int count) {
      numberOfComments.value = count;
    }

    void handleLike() {
      useViewModel.toggleLike(
          context, feed["_id"], isLiked.value, userInfo.sId!, homeViewModel);
      if (isLiked.value) {
        isLiked.value = false;
        numberOfLikes.value = numberOfLikes.value - 1;
      } else {
        isLiked.value = true;
        numberOfLikes.value = numberOfLikes.value + 1;
      }
    }

    void handleBookMark() {
      useViewModel.toggleTimeline(
          context, feed['_id'], userInfo.sId!, homeViewModel);
      isBookMarked.value = !isBookMarked.value;
    }

    final user = feed['user'];
    final imageName = feed['imgurl'];
    final profileImage = user['profileImage'];
    final dimension = Utils.getDimensions(context, true);
    useEffect(() {
      if (homeViewModel.toogleLikeBookMarkedFeed["id"] == feed['_id'] &&
          !useViewModel.isUserSwitchTheTab) {
        isLiked.value = homeViewModel.toogleLikeBookMarkedFeed["isLiked"];
        if (homeViewModel.toogleLikeBookMarkedFeed["isLiked"] == true) {
          numberOfLikes.value = numberOfLikes.value + 1;
        } else {
          numberOfLikes.value = numberOfLikes.value - 1;
        }
        Future.delayed(Duration.zero, () {
          homeViewModel.setToogleLikeBookMarkedFeed(false, "");
        });
      }
    }, [homeViewModel.toogleLikeBookMarkedFeed]);
    useEffect(() {
      if (useViewModel.isUserSwitchTheTab) {
        Future.delayed(const Duration(seconds: 2), () {
          useViewModel.setActiveTabIndex(false);
        });
      }
    }, []);
    useEffect(() {
      if (homeViewModel.increaseCommentNumber["id"] == feed['_id']) {
        final count = homeViewModel.increaseCommentNumber["count"];
        numberOfComments.value = count;
        Future.delayed(Duration.zero, () {
          homeViewModel.setIncreaseCommentNumber(0, "");
        });
      }
    }, [homeViewModel.increaseCommentNumber]);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
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
                                  imageUrl: profileImage,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Skeleton(
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
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            BaseText(
                              title: user['userHandler'] ?? "@username",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const InkWell(
                      child: Icon(Remix.more_2_line),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: dimension["width"]! - 16,
                width: dimension["width"]! - 16,
                child: CachedNetworkImage(
                  imageUrl: imageName,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Skeleton(
                    height: dimension["width"]! - 16,
                    width: dimension["width"]! - 16,
                    radius: 0,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Utils.model(
                                  context,
                                  TimelineUserComment(
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
                      InkWell(
                        onTap: handleBookMark,
                        child: Icon(
                          isBookMarked.value
                              ? Remix.bookmark_fill
                              : Remix.bookmark_line,
                          color: AppColor.darkColor,
                        ),
                      )
                    ]),
              ),
              feed["hindiCaption"] != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feed["hindiCaption"],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines:
                                useViewModel.isExpandedBookMarkFeed(feed['_id'])
                                    ? null
                                    : 2,
                          ),
                          if (feed["hindiCaption"].length > 140)
                            InkWell(
                              onTap: () => useViewModel
                                  .toggleExpandBookMarkFeed(feed['_id']),
                              child: useViewModel
                                      .isExpandedBookMarkFeed(feed['_id'])
                                  ? Container()
                                  : const BaseText(
                                      title: "Read More",
                                      style: TextStyle(
                                          color: AppColor.hyperlinkColor),
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
        ),
      ),
    );
  }
}
