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
  bool bookMarkLoader = true;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setBookMarkLoader(bool value) {
    bookMarkLoader = value;
    notifyListeners();
  }

  void fetchFeeds(BuildContext context) async {
    setloading(true);
    try {
      final data = await _myProfileTabRepository.fetchFeeds();
      feedList = data['feeds'];
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void fetchTimeline(BuildContext context) async {
    setBookMarkLoader(true);
    try {
      final data = await _myProfileTabRepository.fetchTimeLine();
      bookMarkFeedList = data['timelineFeeds'];
      setBookMarkLoader(false);
      notifyListeners();
    } catch (error) {
      setBookMarkLoader(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void toggleLike(BuildContext context, String id) async {
    try {
      final data = await HomeTabRepository().toggleLike(id);
      int index = feedList.indexWhere((feed) => feed['_id'] == id);
      int indexBook = bookMarkFeedList.indexWhere((feed) => feed['_id'] == id);
      if (index != -1) {
        dynamic updatedFeed = {
          ...feedList[index],
          "likes": data["likes"],
        };
        dynamic updatedBookMarkList = {
          ...bookMarkFeedList[indexBook],
          "likes": data["likes"],
        };
        bookMarkFeedList.replaceRange(indexBook, indexBook + 1, [updatedFeed]);
        feedList.replaceRange(index, index + 1, [updatedFeed]);
      }
    } catch (error) {
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void toggleTimeline(BuildContext context, String id, User user) async {
    setBookMarkLoader(true);
    try {
      await HomeTabRepository().toggleTimeline(id);
      bookMarkFeedList.removeWhere((element) => element['_id'] == id);
      setBookMarkLoader(false);
      notifyListeners();
    } catch (error) {
      setBookMarkLoader(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }
}
