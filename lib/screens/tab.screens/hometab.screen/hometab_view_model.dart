import 'dart:convert';
import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/repository/auth.repo/auth_repository.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/comment.dart';

Future<void> handleBackgorundMessage(RemoteMessage message) async {}

class HomeTabViewModel with ChangeNotifier {
  final _authTabRepo = AuthRepository();
  final _homeTabRepository = HomeTabRepository();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  dynamic feedList = [];
  List<CategoryHome> categoriesList = [];
  List<Comment> commentsList = [];
  String currentSelectedCategory = "All";
  var categoryLoading = true;
  var commentLoading = true;
  var _loading = true;

  bool get loading {
    return _loading;
  }

  setActiveState(BuildContext context, CategoryHome category, bool value) {
    currentSelectedCategory = category.id;
    notifyListeners();
    fetchFeeds(context);
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateProfile(String fcmToken) async {
    final localStorage = await SharedPreferences.getInstance();
    final rawProfile = localStorage.getString('profile');
    final profile = jsonDecode(rawProfile!);
    var userId = profile['user']['_id'];
    dynamic payload = {
      "fcmToken": fcmToken,
    };
    await _authTabRepo.updateProfile(userId, payload);
  }

  Future<void> getFCM(NotificationViewModel notificationViewModel) async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((fcmToken) {
      if (kDebugMode) {
        print(fcmToken);
      }
      if (fcmToken != null) {
        updateProfile(fcmToken);
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          notificationViewModel.fetchPushNotification();
        });
        FirebaseMessaging.onBackgroundMessage(handleBackgorundMessage);
      }
    });
  }

  void getUserProfile(AuthService authService) async {
    final localStorage = await SharedPreferences.getInstance();
    final rawProfile = localStorage.getString('profile');
    final profile = jsonDecode(rawProfile!);
    authService.setUser(profile);
  }

  void goToProfile(BuildContext context) {
    Navigator.pushNamed(context, RouteName.editProfileRoute);
  }

  void disposeValues() {
    _loading = true;
  }

  void fetchFeeds(BuildContext context) async {
    setloading(true);
    try {
      final data = await _homeTabRepository.fetchFeeds(currentSelectedCategory);
      feedList = data['feeds'];
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void fetchFeedsCategory(BuildContext context) async {
    try {
      final data = await _homeTabRepository.fetchFeedsCatogory();
      categoriesList = [
        CategoryHome(
          name: "All",
          id: "All",
          isActive: false,
        ),
        ...mapCategories(data['categories'])
      ];
      categoryLoading = false;
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  List<CategoryHome> mapCategories(dynamic categories) {
    return List<CategoryHome>.from(categories.map((category) {
      return CategoryHome(
        name: category['category'],
        id: category['_id'],
        isActive: false,
      );
    }));
  }

  void toggleLike(BuildContext context, String id) async {
    try {
      final data = await _homeTabRepository.toggleLike(id);
      int index = feedList.indexWhere((feed) => feed['_id'] == id);
      if (index != -1) {
        dynamic updatedFeed = {
          ...feedList[index],
          "likes": data["likes"],
        };
        feedList.replaceRange(index, index + 1, [updatedFeed]);
      }
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void toggleTimeline(
    BuildContext context,
    String id,
    String userId,
    bool isbookmarked,
  ) async {
    try {
      await _homeTabRepository.toggleTimeline(id);
      int index = feedList.indexWhere((feed) => feed['_id'] == id);
      if (index != -1) {
        final feedItem = feedList[index];
        final oldBookmarks = feedItem['bookmarks'];
        if (isbookmarked) {
          oldBookmarks.removeWhere((item) => item == userId);
        }
        dynamic updatedFeed = {
          ...feedItem,
          "bookmarks": isbookmarked ? oldBookmarks : [...oldBookmarks, userId]
        };
        feedList.replaceRange(index, index + 1, [updatedFeed]);
      }
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void fetchComments(BuildContext context, String id) async {
    commentLoading = true;
    notifyListeners();
    try {
      final data = await _homeTabRepository.fetchComments(id);
      commentLoading = false;
      commentsList = mapComments(data["comments"]);
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  List<Comment> mapComments(dynamic comments) {
    return List<Comment>.from(comments.map((comment) {
      return Comment.fromJson(comment);
    }));
  }

  Future<bool> createPost(
      BuildContext context, String id, String caption, String imageUrl) async {
    try {
      final payload = {
        "categoryId": id,
        "caption": caption,
        "imgurl": imageUrl
      };
      await _homeTabRepository.createPost(payload);
      return true;
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
      return false;
    }
  }

  void addComment(
      BuildContext context, String id, String comment, User user) async {
    final newComment = Comment(id: "newComment", user: user, comment: comment);
    commentsList = [...commentsList, newComment];
    notifyListeners();
    try {
      final payload = {"comment": comment};
      final data = await _homeTabRepository.addComments(id, payload);
      int index = feedList.indexWhere((feed) => feed['_id'] == id);
      if (index != -1) {
        final updatedFeed = data["updatedFeed"];
        dynamic update = {
          ...feedList[index],
          "comments": updatedFeed["comments"],
        };
        feedList.replaceRange(index, index + 1, [update]);
      }
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void goToCreatePostScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RouteName.createPostRoute);
  }
}
