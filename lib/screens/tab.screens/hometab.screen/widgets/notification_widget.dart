import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Image.asset(
            "assets/images/bell.png",
            height: 30,
            width: 30,
          ),
          if (notificationCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  notificationCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
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
