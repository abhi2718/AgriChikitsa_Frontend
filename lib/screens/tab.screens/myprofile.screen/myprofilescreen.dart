import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/bookmarks.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/myprofile_feed.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/post_pre_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                      title: AppLocalizations.of(context)!.myPosthi,
                      style: const TextStyle(color: Colors.black))),
              Tab(
                  child: BaseText(
                      title: AppLocalizations.of(context)!.bookmarkhi,
                      style: const TextStyle(color: Colors.black))),
            ]),
          ),
          body: TabBarView(
            children: [
              Consumer<MyProfileViewModel>(builder: (context, provider, child) {
                return provider.loading
                    ? const PreLoader()
                    : provider.feedList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BaseText(
                                title:
                                    AppLocalizations.of(context)!.nopostYethi,
                                style: const TextStyle(),
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
                                    child: Center(
                                        child: BaseText(
                                      title: AppLocalizations.of(context)!
                                          .createOnehi,
                                      style: const TextStyle(
                                          color: AppColor.whiteColor),
                                    ))),
                              )
                            ],
                          )
                        : SizedBox(
                            height: dimension['height']! - 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.feedList.length,
                              itemBuilder: (context, index) {
                                final feed = provider.feedList[index];
                                return MyProfileFeed(feed: feed);
                              },
                            ),
                          );
              }),
              Consumer<MyProfileViewModel>(builder: (context, provider, child) {
                return provider.bookMarkLoader
                    ? const PreLoader()
                    : provider.bookMarkFeedList.isEmpty
                        ? Center(
                            child: Text(
                                AppLocalizations.of(context)!.noBookMarkAdd))
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
