import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/widgets/notification_tile.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../res/color.dart';
import '../../../utils/utils.dart';
import '../../../widgets/text.widgets/text.dart';

class NotificationScreen extends HookWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<NotificationViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.fetchNotifications(context);
    }, []);
    return Scaffold(
        backgroundColor: AppColor.notificationBgColor,
        appBar: AppBar(
          title: const BaseText(
            title: 'Notification',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: AppColor.whiteColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Remix.arrow_left_line,
                color: AppColor.darkBlackColor,
              )),
        ),
        body: Consumer<NotificationViewModel>(
            builder: (context, provider, child) {
          final notificationList = provider.notificationsList;
          return useViewModel.loading
              ? ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Skeleton(
                          height: dimension['height']! * 0.11,
                          width: dimension['width']!),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: notificationList.length,
                  itemBuilder: (context, index) {
                    final notificationItem =
                        useViewModel.notificationsList[index];
                    return NotificationTile(
                      notificationItem: notificationItem,
                    );
                  });
        }));
  }
}
