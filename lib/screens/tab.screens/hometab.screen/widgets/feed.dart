import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import 'comment_widget.dart';

class Feed extends StatelessWidget {
  final feed;

  Feed({
    super.key,
    required this.feed,
  });

  @override
  Widget build(BuildContext context) {
    final user = feed['user'];
    final dimension = Utils.getDimensions(context, true);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
              const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(child: Icon(Remix.heart_line)),
                          SizedBox(
                            width: 6,
                          ),
                          Text('110')
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Icon(Remix.chat_4_line),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('32')
                        ],
                      ),
                      InkWell(child: Icon(Remix.bookmark_line))
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
              // User Comments
              feed["comments"].length == 0
                  ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  user['profileImage'],
                                  width: 40,
                                  height: 40,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SizedBox(
                            width: dimension['width']! - 98,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BaseText(
                                  title: user['name'],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const BaseText(
                                  title:
                                      'Agrichiktsa is best solution for test text the agriculture needs Agrichiktsa is best solution for the agriculture needs Agrichiktsa is best solution for the agriculture needs',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 40,
                child: InkWell(
                  onTap: () {
                    Utils.model(context, UserComment(user: user));
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
