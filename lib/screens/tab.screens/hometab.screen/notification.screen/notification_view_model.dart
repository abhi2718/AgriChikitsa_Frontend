import 'package:agriChikitsa/repository/notification.repo/notification_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationViewModel extends ChangeNotifier {
  final _notificationTabRepo = NotificationTabRepo();
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token:$fCMToken');
  }

  var _loading = true;

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get loading {
    return _loading;
  }

  void disposeValues() {
    _loading = true;
  }

  void fetchFeedsCategory(BuildContext context) async {
    try {
      final data = await _notificationTabRepo.fetchNotification();
      print(data);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }
}
