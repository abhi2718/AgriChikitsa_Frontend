import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import '../../../../services/auth.dart';
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
    final userInfo = authService.userInfo["user"];
    final numberOfLikes = useState(feed['likes'].length);
    final isLiked = useState(feed['likes'].contains(userInfo["_id"]));
    final numberOfComments = useState(feed['comments'].length);

    void setNumberOfComment(int count) {
      numberOfComments.value = count;
    }

    void handleLike() {
      useViewModel.toggleLike(context, feed["_id"]);
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
                            child: Icon(isLiked.value
                                ? Remix.heart_2_fill
                                : Remix.heart_line),
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
                          const InkWell(
                            child: Icon(Remix.chat_4_line),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(numberOfComments.value.toString())
                        ],
                      ),
                      const InkWell(child: Icon(Remix.bookmark_line))
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BaseText(
                  title: feed["caption"],
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 40,
                child: InkWell(
                  onTap: () {
                    Utils.model(
                        context,
                        UserComment(
                          feedId: feed["_id"],
                          setNumberOfComment: setNumberOfComment,
                        ));
                  },
                  child: Container(
                    height: 40,
                    width: dimension['width']! - 52,
                    decoration: const BoxDecoration(
                      color: Color(0xffd9d9d9),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: BaseText(
                            title: 'Add a  comment',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
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
