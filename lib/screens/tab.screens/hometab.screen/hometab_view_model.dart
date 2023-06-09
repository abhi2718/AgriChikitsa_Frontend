import 'dart:convert';

import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/category_model.dart';

class HomeTabViewModel with ChangeNotifier {
  dynamic feedList = [];
  List<Category> categoriesList = [];
  String currentSelectedCategory = "";
  var categoryList = [
    {"name": "All", "_id": "All"}
  ];
  final _homeTabRepository = HomeTabRepository();
  var _loading = true;
  bool get loading {
    return _loading;
  }

  setActiveState(Category category, bool value) {
    category.isActive = !value;
    for (var value in categoriesList) {
      if (value.id == category.id) {
        if (value.isActive) {
          currentSelectedCategory = value.id.toString();
        } else {
          currentSelectedCategory = "";
        }
      } else {
        value.isActive = false;
      }
    }
    notifyListeners();
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

  void fetchFeeds(BuildContext context) async {
    setloading(true);
    try {
      final data = await _homeTabRepository.fetchFeeds();
      feedList = data['feeds'];
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void fetchFeedsCategory(BuildContext context) async {
    setloading(true);
    try {
      final data = await _homeTabRepository.fetchFeedsCatogory();
      categoriesList = mapCategories(data['categories']);
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  List<Category> mapCategories(dynamic categories) {
    return List<Category>.from(categories.map((category) {
      return Category(
        name: category['category'],
        id: category['_id'],
        isActive: false,
      );
    }));
  }
}
