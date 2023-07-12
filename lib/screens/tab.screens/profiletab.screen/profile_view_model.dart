import 'package:agriChikitsa/repository/auth.repo/auth_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/routes_name.dart';

class ProfileViewModel with ChangeNotifier {
  final authRepository = AuthRepository();
  bool deleteLoader = false;
  var locale = {"language": 'en', "country": "US"};
  Future<void> clearLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
  }

  void setDeleteLoader(value) {
    deleteLoader = value;
    notifyListeners();
  }

  void handleLocaleChange() {
    locale = {
      "language": locale["language"] == "en" ? "hi" : "en",
      "country": locale["country"] == "US" ? "IN" : "US"
    };
    notifyListeners();
  }

  void handleLogOut(BuildContext context, disposableProvider) {
    disposableProvider.forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
    clearLocalStorage().then((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.authLandingRoute, (route) => false);
    });
  }

  void goToEditProfileScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RouteName.editProfileRoute);
  }

  void openTermsAndConditions(BuildContext context) {
    try {
      final Uri toLaunch = Uri(
          scheme: 'https',
          host: 'agrichikitsa.org',
          path: '/termsAndCondition');
      Utils.launchInWebViewWithoutJavaScript(toLaunch);
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void openPrivacyPolicy(BuildContext context) {
    try {
      final Uri toLaunch = Uri(
          scheme: 'https', host: 'agrichikitsa.org', path: '/privicyPolicy');
      Utils.launchInWebViewWithoutJavaScript(toLaunch);
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void handleDelete(context, disposableProvider) async {
    setDeleteLoader(true);
    try {
      await authRepository.deleteUser();
      handleLogOut(context, disposableProvider);
      setDeleteLoader(false);
    } catch (error) {
      setDeleteLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }
}
