import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/create_post_card.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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
    final appLifecycleState = useState(AppLifecycleState.resumed);
    final useViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: false);
    final notificationViewModel = useMemoized(
        () => Provider.of<NotificationViewModel>(context, listen: false));

    useEffect(() {
      useViewModel.getFCM(notificationViewModel);
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
        useViewModel.fetchFeeds(context);
      });
    }, []);

    Future refresh() async {
      useViewModel.fetchFeeds(context);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.notificationBgColor,
        body: Column(
          children: [
            const HeaderWidget(),
            RefreshIndicator(
              onRefresh: refresh,
              child: Consumer<HomeTabViewModel>(
                  builder: (context, provider, child) {
                return provider.loading
                    ? SizedBox(
                        height: dimension['height']! - 100,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Card(
                                    child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  height: dimension['height']! * 0.16,
                                  width: dimension['width'],
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          children: [
                                            Skeleton(
                                              height: 40,
                                              width: 40,
                                              radius: 30,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Skeleton(
                                                height: 13,
                                                width:
                                                    dimension['width']! - 250,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 5, bottom: 2),
                                              child: Skeleton(
                                                width:
                                                    dimension['width']! * 0.30,
                                                height: dimension['height']! *
                                                    0.055,
                                                radius: 10,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
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
                          ),
                        ),
                      )
                    : provider.feedList.isEmpty
                        ? SizedBox(
                            height: dimension['height']! - 100,
                            child: Center(
                              child: Text(
                                  AppLocalizations.of(context)!.nopostYethi),
                            ),
                          )
                        : SizedBox(
                            height: dimension['height']! - 100,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const CreatePostCard(),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: provider.feedList.length,
                                    itemBuilder: (context, index) {
                                      final feed = provider.feedList[index];
                                      return Feed(
                                        feed: feed,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pushNamed(context, RouteName.chatBotRoute);
            }),
      ),
    );
  }
}
