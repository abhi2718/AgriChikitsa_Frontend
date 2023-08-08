import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankaritab.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    // var currentIndex = 0;
    // useEffect(() {
    //   print("Here");
    // }, [currentIndex]);
    List<Widget> tabs = [
      const HomeTabScreen(),
      const JankariHomeTab(),
      const MyProfileScreen(),
      const ProfileTabScreen()
    ];
    return Scaffold(
      body: tabs[currentIndex.value],
      // body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        backgroundColor: AppColor.lightColor,
        showSelectedLabels: true,
        selectedItemColor: AppColor.tabIconColor,
        unselectedItemColor: AppColor.extraDark,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex.value,
        onTap: (index) {
          currentIndex.value = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/home-2.svg',
              width: 23,
              height: 22,
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/home-filled.svg',
              width: 23,
              height: 22,
            ),
            label: AppLocalizations.of(context)!.homehi,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/jankari.svg',
              width: 23,
              height: 22,
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/jankari-filled.svg',
              width: 23,
              height: 22,
            ),
            label: AppLocalizations.of(context)!.jankarihi,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/timeline.svg',
              width: 23,
              height: 22,
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/timeline-filled.svg',
              width: 23,
              height: 22,
            ),
            label: AppLocalizations.of(context)!.timelinehi,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/settings.svg',
              width: 23,
              height: 22,
            ),
            activeIcon: SvgPicture.asset(
              'assets/svg/settings-filled.svg',
              width: 23,
              height: 22,
            ),
            label: AppLocalizations.of(context)!.settinghi,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 10.0,
          // child: const Icon(
          //   Icons.chat_bubble_outline,
          //   size: 30.0,
          // ),
          child: Image.asset(
            "assets/images/logoagrichikitsa.png",
            height: 40,
            width: 40,
          ),
          onPressed: () {
            Utils.model(context, ChatTabScreen());
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   notchMargin: 10,
      //   child: Container(
      //     height: 60,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             MaterialButton(
      //               onPressed: () {},
      //               minWidth: 40,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(Icons.home),
      //                   Text("Hey"),
      //                 ],
      //               ),
      //             ),
      //             MaterialButton(
      //               onPressed: () {
      //                 currentIndex = 1;
      //               },
      //               minWidth: 40,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(Icons.home),
      //                   Text("Hey"),
      //                 ],
      //               ),
      //             )
      //           ],
      //         )
      //       ],
      //     ),
      //   ),
      // ),
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
