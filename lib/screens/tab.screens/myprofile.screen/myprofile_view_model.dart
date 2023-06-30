import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/repository/myprofile.repo/myprofile_tab_repository.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class MyProfileViewModel with ChangeNotifier {
  final _myProfileTabRepository = MyProfileTabRepository();
  List<dynamic> feedList = [];
  List<dynamic> bookMarkFeedList = [];
  var commentLoading = true;
  var _loading = false;
  bool bookMarkLoader = false;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
  }

  void disposeValues() {
    feedList = [];
    bookMarkFeedList = [];
    commentLoading = true;
    _loading = false;
    bookMarkLoader = false;
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
    try {
      final data = await _myProfileTabRepository.fetchTimeLine();
      bookMarkFeedList = data['timelineFeeds'];
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void toggleLike(
      BuildContext context, String id, bool isLiked, String userId) async {
    try {
      await HomeTabRepository().toggleLike(id);
      int indexFeed = feedList.indexWhere((feed) => feed['_id'] == id);
      int indexBook = bookMarkFeedList.indexWhere((feed) => feed['_id'] == id);
      if (indexFeed != -1) {
        final feedItem = feedList[indexFeed];
        final oldLikes = feedItem['likes'];
        if (isLiked) {
          oldLikes.removeWhere((item) => item == userId);
        }
        dynamic updatedFeed = {
          ...feedItem,
          "likes": isLiked ? oldLikes : [...oldLikes, userId]
        };
        feedList.replaceRange(indexFeed, indexFeed + 1, [updatedFeed]);
        if (indexBook != -1) {
          bookMarkFeedList
              .replaceRange(indexBook, indexBook + 1, [updatedFeed]);
        }
      }
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void toggleTimeline(BuildContext context, String id, String userId) async {
    setBookMarkLoader(true);
    try {
      await HomeTabRepository().toggleTimeline(id);
      bookMarkFeedList.removeWhere((element) => element["_id"] == id);
      setBookMarkLoader(false);
      notifyListeners();
    } catch (error) {
      setBookMarkLoader(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }
}
