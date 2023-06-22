import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/timeline_comment_widget.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import '../../../../model/user_model.dart';
import '../../../../services/auth.dart';

class MyProfileFeed extends HookWidget {
  final feed;

  const MyProfileFeed({
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
    final numberOfComments = useState(feed['comments'].length);
    void setNumberOfComment(int count) {
      numberOfComments.value = count;
    }

    void handleLike() {
      useViewModel.toggleLike(
          context, feed["_id"], isLiked.value, userInfo.sId!);
      if (isLiked.value == true) {
        isLiked.value = false;
        numberOfLikes.value = numberOfLikes.value - 1;
      } else {
        isLiked.value = true;
        numberOfLikes.value = numberOfLikes.value + 1;
      }
    }

    final user = feed['user'];
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
                            const BaseText(
                              title: '@atin',
                              style: TextStyle(
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
              Image.network(
                feed['imgurl'],
                width: dimension["width"]! - 16,
                fit: BoxFit.fill,
                height: 240,
              ),
              Consumer<HomeTabViewModel>(builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            feed['approved']
                                ? InkWell(
                                    onTap: handleLike,
                                    child: Icon(isLiked.value
                                        ? Remix.heart_2_fill
                                        : Remix.heart_line),
                                  )
                                : const Icon(
                                    Remix.heart_2_line,
                                    color: AppColor.iconColor,
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
                            feed['approved']
                                ? InkWell(
                                    onTap: () {
                                      Utils.model(
                                          context,
                                          TimelineUserComment(
                                            feedId: feed["_id"],
                                            setNumberOfComment:
                                                setNumberOfComment,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            feed['approved']
                                ? const Icon(
                                    Icons.verified_rounded,
                                    color: AppColor.darkColor,
                                  )
                                : const Icon(
                                    Icons.hourglass_bottom,
                                    color: AppColor.errorColor,
                                  ),
                          ],
                        )
                      ]),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BaseText(
                  title: feed["caption"],
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.start,
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
