import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
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
import '../hometab.screen/createPost.screen/create_post_model.dart';

class MyProfileScreen extends HookWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    double availableHeight =
        screenHeight - (2 * appBarHeight + statusBarHeight);
    final useViewModel = useMemoized(
        () => Provider.of<MyProfileViewModel>(context, listen: true));
    final createPostModel =
        useMemoized(() => Provider.of<CreatePostModel>(context, listen: true));

    useEffect(() {
      if (useViewModel.feedList.isEmpty) {
        useViewModel.fetchFeeds(context);
      }
      if (useViewModel.bookMarkFeedList.isEmpty) {
        useViewModel.fetchTimeline(context);
      }
    }, []);
    useEffect(() {
      if (createPostModel.fetchMyPost) {
        useViewModel.fetchFeeds(context);
        Future.delayed(Duration.zero, () {
          createPostModel.setfetchMyPost(false);
        });
      }
    }, [createPostModel.fetchMyPost]);
    Future refresh() async {
      useViewModel.fetchFeeds(context);
    }

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.notificationBgColor,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0.0,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: AppColor.notificationBgColor,
            foregroundColor: AppColor.darkBlackColor,
          ),
          body: Column(
            children: [
              TabBar(
                  onTap: (index) {
                    useViewModel.setActiveTabIndex(true);
                  },
                  tabs: [
                    Tab(
                        child: BaseText(
                            title: AppLocalizations.of(context)!.myPosthi,
                            style: const TextStyle(color: Colors.black))),
                    Tab(
                        child: BaseText(
                            title: AppLocalizations.of(context)!.bookmarkhi,
                            style: const TextStyle(color: Colors.black))),
                  ]),
              Expanded(
                child: TabBarView(
                  children: [
                    Consumer<MyProfileViewModel>(
                        builder: (context, provider, child) {
                      return provider.loading
                          ? const PreLoader()
                          : provider.feedList.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BaseText(
                                      title: AppLocalizations.of(context)!
                                          .nopostYethi,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                              : RefreshIndicator(
                                  onRefresh: refresh,
                                  child: SizedBox(
                                    height: availableHeight,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: provider.feedList.length,
                                      itemBuilder: (context, index) {
                                        final feed = provider.feedList[index];
                                        return MyProfileFeed(feed: feed);
                                      },
                                    ),
                                  ),
                                );
                    }),
                    Consumer<MyProfileViewModel>(
                        builder: (context, provider, child) {
                      return provider.bookMarkLoader
                          ? const PreLoader()
                          : provider.bookMarkFeedList.isEmpty
                              ? Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .noBookMarkAddhi))
                              : SizedBox(
                                  height: availableHeight,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: provider
                                          .bookMarkFeedList.reversed
                                          .map((feed) {
                                        return BookmarkFeed(
                                          key: ObjectKey(feed["_id"]),
                                          feed: feed,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
