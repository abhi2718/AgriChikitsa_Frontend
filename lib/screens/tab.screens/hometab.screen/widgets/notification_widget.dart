import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:flutter/material.dart';

class NotificationIndicatorButton extends StatelessWidget {
  final notificationCount;

  const NotificationIndicatorButton({super.key, this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, RouteName.notificationScreenRoute),
      child: Stack(
        children: [
          const Icon(
            Icons.notifications_outlined,
            size: 32,
          ),
          if (notificationCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColor.errorColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  notificationCount.toString(),
                  style: const TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
