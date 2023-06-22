import 'package:agriChikitsa/repository/notification.repo/notification_tab_repository.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class NotificationViewModel with ChangeNotifier {
  final _notificationTabRepository = NotificationTabRepository();
  dynamic notificationsList = [];
  var notificationCount = 0;
  var _loading = false;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
  }

  void toggleNotifications(BuildContext context, String id) async {
    try {
      await _notificationTabRepository.toggleNotifications(id, {});
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
      notificationCount = notificationsList.length;
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }
}
