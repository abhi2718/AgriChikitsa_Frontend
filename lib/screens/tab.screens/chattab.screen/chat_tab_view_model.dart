import 'package:flutter/material.dart';
import 'package:agriChikitsa/utils/utils.dart';
import '../../../repository/chat_tab.repo/chat_tab_repository.dart';

class ChatTabViewModel with ChangeNotifier {
  final _chatTabRepository = ChatTabRepository();
  var _loading = false;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void disposeValues() {
    _loading = false;
  }

  void fetchCategory() async {
    try {} catch (e) {}
  }
}
