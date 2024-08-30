import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/comment.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/userProfile.screen/feed_user_profile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/bookmarks.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/myprofile_feed.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/post_pre_loader.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
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

    double availableHeight = screenHeight - (2 * appBarHeight + statusBarHeight);
    final useViewModel = useMemoized(() => Provider.of<MyProfileViewModel>(context, listen: true));
    final createPostModel = useMemoized(() => Provider.of<CreatePostModel>(context, listen: true));
    final feedProfileViewModel =
        useMemoized(() => Provider.of<FeedUserProfileViewModel>(context, listen: false));

    final authService = Provider.of<AuthService>(context, listen: false);
    final userInfo = User.fromJson(authService.userInfo["user"]);

    useEffect(() {
      feedProfileViewModel.fetchUserFeeds(context, userInfo.id);
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
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: AppColor.notificationBgColor,
            foregroundColor: AppColor.darkBlackColor,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<FeedUserProfileViewModel>(builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(userInfo.profileImage),
                        radius: dimension["width"]! * 0.08,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                useViewModel.feedList.length.toString(),
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("postsTile")
                                    .toString(),
                                style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Text(
                                provider.connections == null
                                    ? "0"
                                    : provider.connections['followers'].length.toString(),
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("followersTitle")
                                    .toString(),
                                style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Text(
                                provider.connections == null
                                    ? "0"
                                    : provider.connections['following'].length.toString(),
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("followingTitle")
                                    .toString(),
                                style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(userInfo.name,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              TabBar(
                  indicatorColor: AppColor.extraDark,
                  onTap: (index) {
                    useViewModel.setActiveTabIndex(true);
                  },
                  tabs: [
                    Tab(
                        child: BaseText(
                            title: AppLocalization.of(context)
                                .getTranslatedValue("myPostHeader")
                                .toString(),
                            style: const TextStyle(color: Colors.black))),
                    Tab(
                        child: BaseText(
                            title: AppLocalization.of(context)
                                .getTranslatedValue("bookmarkhHeader")
                                .toString(),
                            style: const TextStyle(color: Colors.black))),
                  ]),
              Expanded(
                child: TabBarView(
                  children: [
                    Consumer<MyProfileViewModel>(builder: (context, provider, child) {
                      return provider.loading
                          ? const PreLoader()
                          : provider.feedList.isEmpty
                              ? GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, RouteName.createPostRoute),
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: AppColor.extraDark),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        BaseText(
                                          title: AppLocalization.of(context)
                                              .getTranslatedValue("noPostYet")
                                              .toString(),
                                          style: const TextStyle(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          // onTap: () =>
                                          //     Navigator.pushNamed(context, RouteName.createPostRoute),
                                          child: Container(
                                              height: dimension['height']! * 0.07,
                                              width: dimension['width']! * 0.30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: AppColor.darkColor,
                                              ),
                                              child: Center(
                                                  child: BaseText(
                                                title: AppLocalization.of(context)
                                                    .getTranslatedValue("createNewPost")
                                                    .toString(),
                                                style: const TextStyle(color: AppColor.whiteColor),
                                              ))),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: refresh,
                                  color: AppColor.extraDark,
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
                    Consumer<MyProfileViewModel>(builder: (context, provider, child) {
                      return provider.bookMarkLoader
                          ? const PreLoader()
                          : provider.bookMarkFeedList.isEmpty
                              ? Center(
                                  child: Text(AppLocalization.of(context)
                                      .getTranslatedValue("noBookMarkAdd")
                                      .toString()))
                              : SizedBox(
                                  height: availableHeight,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: provider.bookMarkFeedList.reversed.map((feed) {
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
