import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../repository/auth.repo/auth_repository.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/utils.dart';

class SignUpViewModel with ChangeNotifier {
  final _authRepository = AuthRepository();
  final registerUserformKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  var _loading = false;
  var userName = '';
  var email = '';
  var mobileNumber = '';
  var firebaseId = '';
  dynamic userProfile;

  bool get loading {
    return _loading;
  }

  void setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    mobileNumber = phoneNumber;
  }

  void setFirebaseId(String uid) {
    firebaseId = uid;
  }

  void setUserProfile(user) {
    userProfile = user;
    notifyListeners();
  }

  void setUserInfo(String name, String companyId) {
    userName = name;
    notifyListeners();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void saveRegisterUserForm(BuildContext context) {
    final isValid = registerUserformKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    registerUserformKey.currentState?.save();

    final userInfo = email.isEmpty
        ? {
            "roles": "User",
            "name": userName,
            "phoneNumber": mobileNumber,
            "firebaseId": firebaseId
          }
        : {
            "roles": "User",
            "name": userName,
            "email": email,
            "phoneNumber": mobileNumber,
            "firebaseId": firebaseId
          };
    FocusManager.instance.primaryFocus!.unfocus();
    register(userInfo, context);
  }

  Widget suffixIconForName() {
    return const Icon(Icons.person);
  }

  String? nameFieldValidator(BuildContext context, value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.validateNamehi;
    }
    return null;
  }

  void onSavedNameField(value) {
    userName = value;
  }

  Widget suffixIconForEmail() {
    return const Icon(Icons.email);
  }

  bool validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  String? emailFieldValidator(BuildContext context, value) {
    if (value != null && value.isNotEmpty) {
      bool isValid = validateEmail(value);
      if (!isValid) {
        return AppLocalizations.of(context)!.validateEmailhi;
      }
    }
    return null;
  }

  void onSavedEmailField(value) {
    email = value;
  }

  void onSavedMobileNumerField(value) {
    mobileNumber = value;
  }

  void register(dynamic payload, BuildContext context) {
    final localContext = context;
    setloading(true);
    void handleRegister(context) async {
      try {
        final data = await _authRepository.register(payload);
        final localStorage = await SharedPreferences.getInstance();
        final profile = {
          'user': data["newUser"],
          'token': data["token"],
        };
        await localStorage.setString("profile", jsonEncode(profile));
        setUserProfile(data);
        setloading(false);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteName.homeRoute, (route) => false);
        disposeValues();
      } catch (error) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
        setloading(false);
      }
    }

    handleRegister(localContext);
  }

  void disposeRegisterUserformKey() {
    registerUserformKey.currentState?.dispose();
  }

  void disposeValues() {
    _loading = false;
    userName = '';
    email = '';
    mobileNumber = '';
    userProfile = null;
    registerUserformKey.currentState?.dispose();
  }
}
