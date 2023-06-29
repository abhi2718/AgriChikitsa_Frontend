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
          context, feed["_id"], isLiked.value, userInfo.sId!);
      if (isLiked.value) {
        isLiked.value = false;
        numberOfLikes.value = numberOfLikes.value - 1;
      } else {
        isLiked.value = true;
        numberOfLikes.value = numberOfLikes.value + 1;
      }
    }

    void handleBookMark() {
      useViewModel.toggleTimeline(context, feed['_id'], userInfo.sId!);
      isBookMarked.value = !isBookMarked.value;
    }

    final user = feed['user'];
    final imageName = feed['imgurl'].split(
        'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    // final profileImage = user['profileImage'].split(
    //     'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
    final dimension = Utils.getDimensions(context, true);
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
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user['profileImage']),
                              // backgroundImage: CachedNetworkImageProvider(
                              //     'https://d336izsd4bfvcs.cloudfront.net/$profileImage'),
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
              CachedNetworkImage(
                imageUrl: 'https://d336izsd4bfvcs.cloudfront.net/$imageName',
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Skeleton(
                  height: 240,
                  width: dimension["width"]! - 16,
                  radius: 0,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: dimension["width"]! - 16,
                fit: BoxFit.fill,
                height: 240,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BaseText(
                  title: feed["caption"] ?? "",
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ),
              ),
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
