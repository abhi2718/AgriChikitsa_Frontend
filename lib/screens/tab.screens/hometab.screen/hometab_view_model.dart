import 'dart:convert';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTabViewModel with ChangeNotifier {
  final _homeTabRepository = HomeTabRepository();
  var _loading = true;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void getUserProfile(AuthService authService) async {
    final localStorage = await SharedPreferences.getInstance();
    final rawProfile = localStorage.getString('profile');
    final profile = jsonDecode(rawProfile!);
    authService.setUser(profile);
  }

  void goToProfile(BuildContext context) {
    Navigator.pushNamed(context, RouteName.editProfileRoute);
  }

  void disposeValues() {
    _loading = true;
  }
}
