import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  dynamic userInfo;

  void setUser(dynamic user) {
    userInfo = user;
    notifyListeners();
  }

  void disposeValues() {
    userInfo = null;
  }
}
