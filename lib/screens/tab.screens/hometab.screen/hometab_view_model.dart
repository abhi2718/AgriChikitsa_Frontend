import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/repository/auth.repo/auth_repository.dart';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool reportPostLoader = false;
  bool reportPostStatus = false;
  bool hasIncreasedViewForImage = false;
  bool repostLoader = false;
  bool get loading {
    return _loading;
  }

  bool isExpanded(String id) {
    return expandedPosts.contains(id);
  }

  String getTimeAgo(String dateString, BuildContext context) {
    DateTime createdAt = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    Duration difference = now.difference(createdAt);
    int daysDifference = difference.inDays;
    final bool isEnglish = AppLocalization.of(context).locale.toString() == 'en';
    if (daysDifference < 1) {
      int hoursDifference = difference.inHours;
      if (hoursDifference < 1) {
        int minutesDifference = difference.inMinutes;
        return '$minutesDifference ${isEnglish ? '${AppLocalization.of(context).getTranslatedValue('mintueFeed')}${minutesDifference == 1 ? '' : 's'}' : '${AppLocalization.of(context).getTranslatedValue('mintueFeed')}'}  ${AppLocalization.of(context).getTranslatedValue('agoFeed')}';
      } else {
        return '$hoursDifference ${isEnglish ? '${AppLocalization.of(context).getTranslatedValue('hourFeed')}${hoursDifference == 1 ? '' : 's'}' : '${AppLocalization.of(context).getTranslatedValue('hourFeed')}'}  ${AppLocalization.of(context).getTranslatedValue('agoFeed')}';
      }
    } else if (daysDifference < 31) {
      return '$daysDifference ${isEnglish ? '${AppLocalization.of(context).getTranslatedValue('daysFeed')}${daysDifference == 1 ? '' : 's'}' : '${AppLocalization.of(context).getTranslatedValue('daysFeed')}'}  ${AppLocalization.of(context).getTranslatedValue('agoFeed')}';
    } else {
      int monthsDifference = (daysDifference / 30).floor();
      return '$monthsDifference ${isEnglish ? '${AppLocalization.of(context).getTranslatedValue('monthsFeed')}${monthsDifference == 1 ? '' : 's'}' : '${AppLocalization.of(context).getTranslatedValue('monthsFeed')}'}  ${AppLocalization.of(context).getTranslatedValue('agoFeed')}';
    }
  }

  setWeatherPDFLoader(value) {
    weatherPDFloader = value;
    notifyListeners();
  }

  setRepostLoader(value) {
    repostLoader = value;
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
    reportPostLoader = false;
    hasIncreasedViewForImage = false;
    reportPostStatus = false;
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

  setReportPostloading(bool value) {
    reportPostLoader = value;
    notifyListeners();
  }

  void removeUserDeletedPost(String feedId) {
    feedList.removeWhere((e) => e["_id"] == feedId);
    notifyListeners();
  }

  void reportPost(String reason, String userId, BuildContext context) async {
    reportPostLoader = false;
    reportPostStatus = false;
    setReportPostloading(true);
    try {
      final payload = {"reason": reason, "reportedUserId": userId};
      final response = await _homeTabRepository.reportPost(payload);
      if (response['status']) {
        reportPostStatus = true;
        notifyListeners();
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
          setReportPostloading(false);
        });
      }
    } catch (error) {
      reportPostStatus = false;
      setReportPostloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
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
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
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
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
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

  void toggleLike(BuildContext context, String id, MyProfileViewModel myProfileViewModel,
      bool isLiked, String userId) async {
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

        int indexMyPost = myProfileViewModel.feedList.indexWhere((feed) => feed['_id'] == id);
        if (indexMyPost != -1) {
          setToogleMyPostFeed(!isLiked, id);
          myProfileViewModel.feedList.replaceRange(indexMyPost, indexMyPost + 1, [updatedFeed]);
        }
        int indexMyBookMarked =
            myProfileViewModel.bookMarkFeedList.indexWhere((feed) => feed['_id'] == id);
        if (indexMyBookMarked != -1) {
          setToogleLikeBookMarkedFeed(!isLiked, id);
          myProfileViewModel.bookMarkFeedList
              .replaceRange(indexMyBookMarked, indexMyBookMarked + 1, [updatedFeed]);
        }
      }
      await _homeTabRepository.toggleLike(id);
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void toggleTimeline(BuildContext context, String id, String userId, bool isbookmarked,
      MyProfileViewModel myProfileViewModel) async {
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
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
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
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  List<Comment> mapComments(dynamic comments) {
    return List<Comment>.from(comments.map((comment) {
      return Comment.fromJson(comment);
    }));
  }

  List<String> extractHashtags(String caption) {
    final List<String> words = caption.split(' ');
    final List<String> hashtags = [];

    for (final String word in words) {
      if (word.startsWith('#')) {
        String hashtag = word.substring(1);
        if (hashtag.length <= 15) {
          hashtags.add(hashtag);
        }
      }
    }
    return hashtags;
  }

  Future<bool> createPost(
      BuildContext context, String id, String caption, String imageUrl, bool isImgUploaded) async {
    try {
      Map<String, dynamic> payload = {};
      if (caption == "") {
        payload = {"categoryId": id};
        if (isImgUploaded) {
          payload["imgurl"] = imageUrl;
          payload["mediaType"] = "image";
        } else {
          payload["videoUrl"] = imageUrl;
          if (imageUrl.contains("https://youtu")) {
            payload["mediaType"] = "youtube";
          } else {
            payload["mediaType"] = "video";
          }
        }
      } else {
        List<String> tags = extractHashtags(caption);
        payload = {"categoryId": id, "hindiCaption": caption, "tags": tags};
        if (isImgUploaded) {
          payload["imgurl"] = imageUrl;
          payload["mediaType"] = "image";
        } else {
          payload["videoUrl"] = imageUrl;
          if (imageUrl.contains("https://youtu")) {
            payload["mediaType"] = "youtube";
          } else {
            payload["mediaType"] = "video";
          }
        }
      }
      await _homeTabRepository.createPost(payload);
      return true;
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
      return false;
    }
  }

  void resharePost(
      BuildContext context, String id, String caption, CreatePostModel createPostModel) async {
    setRepostLoader(true);
    try {
      Map<String, dynamic> payload = {"repostDescription": caption};
      await _homeTabRepository.resharePost(payload, id).then((value) {
        createPostModel.setfetchMyPost(true);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("postCreatedTitle").toString(),
              AppLocalization.of(context).getTranslatedValue("postCreatedSubtitle").toString(),
              context);
          setRepostLoader(false);
        });
      });
    } catch (error) {
      setRepostLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  Future<bool> updatePost(
      BuildContext context, String id, String caption, String feedId, bool isShared) async {
    try {
      Map<String, dynamic> payload = {};
      List<String> tags = extractHashtags(caption);
      if (isShared) {
        payload = {"feedId": feedId, "categoryId": id, "tags": tags, "repostDescription": caption};
      } else {
        payload = {"feedId": feedId, "categoryId": id, "hindiCaption": caption, "tags": tags};
      }
      await _homeTabRepository.updatePost(payload);
      return true;
    } catch (error) {
      setloading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
      return false;
    }
  }

  void addComment(BuildContext context, String id, String comment, User user,
      MyProfileViewModel myProfileViewModel) async {
    if (comment.isNotEmpty) {
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
          final myPostIndex = myProfileViewModel.feedList.indexWhere((feed) => feed['_id'] == id);
          if (myPostIndex != -1) {
            setIncreaseCommentNumber(commentsList.length, id);
            myProfileViewModel.feedList.replaceRange(myPostIndex, myPostIndex + 1, [update]);
          }
          final myBookMarkedIndex =
              myProfileViewModel.bookMarkFeedList.indexWhere((feed) => feed['_id'] == id);
          if (myBookMarkedIndex != -1) {
            setIncreaseCommentNumber(commentsList.length, id);
            myProfileViewModel.bookMarkFeedList
                .replaceRange(myBookMarkedIndex, myBookMarkedIndex + 1, [update]);
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
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }

  void increaseViews(BuildContext context, String feedId) async {
    try {
      await _homeTabRepository.increaseView(feedId);
      hasIncreasedViewForImage = true;
    } catch (error) {
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }
}
