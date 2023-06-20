import 'package:agriChikitsa/model/user_model.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/repository/myprofile.repo/myprofile_tab_repository.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class MyProfileViewModel with ChangeNotifier {
  final _myProfileTabRepository = MyProfileTabRepository();
  dynamic feedList = [];
  List<dynamic> bookMarkFeedList = [];
  var commentLoading = true;
  var _loading = true;
  bool get loading {
    return _loading;
  }

  // setloading(bool value) {
  //   _loading = value;
  //   notifyListeners();
  // }
  void fetchFeeds(BuildContext context) async {
    // setloading(true);
    try {
      final data = await _myProfileTabRepository.fetchFeeds();
      feedList = data['feeds'];
      print(feedList);
      // setloading(false);
      notifyListeners();
    } catch (error) {
      // setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void fetchTimeline(BuildContext context) async {
    // setloading(true);
    try {
      final data = await _myProfileTabRepository.fetchTimeLine();
      bookMarkFeedList = data['timelineFeeds'];
      // setloading(false);
      notifyListeners();
    } catch (error) {
      // setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void toggleTimeline(BuildContext context, String id, User user) async {
    try {
      final data = await HomeTabRepository().toggleTimeline(id);
      user.timeline = data['timeLine'];
      notifyListeners();
    } catch (error) {
      // setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }
}
