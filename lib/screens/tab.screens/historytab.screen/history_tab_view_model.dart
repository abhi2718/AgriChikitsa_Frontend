import 'package:flutter/material.dart';
import 'package:agriChikitsa/utils/utils.dart';
import '../../../repository/history_tab.repo/history_tab_repository.dart';

class HistoryTabViewModel with ChangeNotifier {
  final _historyTabRepository = HistoryTabRepository();
  var _loading = false;
  var taskHistory = [];
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void fetchTaskHistory(BuildContext context) async {
    try {
      setloading(true);
      final data = await _historyTabRepository.fetchTaskHistory();
      taskHistory = data;
      setloading(false);
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
      setloading(false);
    }
  }

  void disposeValues() {
    _loading = false;
    taskHistory = [];
  }
}
