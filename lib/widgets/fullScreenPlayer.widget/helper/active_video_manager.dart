import 'package:flutter/foundation.dart';

class ActiveVideoManager extends ChangeNotifier {
  ActiveVideoManager._();
  static final ActiveVideoManager instance = ActiveVideoManager._();

  String? _activeKey;
  String? get activeKey => _activeKey;

  void setActive(String key) {
    if (_activeKey != key) {
      _activeKey = key;
      notifyListeners();
    }
  }

  void clearIfActive(String key) {
    if (_activeKey == key) {
      _activeKey = null;
      notifyListeners();
    }
  }

  void clearAll() {
    _activeKey = null;
    notifyListeners();
  }
}
