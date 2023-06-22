import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../res/color.dart';
import '../../../utils/utils.dart';
import '../../../widgets/text.widgets/text.dart';

class NotificationsScreen extends HookWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<NotificationViewModel>(context, listen: true));
    useEffect(() {
      useViewModel.fetchNotifications(context);
    }, []);
    const defaultImage =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png";
    return Scaffold(
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
                color: Colors.black,
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
                    return ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, right: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Container(
                            height: dimension['height']! * 0.11,
                            width: dimension['width']! - 20,
                            decoration: const BoxDecoration(
                              color: Color(0xffd9d9d9),
                              borderRadius: BorderRadius.all(
                                Radius.circular(18.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        child: notificationList[index]
                                                    ['imgurl'] !=
                                                null
                                            ? Image.network(
                                                notificationList[index]
                                                    ['imgurl'],
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                defaultImage,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BaseText(
                                        title: notificationList[index]['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: AppColor.darkBlackColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      BaseText(
                                        title:
                                            'Reply : ${notificationList[index]['message']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.darkBlackColor,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
        }));
  }
}
