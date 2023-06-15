import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankaritab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import './hometab.screen/hometab.dart';
import './profiletab.screen/profiletab.dart';
import '../../res/color.dart';
import 'chattab.screen/chattab.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List tabScreen = [
      const HomeTabScreen(),
      const ChatTabScreen(),
      const JankariHomeTab(),
      const ProfileTabScreen(),
    ];
    final screenIndex = useState(0);
    void onTap(int index) {
      screenIndex.value = index;
    }

    return Scaffold(
      body: tabScreen[screenIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        showUnselectedLabels: true,
        backgroundColor: AppColor.lightColor,
        showSelectedLabels: true,
        selectedItemColor: AppColor.darkColor,
        unselectedItemColor: AppColor.extraDark,
        currentIndex: screenIndex.value,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/Home.png',
                width: 20,
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/icons/Home Filled.png',
                width: 20,
                height: 20,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/Chat Icon.png',
                width: 20,
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/icons/Chat Icon Filled.png',
                width: 20,
                height: 20,
              ),
              label: 'Chat'),
          // BottomNavigationBarItem(
          //   icon: Image.asset(
          //     'assets/icons/ag.png',
          //     width: 20,
          //     height: 20,
          //   ),
          //   activeIcon: Image.asset(
          //     'assets/images/active_add.png',
          //     width: 20,
          //     height: 20,
          //   ),
          //   label: 'AG+',
          // ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Jankari Icon.png',
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/Jankari Icon Filled.png',
              width: 20,
              height: 20,
            ),
            label: 'Jankari',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Settings.png',
              width: 20,
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/Setting Filled.png',
              width: 20,
              height: 20,
            ),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
