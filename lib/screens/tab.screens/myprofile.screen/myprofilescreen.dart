import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:flutter/foundation.dart';
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
    }, []);
    const defaultImage =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png";
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: AppColor.whiteColor,
            foregroundColor: AppColor.darkBlackColor,
            centerTitle: true,
            flexibleSpace: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      //image: NetworkImage("https://cdn.imgbin.com/6/25/24/imgbin-user-profile-computer-icons-user-interface-mystique-aBhn3R8cmqmP4ECky4DA3V88y.jpg"),
                      image: user.profileImage != null
                          ? NetworkImage(user.profileImage!)
                          : const NetworkImage(
                              defaultImage,
                            ),
                    ),
                  ),
                  child: Container(),
                ),
                SizedBox(
                  height: 10,
                ),
                BaseText(title: user.name.toString(), style: TextStyle()),
              ],
            ),
            bottom: TabBar(tabs: [
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
        ),
        body: TabBarView(
          children: [
            Container(
              child: Text("My Posts"),
            ),
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
    );
  }
}
