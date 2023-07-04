import 'dart:convert';

import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/user_model.dart';
import '../../../../repository/auth.repo/auth_repository.dart';
import '../../../../services/auth.dart';

class EditProfileViewModel with ChangeNotifier {
  final _authRepository = AuthRepository();
  final editUserformKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  var _loading = false;
  var userName = '';
  var email = '';
  var imageLoading = false;

  bool get loading {
    return _loading;
  }

  void setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setImageLoading(bool value) {
    imageLoading = value;
    notifyListeners();
  }

  void setName(String value) {
    userName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Name TextField
  Widget suffixIconForName() {
    return const Icon(Icons.person);
  }

  String? nameFieldValidator(BuildContext context, value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.nameReuiredhi;
    }
    return null;
  }

  void onSavedNameField(value) {
    userName = value;
  }

  // Email TextField
  Widget suffixIconForEmail() {
    return const Icon(Icons.email);
  }

  bool validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  String? emailFieldValidator(BuildContext context, String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.emailRequiredhi;
    }
    bool isValid = validateEmail(value);
    if (!isValid) {
      return AppLocalizations.of(context)!.emailRequiredhi;
    }
    return null;
  }

  void onSavedEmailField(value) {
    email = value;
  }

  void saveForm(BuildContext context, User user, AuthService authService) {
    // final isValid = editUserformKey.currentState?.validate();
    // if (!isValid!) {
    //   return;
    // }
    // editUserformKey.currentState?.save();
    final userInfo = {
      "name": userName,
      "email": email.isEmpty ? "" : email,
      "_id": user.sId
    };
    updateProfile(userInfo, context, authService);
  }

  void updateProfile(userInfo, context, AuthService authService) async {
    try {
      setloading(true);
      final data =
          await _authRepository.updateProfile(userInfo["_id"], userInfo);
      final localStorage = await SharedPreferences.getInstance();
      final profile = {
        'user': data["user"],
        'token': data["token"],
      };
      await localStorage.setString("profile", jsonEncode(profile));
      setloading(false);
      if (imageLoading) {
        setImageLoading(false);
      }
      authService.setUser(profile);
      Utils.toastMessage(
          AppLocalizations.of(context)!.profileUpdateSuccesfulhi);
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage(
          AppLocalizations.of(context)!.alerthi, error.toString(), context);
    }
  }

  void pickProfileImage(context, AuthService authService) async {
    try {
      final data = await Utils.pickImage();
      if (data != null) {
        setImageLoading(true);
        final response = await Utils.uploadImage(data);
        final user = User.fromJson(authService.userInfo["user"]);
        final userInfo = {"_id": user.sId, "profileImage": response["imgurl"]};
        updateProfile(userInfo, context, authService);
      }
    } catch (error) {
      setImageLoading(false);
      Utils.flushBarErrorMessage(
          AppLocalizations.of(context)!.alerthi, error.toString(), context);
    }
  }

  void captureProfileImage(context, AuthService authService) async {
    try {
      final data = await Utils.capturePhoto();
      if (data != null) {
        setImageLoading(true);
        final response = await Utils.uploadImage(data);
        final user = User.fromJson(authService.userInfo["user"]);
        final userInfo = {"_id": user.sId, "profileImage": response["imgurl"]};
        updateProfile(userInfo, context, authService);
      }
    } catch (error) {
      setImageLoading(false);
      Utils.flushBarErrorMessage(
          AppLocalizations.of(context)!.alerthi, error.toString(), context);
    }
  }

  void disposeValues() {
    editUserformKey.currentState?.dispose();
    _loading = false;
    userName = '';
    email = '';
  }
}
