import 'dart:convert';
import 'package:agriChikitsa/repository/home_tab.repo/home_tab_repository.dart';
import 'package:agriChikitsa/routes/routes_name.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/category_model.dart';
import '../../../model/comment.dart';
import '../../../model/user_model.dart' as currentUser;

class HomeTabViewModel with ChangeNotifier {
  final _homeTabRepository = HomeTabRepository();
  dynamic feedList = [];
  List<Category> categoriesList = [];
  List<Comment> commentsList = [];
  String currentSelectedCategory = "All";
  var categoryLoading = true;
  var commentLoading = true;
  var _loading = true;

  bool get loading {
    return _loading;
  }

  setActiveState(BuildContext context, Category category, bool value) {
    currentSelectedCategory = category.id;
    notifyListeners();
    fetchFeeds(context);
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
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
        Category(
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

  List<Category> mapCategories(dynamic categories) {
    return List<Category>.from(categories.map((category) {
      return Category(
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
      BuildContext context, String id, currentUser.User user) async {
    try {
      final data = await _homeTabRepository.toggleTimeline(id);
      user.timeline = data['timeLine'];
      print(user.timeline);
      notifyListeners();
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

  void createPost(
      BuildContext context, String id, String caption, String imageUrl) async {
    try {
      final payload = {
        "categoryId": id,
        "caption": caption,
        "imgurl": imageUrl
      };
      final data = await _homeTabRepository.createPost(payload);
      if (data['message'] == "Feed created successfully") {
        Utils.toastMessage("Post Request has been sent to admin");
      }
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
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
