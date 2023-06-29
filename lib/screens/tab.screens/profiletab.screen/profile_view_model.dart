import 'package:flutter/material.dart';
import 'package:agriChikitsa/repository/auth.repo/auth_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/routes_name.dart';

class ProfileViewModel with ChangeNotifier {
  final authRepository = AuthRepository();
  var locale = {"language": 'en', "country": "US"};
  Future<void> clearLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
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
      final Uri toLaunch =
          Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
      Utils.launchInWebViewWithoutJavaScript(toLaunch);
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void openPrivacyPolicy(BuildContext context) {
    try {
      final Uri toLaunch =
          Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
      Utils.launchInWebViewWithoutJavaScript(toLaunch);
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void handleDelete(context, disposableProvider) async {
    try {
      await authRepository.deleteUser();
      handleLogOut(context, disposableProvider);
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }
}
