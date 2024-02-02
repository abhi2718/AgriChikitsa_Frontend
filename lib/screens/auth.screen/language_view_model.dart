import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageViewModel extends ChangeNotifier {
  late String lang;
  bool langLoader = true;
  setLangLoader(value) {
    langLoader = value;
  }

  void disposeValues() {
    langLoader = true;
  }

  void getLocaleLanguage() async {
    setLangLoader(true);
    final localStorage = await SharedPreferences.getInstance();
    final mapString = localStorage.getString('profile');
    if (mapString != null) {
      final profile = jsonDecode(mapString);
      lang = profile["language"]["language"];
    } else {
      lang = "hi";
    }
    setLangLoader(false);
    notifyListeners();
  }

  void unconfirmLocaleChange(String selectedLang) {
    if (selectedLang == lang) {
      return;
    } else {
      lang = selectedLang == "en" ? "en" : "hi";
      notifyListeners();
    }
  }
}
