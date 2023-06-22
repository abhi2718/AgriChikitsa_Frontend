import 'dart:async';

import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:flutter/material.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';

class CreatePostModel with ChangeNotifier {
  final _homeTabViewModel = HomeTabViewModel();
  var captionController = TextEditingController();
  final captionFocusNode = FocusNode();
  final categoryFocusNode = FocusNode();
  List<dynamic> categoriesList = [];
  String currentSelectedCategory = "";
  var categoryLoading = true;

  Map<String, String> dropdownOptions = {};
  var imagePath = "";
  var imageUrl = "";
  var buttonloading = false;
  var caption = '';
  var category = '';

  setActiveState(BuildContext context, Category category, bool value) {
    currentSelectedCategory = category.id;
    notifyListeners();
  }

  setloading(bool value) {
    buttonloading = value;
    notifyListeners();
  }

  void fetchFeedsCategory(BuildContext context) async {
    try {
      final data = await HomeTabRepository().fetchFeedsCatogory();
      categoriesList = data['categories']
          .map((data) => Category(
                id: data['_id'],
                name: data['category'],
              ))
          .toList();
      categoryLoading = false;
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  String? nameFieldValidator(caption) {
    if (caption.isEmpty) {
      return "Caption is required!";
    } else {
      return null;
    }
  }

  void reinitialize() {
    Timer(const Duration(milliseconds: 500), () {
      captionController.clear();
      imagePath = "";
      imageUrl = "";
      caption = "";
      currentSelectedCategory = "";
    });
  }

  void onSavedCaptionField(value) {
    caption = value;
  }

  void handleUserInput(BuildContext context) {
    final value = captionController.text;
    if (value.isNotEmpty) {
      caption = captionController.text;
    }
  }

  void onSavedCategoryField(value) {
    category = value.toString();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void clearImagePath() {
    imagePath = "";
    notifyListeners();
  }

  void pickPostImage(context, AuthService authService) async {
    try {
      final data = await Utils.pickImage();
      if (data != null) {
        imagePath = data.path;
        var response = Utils.uploadImage(data);
        response.then((value) => imageUrl = value['imgurl']);
        notifyListeners();
      }
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void createPost(
    BuildContext context,
  ) async {
    if (currentSelectedCategory.isNotEmpty &&
        caption.isNotEmpty &&
        imagePath.isNotEmpty) {
      setloading(true);
      FocusManager.instance.primaryFocus?.unfocus();
      final data = await _homeTabViewModel.createPost(
          context, currentSelectedCategory, caption, imageUrl);
      if (data) {
        await Future.delayed(const Duration(seconds: 1), () {
          goBack(context);
          setloading(false);
          Utils.flushBarErrorMessage(
              "Post Created!",
              "Your post has been created. Admin will approve in soon.",
              context);
          reinitialize();
        });
      }
    } else {
      setloading(false);
      Utils.flushBarErrorMessage("Snap!", "Please enter all details", context);
    }
  }
}
