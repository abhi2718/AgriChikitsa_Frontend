import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/bookmarks.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/myprofile_feed.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/post_pre_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../utils/utils.dart';
import '../../../widgets/text.widgets/text.dart';

class MyProfileScreen extends HookWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<MyProfileViewModel>(context, listen: true));
    useEffect(() {
      useViewModel.fetchFeeds(context);
      useViewModel.fetchTimeline(context);
    }, []);
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: AppColor.whiteColor,
            foregroundColor: AppColor.darkBlackColor,
            flexibleSpace:
                TabBar(padding: const EdgeInsets.only(top: 10), tabs: [
              Tab(
                child: BaseText(
                  title: AppLocalizationsHi().mypost,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: BaseText(
                  title: AppLocalizationsHi().bookmark,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
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
                    : provider.loading
                        ? const PreLoader()
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
                    ? const Center(child: Text("No Bookmarks added yet!"))
                    : provider.bookMarkLoader
                        ? const PreLoader()
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
