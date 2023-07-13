import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../routes/routes_name.dart';
import '../../notifications.screen/notification_view_model.dart';
import './category_button.dart';
import './notification_widget.dart';
import '../../../../res/color.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';

class HeaderWidget extends HookWidget {
  const HeaderWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<NotificationViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.fetchNotifications(context);
    }, [useViewModel.notificationCount]);
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteName.weatherScreenRoute);
                        },
                        child: const Icon(Icons.thunderstorm_outlined),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer<NotificationViewModel>(
                          builder: (context, provider, child) {
                        return NotificationIndicatorButton(
                          notificationCount: provider.notificationCount,
                        );
                      }),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer<AuthService>(
                          builder: (context, provider, child) {
                        if (provider.userInfo != null) {
                          final user = provider.userInfo["user"];
                          final profileImage = user['profileImage'].split(
                              'https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1];
                          return SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://d336izsd4bfvcs.cloudfront.net/$profileImage',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Skeleton(
                                  height: 40,
                                  width: 40,
                                  radius: 0,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                width: 40,
                                fit: BoxFit.cover,
                                height: 40,
                              ),
                            ),
                          );
                          // return CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //       'https://d336izsd4bfvcs.cloudfront.net/$profileImage'),
                          // );
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
                                  width: 100,
                                  radius: 10,
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
