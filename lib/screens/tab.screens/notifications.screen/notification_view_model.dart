import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/repository/notification.repo/notification_tab_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class NotificationViewModel with ChangeNotifier {
  final _notificationTabRepository = NotificationTabRepository();
  List<dynamic> notificationsList = [];
  dynamic chatHistoryList = [];
  bool chatLoader = false;
  var notificationCount = 0;
  
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = true;
  var _loading = false;
  bool _isFetchingMore = false;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasNextPage => _hasNextPage;
  bool get loading => _loading;
  bool get isFetchingMore => _isFetchingMore;

  void setChatLoader(bool value) {
    chatLoader = value;
    notifyListeners();
  }

  void setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setIsFetchingMore(bool value) {
    _isFetchingMore = value;
    notifyListeners();
  }

  void openLink(BuildContext context, String scheme, String host, String path) {
    try {
      final Uri toLaunch = Uri(scheme: scheme, host: host, path: '/$path');
      Utils.launchInWebViewWithoutJavaScript(toLaunch);
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void toggleNotifications(BuildContext context, String id, bool readStatus) async {
    try {
      if (!readStatus) {
        await _notificationTabRepository.toggleNotifications(id, {});
        if (notificationCount > 0) {
          notificationCount--;
        }
        final index = notificationsList.indexWhere((element) => element['_id'] == id);
        if (index != -1) {
          final oldItem = notificationsList[index];
          dynamic updatedNotificationItem = {
            ...oldItem,
            "read": true,
          };
          notificationsList.replaceRange(index, index + 1, [updatedNotificationItem]);
        }
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void fetchPushNotification() async {
    try {
      final data = await _notificationTabRepository.fetchNotifications(page: 1, limit: 20);
      final notificationsData = data['data'] != null ? data['data']['notifications'] : data['notifications'];
      notificationsList = List<dynamic>.from((notificationsData as List<dynamic>?) ?? []);
      notificationCount = (data['data'] != null ? data['data']['unreadCount'] : data['unReadNotificationsCount']) ?? 0;
      if (data['data'] != null && data['data']['pagination'] != null) {
        _currentPage = data['data']['pagination']['page'] ?? 1;
        _totalPages = data['data']['pagination']['totalPages'] ?? 1;
        _hasNextPage = data['data']['pagination']['hasNextPage'] ?? true;
      } else {
        _currentPage = 1;
        _hasNextPage = notificationsList.length >= 20;
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        Utils.toastMessage(error.toString());
      }
    }
  }

  Future<void> fetchNotifications(BuildContext? context, {bool isRefresh = false}) async {
    if (!isRefresh && notificationsList.isEmpty) {
      setloading(true);
    }
    _currentPage = 1;
    _hasNextPage = true;
    try {
      final data = await _notificationTabRepository.fetchNotifications(page: 1, limit: 20);
      final notificationsData = data['data'] != null ? data['data']['notifications'] : data['notifications'];
      notificationsList = List<dynamic>.from((notificationsData as List<dynamic>?) ?? []);
      notificationCount = (data['data'] != null ? data['data']['unreadCount'] : data['unReadNotificationsCount']) ?? 0;
      if (data['data'] != null && data['data']['pagination'] != null) {
        _currentPage = data['data']['pagination']['page'] ?? 1;
        _totalPages = data['data']['pagination']['totalPages'] ?? 1;
        _hasNextPage = data['data']['pagination']['hasNextPage'] ?? false;
      } else {
        _currentPage = 1;
        _hasNextPage = notificationsList.length >= 20;
      }
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      if (kDebugMode && context != null) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  Future<void> fetchMoreNotifications(BuildContext? context) async {
    if (_isFetchingMore || !_hasNextPage || _loading) {
      return;
    }
    setIsFetchingMore(true);
    final nextPage = _currentPage + 1;
    try {
      final data = await _notificationTabRepository.fetchNotifications(page: nextPage, limit: 20);
      final notificationsData = data['data'] != null ? data['data']['notifications'] : data['notifications'];
      final List<dynamic> newNotifications = (notificationsData as List<dynamic>?) ?? [];
      
      if (newNotifications.isNotEmpty) {
        final existingIds = notificationsList.map((e) => e['_id']?.toString()).toSet();
        final uniqueItems = newNotifications.where((item) => !existingIds.contains(item['_id']?.toString())).toList();
        notificationsList.addAll(uniqueItems);
        _currentPage = nextPage;
        if (data['data'] != null && data['data']['pagination'] != null) {
          _totalPages = data['data']['pagination']['totalPages'] ?? _totalPages;
          _hasNextPage = data['data']['pagination']['hasNextPage'] ?? (_currentPage < _totalPages);
        } else {
          _hasNextPage = newNotifications.length >= 20;
        }
      } else {
        _hasNextPage = false;
      }
      setIsFetchingMore(false);
    } catch (error) {
      setIsFetchingMore(false);
      if (kDebugMode && context != null) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void fetchChatHistory(BuildContext context, String id) async {
    setChatLoader(true);
    try {
      final data = await NotificationTabRepository().fetchChatScript(id);
      chatHistoryList = data;
      setChatLoader(false);
      notifyListeners();
    } catch (error) {
      setChatLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }
}
