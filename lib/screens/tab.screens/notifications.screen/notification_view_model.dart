import 'package:agriChikitsa/repository/notification.repo/notification_tab_repository.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class NotificationViewModel with ChangeNotifier {
  final _notificationTabRepository = NotificationTabRepository();
  List<dynamic> notificationsList = [];
  var notificationCount = 0;
  var _loading = false;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
  }

  void openLink(BuildContext context, String scheme, String host, String path) {
    try {
      final Uri toLaunch = Uri(scheme: scheme, host: host, path: '/$path');
      Utils.launchInWebViewWithoutJavaScript(toLaunch);
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void toggleNotifications(
      BuildContext context, String id, bool readStatus) async {
    try {
      if (!readStatus) {
        await _notificationTabRepository.toggleNotifications(id, {});
        notificationCount--;
        final index =
            notificationsList.indexWhere((element) => element['_id'] == id);
        final oldItem = notificationsList[index];
        dynamic updatedNotificationItem = {
          ...oldItem,
          "read": true,
        };
        notificationsList
            .replaceRange(index, index + 1, [updatedNotificationItem]);
      }
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void fetchNotifications(BuildContext context) async {
    setloading(true);
    try {
      final data = await _notificationTabRepository.fetchNotifications();
      notificationsList = data['notifications'];
      notificationCount = 0;
      notificationsList.forEach((element) {
        if (!element['read']) {
          notificationCount += 1;
        }
      });
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }
}
