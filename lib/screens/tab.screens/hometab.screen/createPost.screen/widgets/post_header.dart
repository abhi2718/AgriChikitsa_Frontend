import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/notification_widget.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.all(0),
        child: Container(
          color: AppColor.lightFeedContainerColor,
          height: 60,
          width: dimension['width'],
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
                                backgroundImage:
                                    NetworkImage(user["profileImage"]),
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
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
