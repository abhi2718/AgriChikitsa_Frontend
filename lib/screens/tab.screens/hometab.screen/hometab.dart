import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/category_button.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../model/category_model.dart';
import './hometab_view_model.dart';
import './widgets/notification_widget.dart';
import '../../../services/auth.dart';

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final ValueChanged<AppLifecycleState> onAppLifecycleStateChanged;

  _AppLifecycleObserver(this.onAppLifecycleStateChanged);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    onAppLifecycleStateChanged(state);
  }
}

class HomeTabScreen extends HookWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userInput = TextEditingController();
    final dimension = Utils.getDimensions(context, true);
    const defaultImage =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png";
    final appLifecycleState = useState(AppLifecycleState.resumed);
    final useViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: false);
    late final List<Category> categories = useViewModel.categoriesList;
    // final activeCategoryIndex = useState<int>(0);
    // var activeCategory = categories1[activeCategoryIndex.value];
    useEffect(() {
      useViewModel.getUserProfile(authService);
    }, []);

    useEffect(() {
      final binding = WidgetsBinding.instance;
      final observer = _AppLifecycleObserver((state) {
        appLifecycleState.value = state;
        if (state == AppLifecycleState.resumed) {
          Future.delayed(Duration.zero, () {});
        }
      });
      binding.addObserver(observer);
      return () => binding.removeObserver(observer);
    }, []);
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.fetchFeeds(context);
        useViewModel.fetchFeedsCategory(context);
      });
    }, []);

    return (SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Consumer<HomeTabViewModel>(
            builder: (context, provider, child) {
              return provider.loading
                  ? SizedBox(
                      height: dimension['height'],
                      width: dimension['width'],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(0),
                          child: Container(
                            color: AppColor.lightColor,
                            height: 150,
                            width: dimension["width"],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Image.asset(
                                        "assets/images/logoagrichikitsa.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        NotificationIndicatorButton(
                                          notificationCount: 10,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        // InkWell(
                                        //   onTap: () =>
                                        //       useViewModel.goToProfile(context),
                                        //   child: Consumer<AuthService>(
                                        //     builder:
                                        //         (context, provider, child) {
                                        //       final user =
                                        //           provider.userInfo["user"];
                                        //       return Padding(
                                        //         padding: const EdgeInsets.only(
                                        //             right: 16),
                                        //         child: Container(
                                        //           alignment:
                                        //               Alignment.bottomRight,
                                        //           width: 30,
                                        //           height: 30,
                                        //           decoration: BoxDecoration(
                                        //             shape: BoxShape.circle,
                                        //             color: Colors.grey[300],
                                        //             image: DecorationImage(
                                        //               fit: BoxFit.fill,
                                        //               image: user["profileImage"] !=
                                        //                       null
                                        //                   ? NetworkImage(user[
                                        //                       "profileImage"])
                                        //                   : const NetworkImage(
                                        //                       defaultImage,
                                        //                     ),
                                        //             ),
                                        //           ),
                                        //           child: Container(),
                                        //         ),
                                        //       );
                                        //     },
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  // padding: EdgeInsets.symmetric(horizontal: 8),
                                  width: dimension["width"],
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: dimension["width"],
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: categories.length,
                                              itemBuilder: (context, index) {
                                                // final isActive =
                                                //     categories1[index].name ==
                                                //         activeCategory.name;
                                                return CategoryButton(
                                                  category: categories[index],
                                                  onTap: () {
                                                    Utils.toastMessage(
                                                        categories[index].name);
                                                    provider.setActiveState(
                                                        categories[index],
                                                        categories[index]
                                                            .isActive);
                                                    // activeCategory =
                                                    //     categories1[index];
                                                  },
                                                );
                                              }),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: dimension['height']! - 150,
                          child: ListView.builder(
                            itemCount: provider.feedList.length,
                            itemBuilder: (context, index) {
                              final feed = provider.feedList[index];
                              if (provider.currentSelectedCategory.isEmpty) {
                                return Feed(
                                  feed: feed,
                                );
                              } else if (provider.feedList[index]
                                      ['categoryRef'] ==
                                  provider.currentSelectedCategory) {
                                return Feed(feed: feed);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    ));
  }
}
