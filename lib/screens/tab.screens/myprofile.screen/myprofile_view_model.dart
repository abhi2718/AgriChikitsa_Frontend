import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/repository/myprofile.repo/myprofile_tab_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../hometab.screen/hometab_view_model.dart';

class MyProfileViewModel with ChangeNotifier {
  final _myProfileTabRepository = MyProfileTabRepository();
  List<dynamic> feedList = [];
  List<dynamic> bookMarkFeedList = [];
  var commentLoading = true;
  var _loading = false;
  bool bookMarkLoader = false;
  var unBookMarkedFeedData = {"unBookMarked": false, "id": ""};
  var isUserSwitchTheTab = false;
  var toogleHomeFeed = {"isLiked": false, "id": ""};
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
  }

  void setToogleHomeFeed(bool flag, String id) {
    toogleHomeFeed = {"id": id, "isLiked": flag};
    notifyListeners();
  }

  void setActiveTabIndex(bool value) {
    isUserSwitchTheTab = value;
    notifyListeners();
  }

  void setRemoveFeedFromHome(bool flag, String id) {
    unBookMarkedFeedData = {"id": id, "unBookMarked": flag};
    notifyListeners();
  }

  void setbookMarkFeedList(dynamic bookMark) {
    bookMarkFeedList.add(bookMark);
    notifyListeners();
  }

  void setUnBookMarkedFeedList(String id) {
    bookMarkFeedList.removeWhere((element) => element["_id"] == id);
    notifyListeners();
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

  void toggleLike(BuildContext context, String id, bool isLiked, String userId,
      HomeTabViewModel homeTabViewModel) async {
    try {
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
        int indexHomeFeed =
            homeTabViewModel.feedList.indexWhere((feed) => feed['_id'] == id);
        if (indexHomeFeed != -1) {
          setToogleHomeFeed(!isLiked, id);
          homeTabViewModel.setUpdatedFeedList(indexHomeFeed, updatedFeed);
        }
      }
      notifyListeners();
      await HomeTabRepository().toggleLike(id);
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage('Alert', error.toString(), context);
      }
    }
  }

  void toggleTimeline(BuildContext context, String id, String userId,
      HomeTabViewModel homeTabViewModel) async {
    try {
      bookMarkFeedList.removeWhere((element) => element["_id"] == id);
      notifyListeners();
      int indexFeed =
          homeTabViewModel.feedList.indexWhere((feed) => feed['_id'] == id);
      if (indexFeed != -1) {
        setRemoveFeedFromHome(true, id);
        final feedItem = homeTabViewModel.feedList[indexFeed];
        final oldBookmarks = feedItem['bookmarks'];
        oldBookmarks.removeWhere((item) => item == userId);
        dynamic updatedFeed = {...feedItem, "bookmarks": oldBookmarks};
        homeTabViewModel.feedList
            .replaceRange(indexFeed, indexFeed + 1, [updatedFeed]);
      }
      await HomeTabRepository().toggleTimeline(id);
    } catch (error) {
      setBookMarkLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage('Alert', error.toString(), context);
      }
    }
  }
}
