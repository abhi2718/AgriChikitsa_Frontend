import 'dart:async';

import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  var categoryLoading = true;

  Map<String, String> dropdownOptions = {};
  var imagePath = "";
  var imageUrl = "";
  var buttonloading = false;
  var caption = '';
  var category = '';

  void setfetchMyPost(bool val) {
    fetchMyPost = true;
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

  void fetchFeedsCategory(BuildContext context) async {
    try {
      final data = await HomeTabRepository().fetchFeedsCatogory();
      categoriesList = data['categories']
          .map((data) => CategoryHome(
                id: data['_id'],
                name: data['category'],
              ))
          .toList();
      categoryLoading = false;
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage(
          AppLocalizations.of(context)!.alerthi, error.toString(), context);
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
      categoryLoading = true;
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
      Utils.flushBarErrorMessage(
          AppLocalizations.of(context)!.alerthi, error.toString(), context);
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
        final data = await _homeTabViewModel.createPost(
            context, currentSelectedCategory, caption, imageUrl);
        setfetchMyPost(true);
        if (data) {
          await Future.delayed(const Duration(seconds: 1), () {
            goBack(context);
            setloading(false);
            Utils.flushBarErrorMessage(
                AppLocalizations.of(context)!.postCreatedhi,
                AppLocalizations.of(context)!.adminVerifyhi,
                context);
            reinitialize();
          });
        }
      } else {
        Utils.flushBarErrorMessage(AppLocalizations.of(context)!.alerthi,
            AppLocalizations.of(context)!.somethingWentWronghi, context);
      }
    } else {
      setloading(false);
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.alerthi,
          AppLocalizations.of(context)!.fillAllDetailshi, context);
    }
  }
}
