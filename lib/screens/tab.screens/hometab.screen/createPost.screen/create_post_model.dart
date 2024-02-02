import 'dart:async';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/category_model.dart';
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
  var fetchMyPost = false;
  dynamic imagePicked;
  String currentSelectedCategory = "";
  // var categoryLoading = true;

  Map<String, String> dropdownOptions = {};
  var imagePath = "";
  var imageUrl = "";
  var buttonloading = false;
  var caption = '';
  var category = '';

  void setfetchMyPost(bool val) {
    fetchMyPost = val;
    notifyListeners();
  }

  setActiveState(BuildContext context, CategoryHome category, bool value) {
    currentSelectedCategory = category.id;
    notifyListeners();
  }

  setloading(bool value) {
    buttonloading = value;
    notifyListeners();
  }

  void fetchFeedsCategory(BuildContext context, HomeTabViewModel homeTabViewModel) async {
    try {
      categoriesList = List.from(homeTabViewModel.categoriesList);
      categoriesList.removeWhere((item) => item.name == "All");
    } catch (error) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }

  void reinitialize() {
    Timer(const Duration(milliseconds: 500), () {
      captionController.clear();
      imagePath = "";
      imageUrl = "";
      caption = "";
      currentSelectedCategory = "";
      buttonloading = false;
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
    reinitialize();
    Navigator.pop(context);
  }

  void clearImagePath() {
    imagePath = "";
    notifyListeners();
  }

  void pickPostImage(context, AuthService authService) async {
    try {
      imagePicked = await Utils.pickImage();
      if (imagePicked != null) {
        imagePath = imagePicked.path;
        notifyListeners();
      }
    } catch (error) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }

  void createPost(
    BuildContext context,
  ) async {
    if (currentSelectedCategory.isNotEmpty && imagePath.isNotEmpty) {
      setloading(true);
      FocusManager.instance.primaryFocus?.unfocus();
      var response = await Utils.uploadImage(imagePicked);
      if (response['success']) {
        imageUrl = response['imgurl'];
        final data =
            await _homeTabViewModel.createPost(context, currentSelectedCategory, caption, imageUrl);
        setfetchMyPost(true);
        if (data) {
          await Future.delayed(const Duration(seconds: 1), () {
            goBack(context);
            setloading(false);
            Utils.flushBarErrorMessage(
                AppLocalization.of(context).getTranslatedValue("postCreatedTitle").toString(),
                AppLocalization.of(context).getTranslatedValue("postCreatedSubtitle").toString(),
                context);
            reinitialize();
          });
        }
      } else {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
            AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString(),
            context);
      }
    } else {
      setloading(false);
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue("fillAllDetails").toString(), context);
    }
  }
}
