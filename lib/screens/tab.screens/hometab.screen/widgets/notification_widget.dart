import 'package:agriChikitsa/screens/tab.screens/hometab.screen/notification.screen/notification.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';

class NotificationIndicatorButton extends StatelessWidget {
  final notificationCount;

  NotificationIndicatorButton({super.key, this.notificationCount});

  @override
  Widget build(BuildContext context) {
    void handleNotification() {
      Utils.toastMessage("Notification Indicator Button");
    }

    return InkWell(
      onTap: handleNotification,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NoticationScreen(),
                ),
              );
            },
            child: Image.asset(
              "assets/images/bell.png",
              height: 30,
              width: 30,
            ),
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
