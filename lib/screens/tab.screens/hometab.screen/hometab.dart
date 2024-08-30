import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/create_post_card.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import './hometab_view_model.dart';
import '../../../services/auth.dart';
import 'widgets/feed_loader.dart';
import 'widgets/header.dart';

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
    final homeTab = useRef(const HomeTabScreen1());
    return homeTab.value;
  }
}

class HomeTabScreen1 extends HookWidget {
  const HomeTabScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final scrollController = useScrollController();
    final appLifecycleState = useState(AppLifecycleState.resumed);
    final useViewModel = useMemoized(() => Provider.of<HomeTabViewModel>(context, listen: false));
    final createPostModel = useMemoized(() => Provider.of<CreatePostModel>(context, listen: true));
    // final myProfileViewModel =
    //     useMemoized(() => Provider.of<MyProfileViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: false);
    final notificationViewModel =
        useMemoized(() => Provider.of<NotificationViewModel>(context, listen: false));
    final profileViewModel =
        useMemoized(() => Provider.of<ProfileViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.getFCM(notificationViewModel);
      profileViewModel.getLocaleLanguage();
      useViewModel.getUserProfile(authService);
    }, []);

    useEffect(() {
      final binding = WidgetsBinding.instance;
      final observer = _AppLifecycleObserver((state) {
        appLifecycleState.value = state;
        if (state == AppLifecycleState.resumed) {
          Future.delayed(Duration.zero, () {
            notificationViewModel.fetchNotifications(context);
            //useViewModel.fetchFeeds(context);
          });
        }
      });
      binding.addObserver(observer);
      return () => binding.removeObserver(observer);
    }, []);

    useEffect(() {
      Future.delayed(Duration.zero, () {
        if (useViewModel.categoriesList.isEmpty) {
          useViewModel.fetchFeedsCategory(context);
        }
        if (useViewModel.feedList.isEmpty) {
          useViewModel.fetchFeeds(context);
        }
      });
    }, []);
    useEffect(() {
      if (createPostModel.fetchMyPost) {
        Future.delayed(const Duration(seconds: 1), () {
          useViewModel.fetchFeeds(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(0.0); // Use jumpTo for instant scroll
            }
          });
        });
        Future.delayed(Duration.zero, () {
          createPostModel.setfetchMyPost(false);
        });
      }
    }, [createPostModel.fetchMyPost]);

    Future refresh() async {
      useViewModel.fetchFeeds(context);
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(AppLocalization.of(context).getTranslatedValue("warningTitle").toString()),
            content:
                Text(AppLocalization.of(context).getTranslatedValue("warningSubTitle").toString()),
            actions: [
              TextButton(
                child: Text(
                  AppLocalization.of(context).getTranslatedValue("yes").toString(),
                  style: const TextStyle(color: Colors.red),
                ),
                onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              TextButton(
                child: Text(
                  AppLocalization.of(context).getTranslatedValue("no").toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () => Navigator.pop(c, false),
              ),
            ],
          ),
        );
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor.notificationBgColor,
          body: Column(
            children: [
              // Fixed Header
              HeaderWidget(
                profileViewModel: profileViewModel,
              ),
              // Scrollable content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refresh,
                  color: AppColor.darkColor,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Consumer<HomeTabViewModel>(builder: (context, provider, child) {
                      if (provider.loading) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              height: dimension['height']! * 0.17,
                              width: dimension['width'],
                              color: AppColor.whiteColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      children: [
                                        Skeleton(
                                          height: 40,
                                          width: 40,
                                          radius: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Skeleton(
                                            height: 13,
                                            width: dimension['width']! - 250,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10, right: 5, bottom: 2),
                                        child: Skeleton(
                                          width: dimension['width']! * 0.30,
                                          height: dimension['height']! * 0.055,
                                          radius: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return const FeedLoader();
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (provider.feedList.isEmpty) {
                        return SizedBox(
                          height: dimension['height']! - 100,
                          child: Center(
                            child: Text(AppLocalization.of(context)
                                .getTranslatedValue("noPostYet")
                                .toString()),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            const CreatePostCard(),
                            ListView.builder(
                              // controller: scrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.feedList.length,
                              itemBuilder: (context, index) {
                                return Feed(feed: provider.feedList[index]);
                              },
                            ),
                          ],
                        );
                      }
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
