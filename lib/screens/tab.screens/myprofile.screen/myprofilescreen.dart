import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/bookmarks.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/myprofile_feed.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../model/user_model.dart';
import '../../../res/color.dart';
import '../../../services/auth.dart';
import '../../../utils/utils.dart';
import '../../../widgets/text.widgets/text.dart';

class MyProfileScreen extends HookWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final authService = Provider.of<AuthService>(context, listen: true);
    final useViewModel = useMemoized(
        () => Provider.of<MyProfileViewModel>(context, listen: true));
    final user = User.fromJson(authService.userInfo["user"]);
    useEffect(() {
      useViewModel.fetchFeeds(context);
      useViewModel.fetchTimeline(context);
    }, []);
    const defaultImage =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png";
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: AppColor.whiteColor,
            foregroundColor: AppColor.darkBlackColor,
            flexibleSpace:
                const TabBar(padding: EdgeInsets.only(top: 10), tabs: [
              Tab(
                  child: BaseText(
                      title: "My Posts",
                      style: TextStyle(color: Colors.black))),
              Tab(
                  child: BaseText(
                      title: "Bookmarks",
                      style: TextStyle(color: Colors.black))),
            ]),
          ),
          body: TabBarView(
            children: [
              Consumer<MyProfileViewModel>(builder: (context, provider, child) {
                return provider.feedList == []
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const BaseText(
                            title: "No posts yet!",
                            style: TextStyle(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, RouteName.createPostRoute),
                            child: Container(
                                height: dimension['height']! * 0.07,
                                width: dimension['width']! * 0.30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.darkColor,
                                ),
                                child: const Center(
                                    child: BaseText(
                                  title: "Create one!",
                                  style: TextStyle(color: AppColor.whiteColor),
                                ))),
                          )
                        ],
                      )
                    : SizedBox(
                        height: dimension['height']! - 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.feedList.length,
                          itemBuilder: (context, index) {
                            final feed = provider.feedList[index];
                            return MyProfileFeed(feed: feed);
                          },
                        ),
                      );
              }),
              Consumer<MyProfileViewModel>(builder: (context, provider, child) {
                return provider.bookMarkFeedList.isEmpty
                    ? Container(
                        child: Center(child: Text("No Bookmarks added yet!")),
                      )
                    : provider.bookMarkLoader
                        ? SizedBox(
                            height: dimension['height']! - 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Skeleton(
                                                height: 40,
                                                width: 40,
                                                radius: 30,
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Skeleton(
                                                    height: 13,
                                                    width: dimension['width']! -
                                                        250,
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Skeleton(
                                                    height: 10,
                                                    width: dimension['width']! -
                                                        300,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Skeleton(
                                          height: 240,
                                          width: dimension['width']! - 16,
                                          radius: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Skeleton(
                                                height: 27,
                                                width: 30,
                                                radius: 0,
                                              ),
                                              Skeleton(
                                                height: 27,
                                                width: 30,
                                                radius: 0,
                                              ),
                                              Skeleton(
                                                height: 27,
                                                width: 30,
                                                radius: 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Skeleton(
                                            height: 72,
                                            width: dimension['width']!,
                                            radius: 0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            height: dimension['height']! - 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.bookMarkFeedList.length,
                              itemBuilder: (context, index) {
                                final feed = provider.bookMarkFeedList[index];
                                return BookmarkFeed(
                                  feed: feed,
                                );
                              },
                            ),
                          );
              })
            ],
          ),
        ),
      ),
    );
  }
}
