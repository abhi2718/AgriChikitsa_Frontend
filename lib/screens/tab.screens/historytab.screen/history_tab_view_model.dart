import 'package:flutter/material.dart';
import 'package:agriChikitsa/utils/utils.dart';
import '../../../repository/history_tab.repo/history_tab_repository.dart';

class HistoryTabViewModel with ChangeNotifier {
  final _historyTabRepository = HistoryTabRepository();
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

  void fetchCategory() async{
    try {

    } catch (e) {

    }
  }
}
