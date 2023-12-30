import 'dart:convert';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/repository/auth.repo/auth_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/routes_name.dart';

class ProfileViewModel with ChangeNotifier {
  final authRepository = AuthRepository();
  bool deleteLoader = false;
  String deleteReason = '';
  var locale = {"language": 'hi', "country": "IN"};

  void getLocaleLanguage() async {
    final localStorage = await SharedPreferences.getInstance();
    final mapString = localStorage.getString('profile');
    if (mapString != null) {
      final profile = jsonDecode(mapString);
      locale = {
        "language": profile["language"]["language"],
        "country": profile["language"]["country"]
      };
      notifyListeners();
    }
  }

  Future<void> clearLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
  }

  void onSavedReasonField(value) {
    deleteReason = value;
  }

  void setDeleteLoader(value) {
    deleteLoader = value;
    notifyListeners();
  }

  void handleLocaleChange(BuildContext context, String selectedLocaleLanguage,
      String selectedLocaleCountry, String phoneNumber, String firebaseId) async {
    final localStorage = await SharedPreferences.getInstance();
    final mapString = localStorage.getString('profile');
    locale = {"language": selectedLocaleLanguage, "country": selectedLocaleCountry};
    notifyListeners();
    if (mapString != null) {
      Navigator.pop(context);
      final profile = jsonDecode(mapString);
      final updatedProfile = {
        ...profile,
        "language": {"language": locale["language"], "country": locale["country"]}
      };
      await localStorage.setString('profile', jsonEncode(updatedProfile));
    } else {
      Navigator.pop(context);
      Navigator.of(context).pushNamed(RouteName.signUpRoute, arguments: {
        "phoneNumber": phoneNumber,
        "uid": firebaseId,
      });
    }
  }

  void handleLogOut(BuildContext context, disposableProvider) {
    disposableProvider.forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
    clearLocalStorage().then((_) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouteName.authLandingRoute, (route) => false)
          .then((_) => setDeleteLoader(false));
    });
  }

  void goToEditProfileScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RouteName.editProfileRoute);
  }

  void openTermsAndConditions(BuildContext context) {
    try {
      final Uri toLaunch =
          Uri(scheme: 'https', host: 'agrichikitsa.org', path: '/termsAndCondition');
      Utils.launchInWebViewWithoutJavaScript(toLaunch);
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void openPrivacyPolicy(BuildContext context) {
    try {
      final Uri toLaunch = Uri(scheme: 'https', host: 'agrichikitsa.org', path: '/privicyPolicy');
      Utils.launchInWebViewWithoutJavaScript(toLaunch);
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  String? nameFieldValidator(BuildContext context, value) {
    if (value!.isEmpty || value.trim().isEmpty) {
      return AppLocalization.of(context).getTranslatedValue("deleteReasonRequired").toString();
    }
    return null;
  }

  void handleDelete(context, disposableProvider) async {
    setDeleteLoader(true);
    try {
      deleteReason = Uri.encodeComponent(deleteReason);
      await authRepository.deleteUser(deleteReason);
      handleLogOut(context, disposableProvider);
    } catch (error) {
      setDeleteLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }
}
