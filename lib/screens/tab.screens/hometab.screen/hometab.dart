import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/create_post_card.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../chattab.screen/chattab.dart';
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
    final dimension = Utils.getDimensions(context, true);
    final appLifecycleState = useState(AppLifecycleState.resumed);
    final useViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: false);

    useEffect(() {
      useViewModel.getUserProfile(authService);
    }, []);

    useEffect(() {
      final binding = WidgetsBinding.instance;
      final observer = _AppLifecycleObserver((state) {
        appLifecycleState.value = state;
        if (state == AppLifecycleState.resumed) {
          Future.delayed(Duration.zero, () {
            useViewModel.fetchFeeds(context);
          });
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

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const HeaderWidget(),
            Consumer<HomeTabViewModel>(builder: (context, provider, child) {
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
                                height: dimension['height']! * 0.182,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Skeleton(
                                              height: 13,
                                              width: dimension['width']! - 250,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Skeleton(
                                          height: 50,
                                          width: dimension['width']!,
                                          radius: 6,
                                        )),
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
                  : SizedBox(
                      height: dimension['height']! - 100,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const CreatePostCard(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
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
