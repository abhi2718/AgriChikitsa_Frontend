import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankaritab.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './hometab.screen/hometab.dart';
import './profiletab.screen/profiletab.dart';
import '../../res/color.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final homeTabKey = useMemoized(() => UniqueKey());
    final jankariHomeTabKey = useMemoized(() => UniqueKey());
    final myProfileScreenKey = useMemoized(() => UniqueKey());
    final profileTabScreenKey = useMemoized(() => UniqueKey());
    return Scaffold(
      body: IndexedStack(
        index: currentIndex.value,
        children: [
          HookBuilder(
            key: homeTabKey,
            builder: (context) {
              return const HomeTabScreen();
            },
          ),
          HookBuilder(
            key: jankariHomeTabKey,
            builder: (context) {
              return const JankariHomeTab();
            },
          ),
          HookBuilder(
            key: myProfileScreenKey,
            builder: (context) {
              return const MyProfileScreen();
            },
          ),
          HookBuilder(
            key: profileTabScreenKey,
            builder: (context) {
              return const ProfileTabScreen();
            },
          ),
        ],
      ),
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
            icon: Image.asset(
              'assets/icons/home-2.png',
              width: 23,
              height: 22,
            ),
            activeIcon: Image.asset(
              'assets/icons/Home Filled.png',
              width: 20,
              height: 20,
            ),
            label: AppLocalizations.of(context)!.homehi,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/jankari_new.png',
              width: 23,
              height: 22,
            ),
            activeIcon: Image.asset(
              'assets/icons/Jankari Filled.png',
              width: 23,
              height: 22,
            ),
            label: AppLocalizations.of(context)!.jankarihi,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/timeline.png',
              width: 23,
              height: 22,
            ),
            activeIcon: Image.asset(
              'assets/icons/timeline_filled.png',
              width: 23,
              height: 22,
            ),
            label: AppLocalizations.of(context)!.timelinehi,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/settings_new.png',
              width: 23,
              height: 22,
            ),
            activeIcon: Image.asset(
              'assets/icons/Settings Filled.png',
              width: 23,
              height: 22,
            ),
            label: AppLocalizations.of(context)!.settinghi,
          ),
        ],
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
