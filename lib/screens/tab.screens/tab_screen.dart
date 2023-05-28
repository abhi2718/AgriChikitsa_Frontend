import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './hometab.screen/hometab.dart';
import './historytab.screen/historytab.dart';
import './profiletab.screen/profiletab.dart';
import '../../res/color.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List tabScreen = [
      const HomeTabScreen(),
      const HistortTabScreen(),
      const ProfileTabScreen()
    ];
    final  screenIndex = useState(0);
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
        type:BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/homeDeactive.png',
                width: 20,
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/images/homeActive.png',
                width: 20,
                height: 20,
              ),
              label: 'Home'
              ),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/historyDeactive.png',
                width: 20,
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/images/historyActive.png',
                width: 20,
                height: 20,
              ),
              label: 'History'
              ),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/profileDeactive.png',
                width: 20,
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/images/profileActive.png',
                width: 20,
                height: 20,
              ),
              label: 'Profile'
              ),
        ],
      ),
    );
  }
}
