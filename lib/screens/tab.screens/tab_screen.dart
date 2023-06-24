import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankaritab.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import './hometab.screen/hometab.dart';
import './profiletab.screen/profiletab.dart';
import '../../res/color.dart';

class TabScreen extends HookWidget {
  const TabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<TabViewModel>(context, listen: false);
    final List tabScreen = useMemoized(() {
      return [
        const HomeTabScreen(),
        const JankariHomeTab(),
        const MyProfileScreen(),
        const ProfileTabScreen(),
      ];
    });
    final tabWidgets = useMemoized(() {
      return [
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
          label: AppLocalizations.of(context)!.homehi,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/Jankari Icon.png',
            width: 20,
            height: 20,
          ),
          activeIcon: Image.asset(
            'assets/icons/Jankari Filled.png',
            width: 20,
            height: 20,
          ),
          label: AppLocalizations.of(context)!.jankarihi,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.view_timeline_outlined),
          activeIcon: const Icon(Icons.view_timeline_rounded),
          label: AppLocalizations.of(context)!.timelinehi,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/Settings.png',
            width: 20,
            height: 20,
          ),
          activeIcon: Image.asset(
            'assets/icons/Settings Filled.png',
            width: 20,
            height: 20,
          ),
          label: AppLocalizations.of(context)!.settinghi,
        ),
      ];
    });

    return Scaffold(
      body: Consumer<TabViewModel>(builder: (context, provider, child) {
        return tabScreen[provider.screenIndex];
      }),
      bottomNavigationBar: Consumer<TabViewModel>(
        builder: (context, provider, child) {
          return BottomNavigationBar(
            onTap: useViewModel.onTap,
            showUnselectedLabels: true,
            backgroundColor: AppColor.lightColor,
            showSelectedLabels: true,
            selectedItemColor: AppColor.darkColor,
            unselectedItemColor: AppColor.extraDark,
            currentIndex: useViewModel.screenIndex,
            type: BottomNavigationBarType.fixed,
            items: tabWidgets,
          );
        },
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
  void disposeValues(){
    screenIndex = 0;
  }
}
