import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../repository/auth.repo/auth_repository.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';

class CreatePostModel with ChangeNotifier {
  final _authRepository = AuthRepository();
  final editUserformKey = GlobalKey<FormState>();
  final captionFocusNode = FocusNode();
  final categoryFocusNode = FocusNode();
  List<dynamic> categoriesList = [];
  String selectedKey = "";
  String selectedValue = "";

  Map<String, String> dropdownOptions = {};
  var imagePath = "";
  var _loading = false;
  var caption = '';
  var category = '';

  void updateSelectedOption(String key) {
    selectedKey = key;
    selectedValue = dropdownOptions[key]!;
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

      dropdownOptions = {
        for (final category in categoriesList) category.id: category.name!,
      };
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  String? nameFieldValidator(value) {
    if (value!.isEmpty) {
      return "Name is required!";
    }
    return null;
  }

  void onSavedCaptionField(value) {
    caption = value;
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
        // final response = await Utils.uploadImage(data);
        // final user = User.fromJson(authService.userInfo["user"]);
        // final userInfo = {"_id": user.sId, "profileImage": response["imgurl"]};
        // updateProfile(userInfo, context, authService);
        notifyListeners();
      }
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void createPost(
    BuildContext context,
  ) {
    HomeTabViewModel().createPost(context, selectedKey, caption, imagePath);
    Navigator.of(context).pop();
  }
}
