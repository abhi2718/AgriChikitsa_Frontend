import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../res/color.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';
import './notification_widget.dart';
import './category_button.dart';

class HeaderWidget extends HookWidget {
  const HeaderWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Card(
      margin: const EdgeInsets.all(0),
      child: Container(
        color: AppColor.lightFeedContainerColor,
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
                  Image.asset(
                    "assets/images/logoagrichikitsa.png",
                    height: 40,
                    width: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NotificationIndicatorButton(
                        notificationCount: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer<AuthService>(
                          builder: (context, provider, child) {
                        if (provider.userInfo != null) {
                          final user = provider.userInfo["user"];
                          return CircleAvatar(
                            backgroundImage: NetworkImage(user["profileImage"]),
                          );
                        }
                        return Container();
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: dimension["width"],
              child: SizedBox(
                height: 30,
                // width: dimension["width"],
                child: Consumer<HomeTabViewModel>(
                  builder: (context, provider, child) {
                    return provider.categoryLoading
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100, // Set the width of each item
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Skeleton(
                                  height: 10,
                                  width: 80,
                                ),
                              );
                            })
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.categoriesList.length,
                            itemBuilder: (context, index) {
                              return CategoryButton(
                                category: provider.categoriesList[index],
                                onTap: () {
                                  Utils.toastMessage(
                                      provider.categoriesList[index].name);
                                  provider.setActiveState(
                                    context,
                                    provider.categoriesList[index],
                                    provider.categoriesList[index].isActive,
                                  );
                                },
                              );
                            });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
