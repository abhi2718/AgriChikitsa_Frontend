import 'dart:convert';
import 'dart:io';
import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/repository/auth.repo/auth_repository.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/comment.dart';
import '../myprofile.screen/myprofile_view_model.dart';

Future<void> handleBackgorundMessage(RemoteMessage message) async {}

class HomeTabViewModel with ChangeNotifier {
  final _authTabRepo = AuthRepository();
  final _homeTabRepository = HomeTabRepository();

  final textEditingController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  dynamic feedList = [];
  List<CategoryHome> categoriesList = [];
  List<Comment> commentsList = [];
  String currentSelectedCategory = "All";
  var categoryLoading = true;
  var commentLoading = true;
  var _loading = true;
  bool weatherPDFloader = false;
  bool isNotificationInitialized = false;
  var toogleLikeBookMarkedFeed = {"isLiked": false, "id": ""};
  var toogleMyPostFeed = {"isLiked": false, "id": ""};
  var increaseCommentNumber = {'count': 0, "id": ""};
  List<String> expandedPosts = [];
  bool get loading {
    return _loading;
  }

  bool isExpanded(String id) {
    return expandedPosts.contains(id);
  }

  setWeatherPDFLoader(value) {
    weatherPDFloader = value;
    notifyListeners();
  }

  void toggleExpand(String id) {
    expandedPosts.add(id);
    notifyListeners();
  }

  void setIncreaseCommentNumber(int count, String id) {
    increaseCommentNumber = {'count': count, "id": id};
    notifyListeners();
  }

  void setUpdatedFeedList(int indexFeed, dynamic updatedFeed) {
    feedList.replaceRange(indexFeed, indexFeed + 1, [updatedFeed]);
  }

  void setToogleLikeBookMarkedFeed(bool flag, String id) {
    toogleLikeBookMarkedFeed = {"id": id, "isLiked": flag};
    notifyListeners();
  }

  void setToogleMyPostFeed(bool flag, String id) {
    toogleMyPostFeed = {"id": id, "isLiked": flag};
    notifyListeners();
  }

  void disposeValues() {
    feedList = [];
    categoriesList = [];
    commentsList = [];
    currentSelectedCategory = "All";
    expandedPosts.clear();
    categoryLoading = true;
    commentLoading = true;
    _loading = true;
    isNotificationInitialized = false;
    textEditingController.clear();
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
        if (!isNotificationInitialized) {
          FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
            notificationViewModel.fetchPushNotification();
          });
          FirebaseMessaging.onBackgroundMessage(handleBackgorundMessage);
          isNotificationInitialized = true;
        }
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

  void fetchFeeds(BuildContext context) async {
    setloading(true);
    try {
      expandedPosts = [];
      final data = await _homeTabRepository.fetchFeeds(currentSelectedCategory);
      feedList = data['feeds'];
      setloading(false);
      notifyListeners();
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void fetchFeedsCategory(BuildContext context) async {
    try {
      final data = await _homeTabRepository.fetchFeedsCatogory();
      categoriesList = [
        CategoryHome(
          name: "All",
          nameHi: "सभी",
          id: "All",
          isActive: false,
        ),
        ...mapCategories(data['categories'])
      ];
      categoryLoading = false;
      notifyListeners();
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  List<CategoryHome> mapCategories(dynamic categories) {
    return List<CategoryHome>.from(categories.map((category) {
      return CategoryHome(
        name: category['category'],
        nameHi: category['categoryInHindi'],
        id: category['_id'],
        isActive: false,
      );
    }));
  }

  void toggleLike(
      BuildContext context,
      String id,
      MyProfileViewModel myProfileViewModel,
      bool isLiked,
      String userId) async {
    try {
      int index = feedList.indexWhere((feed) => feed['_id'] == id);
      if (index != -1) {
        final feedItem = feedList[index];
        final oldLikes = feedItem['likes'];
        if (isLiked) {
          oldLikes.removeWhere((item) => item == userId);
        }
        dynamic updatedFeed = {
          ...feedItem,
          "likes": isLiked ? oldLikes : [...oldLikes, userId]
        };
        feedList.replaceRange(index, index + 1, [updatedFeed]);

        int indexMyPost =
            myProfileViewModel.feedList.indexWhere((feed) => feed['_id'] == id);
        if (indexMyPost != -1) {
          setToogleMyPostFeed(!isLiked, id);
          myProfileViewModel.feedList
              .replaceRange(indexMyPost, indexMyPost + 1, [updatedFeed]);
        }
        int indexMyBookMarked = myProfileViewModel.bookMarkFeedList
            .indexWhere((feed) => feed['_id'] == id);
        if (indexMyBookMarked != -1) {
          setToogleLikeBookMarkedFeed(!isLiked, id);
          myProfileViewModel.bookMarkFeedList.replaceRange(
              indexMyBookMarked, indexMyBookMarked + 1, [updatedFeed]);
        }
      }
      await _homeTabRepository.toggleLike(id);
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }

  void toggleTimeline(BuildContext context, String id, String userId,
      bool isbookmarked, MyProfileViewModel myProfileViewModel) async {
    try {
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
        if (!isbookmarked) {
          myProfileViewModel.setbookMarkFeedList(updatedFeed);
        } else {
          myProfileViewModel.setUnBookMarkedFeedList(id);
        }
      }
      await _homeTabRepository.toggleTimeline(id);
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
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
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
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
      final payload = caption == ""
          ? {"categoryId": id, "imgurl": imageUrl}
          : {"categoryId": id, "hindiCaption": caption, "imgurl": imageUrl};
      await _homeTabRepository.createPost(payload);
      return true;
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
      return false;
    }
  }

  void addComment(BuildContext context, String id, String comment, User user,
      MyProfileViewModel myProfileViewModel) async {
    if (comment.isNotEmpty) {
      final newComment =
          Comment(id: "newComment", user: user, comment: comment);
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
          final myPostIndex = myProfileViewModel.feedList
              .indexWhere((feed) => feed['_id'] == id);
          if (myPostIndex != -1) {
            setIncreaseCommentNumber(commentsList.length, id);
            myProfileViewModel.feedList
                .replaceRange(myPostIndex, myPostIndex + 1, [update]);
          }
          final myBookMarkedIndex = myProfileViewModel.bookMarkFeedList
              .indexWhere((feed) => feed['_id'] == id);
          if (myBookMarkedIndex != -1) {
            setIncreaseCommentNumber(commentsList.length, id);
            myProfileViewModel.bookMarkFeedList.replaceRange(
                myBookMarkedIndex, myBookMarkedIndex + 1, [update]);
          }
        }
        textEditingController.clear();
      } catch (error) {
        setloading(false);
        if (kDebugMode) {
          Utils.flushBarErrorMessage('Alert', error.toString(), context);
        }
      }
    }
  }

  Future<dynamic> openWeatherPDF(BuildContext context, String pdfUrl) async {
    setWeatherPDFLoader(true);
    try {
      final filename = pdfUrl.substring(pdfUrl.lastIndexOf("/") + 1);
      final uri = Uri.parse(pdfUrl);
      final res = await http.get(uri);
      final bytes = res.bodyBytes;
      final temp = await getApplicationDocumentsDirectory();
      final path = '${temp.path}/$filename';
      File(path).writeAsBytesSync(bytes, flush: true);
      setWeatherPDFLoader(false);
      return [path, filename];
    } catch (error) {
      setWeatherPDFLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalizations.of(context)!.alerthi, error.toString(), context);
      }
    }
  }
}
