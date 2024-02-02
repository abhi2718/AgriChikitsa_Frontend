import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_landing.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankaritab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      // const MyProfileScreen(),
      // const AGPlus(),
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
        height: 70,
        child: SizedBox(
          height: 60,
          child: Row(
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: currentIndex.value == 0
                    ? SvgPicture.asset(
                        'assets/svg/home-filled.svg',
                        width: 23,
                        height: 22,
                      )
                    : SvgPicture.asset(
                        'assets/svg/home-2.svg',
                        width: 23,
                        height: 22,
                      ),
                onPressed: () {
                  currentIndex.value = 0;
                },
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                // margin: const EdgeInsets.only(right: 80),
                child: IconButton(
                  icon: currentIndex.value == 1
                      ? SvgPicture.asset(
                          'assets/svg/jankari-filled.svg',
                          width: 23,
                          height: 22,
                        )
                      : SvgPicture.asset(
                          'assets/svg/jankari.svg',
                          width: 23,
                          height: 22,
                        ),
                  onPressed: () {
                    currentIndex.value = 1;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: IconButton(
                  icon: currentIndex.value == 2
                      ? SvgPicture.asset(
                          'assets/svg/agPlus_filled.svg',
                          width: 23,
                          height: 22,
                        )
                      : SvgPicture.asset(
                          'assets/svg/agPlus.svg',
                          width: 23,
                          height: 22,
                        ),
                  onPressed: () {
                    currentIndex.value = 2;
                  },
                ),
              ),
              IconButton(
                icon: currentIndex.value == 3
                    ? SvgPicture.asset(
                        'assets/svg/settings-filled.svg',
                        width: 23,
                        height: 22,
                      )
                    : SvgPicture.asset(
                        'assets/svg/settings.svg',
                        width: 23,
                        height: 22,
                      ),
                onPressed: () {
                  currentIndex.value = 3;
                },
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