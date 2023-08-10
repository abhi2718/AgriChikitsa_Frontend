import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
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
    final myProfileViewModel = useMemoized(
        () => Provider.of<MyProfileViewModel>(context, listen: false));
    final userInfo = User.fromJson(authService.userInfo["user"]);
    final numberOfLikes = useState(feed['likes'].length);
    final isLiked = useState(feed['likes'].contains(userInfo.sId));
    var isBookMarked = useState(feed['bookmarks'].contains(userInfo.sId));
    final numberOfComments = useState(feed['comments'].length);
    final imageName = feed['imgurl'].split(
        'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
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
      useViewModel.toggleLike(context, feed["_id"], myProfileViewModel,
          isLiked.value, userInfo.sId!);
      if (isLiked.value == true) {
        isLiked.value = false;
        numberOfLikes.value = numberOfLikes.value - 1;
      } else {
        isLiked.value = true;
        numberOfLikes.value = numberOfLikes.value + 1;
      }
    }

    void handleBookMark() {
      useViewModel.toggleTimeline(context, feed['_id'], userInfo.sId!,
          isBookMarked.value, myProfileViewModel);
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
    final profileImage = user['profileImage'].split(
        'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    final dimension = Utils.getDimensions(context, true);
    return Container(
      margin: const EdgeInsets.only(top: 10),
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
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://d336izsd4bfvcs.cloudfront.net/$profileImage',
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
                    // const InkWell(
                    //   child: Icon(Remix.more_2_line),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: dimension["width"]! - 16,
                width: dimension["width"]! - 16,
                child: CachedNetworkImage(
                  imageUrl: 'https://d336izsd4bfvcs.cloudfront.net/$imageName',
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
                                useViewModel.isExpanded(feed['_id']) ? null : 2,
                          ),
                          if (feed["hindiCaption"].length > 140)
                            InkWell(
                              onTap: () =>
                                  useViewModel.toggleExpand(feed['_id']),
                              child: useViewModel.isExpanded(feed['_id'])
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
