import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/widgets/myprofile_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../model/user_model.dart';
import '../../../res/color.dart';
import '../../../services/auth.dart';
import '../../../utils/utils.dart';
import '../../../widgets/text.widgets/text.dart';
import '../hometab.screen/widgets/feed.dart';

class MyProfileScreen extends HookWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final authService = Provider.of<AuthService>(context, listen: true);
    final useViewModel = useMemoized(
        () => Provider.of<MyProfileViewModel>(context, listen: false));
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
                    ? Container(
                        child: Text("No Post"),
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
                        child: Text("Nothing"),
                      )
                    : SizedBox(
                        height: dimension['height']! - 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.bookMarkFeedList.length,
                          itemBuilder: (context, index) {
                            final feed = provider.bookMarkFeedList[index];
                            return Feed(
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
