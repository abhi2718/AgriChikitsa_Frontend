import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

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

class Category {
  final String name;
  bool isActive;

  Category({required this.name, this.isActive = false});
}

class HomeTabScreen extends HookWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userInput = TextEditingController();
    final dimension = Utils.getDimensions(context, true);
    final List<Category> categories = [
      Category(name: 'Category 1', isActive: true),
      Category(name: 'Category 2', isActive: false),
      Category(name: 'Category 3', isActive: false),
      Category(name: 'Category 4', isActive: false),
      Category(name: 'Category 5', isActive: false),
      Category(name: 'Category 6', isActive: false),
      Category(name: 'Category 7', isActive: false),
      Category(name: 'Category 8', isActive: false),
      Category(name: 'Category 9', isActive: false),
      Category(name: 'Category 10', isActive: false),
    ];
    final activeCategory = useState<Category?>(categories[0]);
    const defaultImage =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png";
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
          Future.delayed(Duration.zero, () {});
        }
      });
      binding.addObserver(observer);
      return () => binding.removeObserver(observer);
    }, []);
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.fetchFeeds(context);
      });
    }, []);

    return (SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Consumer<HomeTabViewModel>(
            builder: (context, provider, child) {
              return provider.loading
                  ? Container(
                      height: dimension['height'],
                      width: dimension['width'],
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      children: [
                        Card(
                          margin: EdgeInsets.all(0),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
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
                                        InkWell(
                                          onTap: () =>
                                              useViewModel.goToProfile(context),
                                          child: Consumer<AuthService>(
                                            builder:
                                                (context, provider, child) {
                                              final user =
                                                  provider.userInfo["user"];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16),
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey[300],
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: user["profileImage"] !=
                                                              null
                                                          ? NetworkImage(user[
                                                              "profileImage"])
                                                          : const NetworkImage(
                                                              defaultImage,
                                                            ),
                                                    ),
                                                  ),
                                                  child: Container(),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: dimension["width"],
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: categories.map((category) {
                                          final isActive = category.name ==
                                              activeCategory.value!.name;
                                          return InkWell(
                                            onTap: () {
                                              Utils.toastMessage(category.name);
                                              activeCategory.value = category;
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: isActive
                                                    ? AppColor.darkColor
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: isActive
                                                      ? AppColor.darkColor
                                                      : AppColor.darkColor,
                                                  width: isActive ? 2 : 1,
                                                ),
                                              ),
                                              child: Text(
                                                category.name,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: isActive
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
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
                            itemBuilder: (context, index) {
                              final feed = provider.feedList[index];

                              return Feed(
                                feed: feed,
                              );
                            },
                            itemCount: provider.feedList.length,
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
