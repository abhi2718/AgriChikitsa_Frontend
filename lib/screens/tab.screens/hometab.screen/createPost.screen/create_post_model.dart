import 'package:flutter/material.dart';

import '../../../../repository/auth.repo/auth_repository.dart';
import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';

class CreatePostModel with ChangeNotifier {
  final _authRepository = AuthRepository();
  final editUserformKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  var imagePath = "";
  var _loading = false;
  var userName = '';
  var email = '';

  String? nameFieldValidator(value) {
    if (value!.isEmpty) {
      return "Name is required!";
    }
    return null;
  }

  void onSavedNameField(value) {
    userName = value;
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
}
