import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofilescreen.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../notifications.screen/notification_view_model.dart';
import './category_button.dart';
import './notification_widget.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';

class HeaderWidget extends HookWidget {
  const HeaderWidget(
      {Key? key, required this.profileViewModel, required this.homeScrollController});
  final ProfileViewModel profileViewModel;
  final ScrollController homeScrollController;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<NotificationViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.fetchNotifications(context);
    }, [useViewModel.notificationCount]);
    return Container(
      color: AppColor.whiteColor,
      height: 100,
      width: dimension["width"],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Utils.model(context, const MyProfileScreen());
                  },
                  child: SvgPicture.asset(
                    'assets/svg/timeline.svg',
                    width: 23,
                    height: 22,
                  ),
                ),
                InkWell(
                  onTap: () => homeScrollController.animateTo(
                    0.0,
                    duration: const Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn,
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/homeScreenLogo.svg',
                    height: 40,
                    width: 80,
                  ),
                ),
                Consumer<NotificationViewModel>(builder: (context, provider, child) {
                  return NotificationIndicatorButton(
                    notificationCount: provider.notificationCount,
                  );
                })
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     SizedBox(
                //       width: dimension['width']! * 0.04,
                //     ),
                //     ,
                //   ],
                // )
              ],
            ),
          ),
          SizedBox(
            height: 30,
            child: Consumer<HomeTabViewModel>(
              builder: (context, provider, child) {
                return provider.categoryLoading
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Skeleton(
                              height: 10,
                              width: 100,
                              radius: 10,
                            ),
                          );
                        })
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categoriesList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: index == 0 ? 8 : 0),
                            child: CategoryButton(
                              profileViewModel: profileViewModel,
                              category: provider.categoriesList[index],
                              provider: provider,
                              onTap: () {
                                provider.setActiveState(
                                  context,
                                  provider.categoriesList[index],
                                  provider.categoriesList[index].isActive,
                                );
                              },
                            ),
                          );
                        });
              },
            ),
          ),
        ],
      ),
    );
  }
}
