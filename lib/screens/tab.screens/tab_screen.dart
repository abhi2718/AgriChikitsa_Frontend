import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_landing.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankaritab.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import './hometab.screen/hometab.dart';
import './profiletab.screen/profiletab.dart';
import '../../res/color.dart';
import 'chattab.screen/chattab.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    List<Widget> tabs = [
      const HomeTabScreen(),
      const JankariHomeTab(),
      const AGPlusLanding(),
      const ProfileTabScreen()
    ];
    return Scaffold(
      body: tabs[currentIndex.value],
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.white,
          elevation: 10.0,
          child: Image.asset(
            "assets/images/logoagrichikitsa.png",
            height: 40,
            width: 40,
          ),
          onPressed: () {
            Utils.model(context, const ChatTabScreen());
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 6.0,
        color: AppColor.notificationBgColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        height: 60,
        child: SizedBox(
          height: 60,
          child: Row(
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  currentIndex.value = 0;
                },
                child: Column(
                  children: [
                    currentIndex.value == 0
                        ? SvgPicture.asset(
                            'assets/svg/home-filled.svg',
                            width: 22,
                            height: 20,
                          )
                        : SvgPicture.asset(
                            'assets/svg/home-2.svg',
                            width: 22,
                            height: 20,
                          ),
                    Text(
                      AppLocalization.of(context).getTranslatedValue("homeTab").toString(),
                      style: TextStyle(
                          fontSize: 11,
                          color: currentIndex.value == 0 ? AppColor.extraDark : null,
                          fontWeight: currentIndex.value == 0 ? FontWeight.w500 : null),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  currentIndex.value = 1;
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  // margin: const EdgeInsets.only(right: 80),
                  child: Column(
                    children: [
                      currentIndex.value == 1
                          ? SvgPicture.asset(
                              'assets/svg/jankari-filled.svg',
                              width: 22,
                              height: 20,
                            )
                          : SvgPicture.asset(
                              'assets/svg/jankari.svg',
                              width: 22,
                              height: 20,
                            ),
                      Text(
                        AppLocalization.of(context).getTranslatedValue("jankariTab").toString(),
                        style: TextStyle(
                            fontSize: 11,
                            color: currentIndex.value == 1 ? AppColor.extraDark : null,
                            fontWeight: currentIndex.value == 1 ? FontWeight.w500 : null),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  currentIndex.value = 2;
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      currentIndex.value == 2
                          ? SvgPicture.asset(
                              'assets/svg/agPlus_filled.svg',
                              width: 22,
                              height: 19,
                            )
                          : SvgPicture.asset(
                              'assets/svg/agPlus.svg',
                              width: 22,
                              height: 19,
                            ),
                      Text(
                        AppLocalization.of(context).getTranslatedValue("agTab").toString(),
                        style: TextStyle(
                            fontSize: 11,
                            color: currentIndex.value == 2 ? AppColor.extraDark : null,
                            fontWeight: currentIndex.value == 2 ? FontWeight.w500 : null),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  currentIndex.value = 3;
                },
                child: Column(
                  children: [
                    // currentIndex.value == 3
                    // ? SvgPicture.network(
                    //     'assets/svg/settings-filled.svg',
                    //     width: 22,
                    //     height: 20,
                    //   )
                    Consumer<AuthService>(builder: (context, provider, child) {
                      if (provider.userInfo != null) {
                        final user = provider.userInfo["user"];
                        final profileImage = user['profileImage'];
                        return SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: profileImage,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Skeleton(
                                height: 23,
                                width: 20,
                                radius: 0,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              width: 23,
                              fit: BoxFit.cover,
                              height: 20,
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
                    Text(
                      AppLocalization.of(context).getTranslatedValue("profileTab").toString(),
                      style: TextStyle(
                          fontSize: 11,
                          color: currentIndex.value == 3 ? AppColor.extraDark : null,
                          fontWeight: currentIndex.value == 3 ? FontWeight.w500 : null),
                    ),
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

class TabViewModel with ChangeNotifier {
  var screenIndex = 0;
  void onTap(int index) {
    screenIndex = index;
    notifyListeners();
  }

  void disposeValues() {
    screenIndex = 0;
  }
}


// Container(
//                 // margin: const EdgeInsets.only(left: 20),
//                 margin: const EdgeInsets.only(right: 40),
//                 child: IconButton(
//                   icon: currentIndex.value == 3
//                       ? SvgPicture.asset(
//                           'assets/svg/timeline-filled.svg',
//                           width: 23,
//                           height: 22,
//                         )
//                       : SvgPicture.asset(
//                           'assets/svg/timeline.svg',
//                           width: 23,
//                           height: 22,
//                         ),
//                   onPressed: () {
//                     currentIndex.value = 3;
//                   },
//                 ),
//               ),