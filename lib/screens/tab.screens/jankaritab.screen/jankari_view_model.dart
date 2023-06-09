import 'package:agriChikitsa/repository/jankari.repo/jankari_repository.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';

class JankariViewModel with ChangeNotifier {
  dynamic jankaricatList = [];
  final _jankariRepository = JankariRepository();
  var _loading = true;
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

  void getJankariCategory(BuildContext context) async {
    setloading(true);
    try {
      final data = await _jankariRepository.getJankariCategory();
      jankaricatList = data['category'];
      print(data);
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }
}
