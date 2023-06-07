import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class Feed extends StatelessWidget {
  final feed;

  Feed({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    final user = feed['user'];
    final dimension = Utils.getDimensions(context, true);

    return Container(
      height: 543.75,
      width: 390,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user['profileImage']),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseText(
                            title: user['name'],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          BaseText(
                            title: '@atin',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  child: Icon(Remix.more_2_line),
                ),
              ],
            ),
          ),
          Center(
            child: Image.network(feed['imgurl']),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: [
                InkWell(child: Icon(Remix.heart_line)),
                SizedBox(
                  width: 5,
                ),
                Text('110'),
                SizedBox(
                  width: 60,
                ),
                InkWell(
                  child: Icon(Remix.chat_4_line),
                ),
                SizedBox(
                  width: 10,
                ),
                Text('32'),
                SizedBox(
                  width: 140,
                ),
                InkWell(child: Icon(Remix.bookmark_line))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user['profileImage']),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 8, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          title: user['name'],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        BaseText(
                          title:
                              'Agrichiktsa is best solution for the agriculture\n needs',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              showBottomSheet(
                  context: context,
                  builder: (builder) {
                    return Container(
                      height: 550,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Wrap(
                          children: [
                            const Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/person.png'),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 8, 0, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BaseText(
                                    title: 'Atin Singh',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  BaseText(
                                    title:
                                        'Agrichiktsa is best solution for the agriculture\nneeds',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 350),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/images/person.png'),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 235,
                                          height: 48,
                                          child: const TextField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color.fromARGB(
                                                  255, 189, 188, 188),
                                              hintText: 'Add Comment',
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(18),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 35,
                                              height: 35,
                                              child: const InkWell(
                                                child: Image(
                                                    image: AssetImage(
                                                        'assets/icons/send_icon.png')),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              height: 40,
              width: 330,
              decoration: const BoxDecoration(
                color: Color(0xffd9d9d9),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: BaseText(
                        title: 'Write A Comment',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
