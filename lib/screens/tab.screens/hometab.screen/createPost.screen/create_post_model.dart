import 'dart:async';
import 'dart:io';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import '../../../../services/auth.dart';
import '../../../../utils/utils.dart';

class CreatePostModel with ChangeNotifier {
  final _homeTabViewModel = HomeTabViewModel();
  var captionController = TextEditingController();
  final captionFocusNode = FocusNode();
  final categoryFocusNode = FocusNode();
  List<dynamic> categoriesList = [];
  var fetchMyPost = false;
  dynamic imagePicked;
  dynamic videoPicked;
  String youtubeVideoPath = '';
  late VideoPlayerController videoController;
  TextEditingController youtubeUrlController = TextEditingController();
  bool isPostPicked = false;
  String currentSelectedCategory = "";
  // var categoryLoading = true;

  Map<String, String> dropdownOptions = {};
  var imagePath = "";
  var imageUrl = "";
  var buttonloading = false;
  var caption = '';
  var category = '';

  void setfetchMyPost(bool val) {
    fetchMyPost = val;
    notifyListeners();
  }

  void setFeedData(dynamic feed) {
    isPostPicked = true;
    if (feed.containsKey("repostedFrom")) {
      caption = feed["repostDescription"] ?? "";
      captionController.text = feed['repostDescription'] ?? "";
    } else {
      caption = feed["hindiCaption"] ?? "";
      captionController.text = feed['hindiCaption'] ?? "";
    }
    imagePath = feed['mediaType'] == "image" ? feed['imgurl'] : "";
    currentSelectedCategory = feed.containsKey('categoryRef') ? feed['categoryRef'] : "";
    // notifyListeners();
  }

  setActiveState(BuildContext context, CategoryHome category, bool value) {
    currentSelectedCategory = category.id;
    notifyListeners();
  }

  setloading(bool value) {
    buttonloading = value;
    notifyListeners();
  }

  void fetchFeedsCategory(BuildContext context, HomeTabViewModel homeTabViewModel) async {
    try {
      categoriesList = List.from(homeTabViewModel.categoriesList);
      categoriesList.removeWhere((item) => item.name == "All");
    } catch (error) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }

  void reinitialize() {
    Timer(const Duration(milliseconds: 500), () {
      captionController.clear();
      youtubeUrlController.clear();
      imagePath = "";
      imageUrl = "";
      youtubeVideoPath = '';
      isPostPicked = false;
      videoPicked = null;
      caption = "";
      currentSelectedCategory = "";
      buttonloading = false;
    });
  }

  void onSavedCaptionField(value) {
    caption = value;
  }

  void handleUserInput(BuildContext context) {
    final value = captionController.text;
    if (value.isNotEmpty) {
      caption = captionController.text;
    }
  }

  void onSavedCategoryField(value) {
    category = value.toString();
  }

  void goBack(BuildContext context) {
    reinitialize();
    Navigator.pop(context);
  }

  void clearImagePath() {
    imagePath = "";
    notifyListeners();
  }

  void pickPostImage(context, AuthService authService) async {
    try {
      if (isPostPicked) {
        return;
      }
      imagePicked = await Utils.pickImage();
      if (imagePicked != null) {
        imagePath = imagePicked.path;
        Navigator.pop(context);
        isPostPicked = true;
        notifyListeners();
      }
    } catch (error) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }

  void pickPostVideo(context, AuthService authService) async {
    try {
      if (isPostPicked) {
        return;
      }
      videoPicked = await Utils.pickVideo();
      if (videoPicked != null) {
        videoPicked = videoPicked.path;
        Navigator.pop(context);
        Navigator.pop(context);
        isPostPicked = true;
        videoController = VideoPlayerController.file(File(videoPicked))
          ..addListener(() {
            notifyListeners();
          })
          ..setLooping(true)
          ..initialize().then((value) {
            // notifyListeners();
            videoController.play();
          });
        notifyListeners();
      }
    } catch (error) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }

  void addYoutubeUrl(BuildContext context) {
    FocusScope.of(context).unfocus();
    youtubeUrlController.text = youtubeUrlController.text.trim();
    if (youtubeUrlController.text.isEmpty || !youtubeUrlController.text.contains('https://youtu')) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue('youtubeUrlInvalid').toString(), context);
      return;
    }
    try {
      youtubeVideoPath = youtubeUrlController.text;
      isPostPicked = true;
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(), context);
    }
  }

  void createPost(
    BuildContext context,
  ) async {
    if (currentSelectedCategory.isNotEmpty &&
        (imagePath.isNotEmpty || videoPicked != null || youtubeVideoPath.isNotEmpty)) {
      setloading(true);
      FocusManager.instance.primaryFocus?.unfocus();
      var response;
      if (imagePath.isNotEmpty) {
        response = await Utils.uploadImage(imagePicked);
      } else if (videoPicked != null) {
        response = await Utils.uploadVideo(videoPicked);
      } else {
        response = {'success': true, 'url': youtubeVideoPath};
      }
      if (response['success']) {
        final passedUrl = imagePath.isEmpty ? response['url'] : response['imgurl'];
        final data = await _homeTabViewModel.createPost(
            context, currentSelectedCategory, caption, passedUrl, imagePath.isNotEmpty);
        setfetchMyPost(true);
        if (data) {
          await Future.delayed(const Duration(seconds: 1), () {
            goBack(context);
            setloading(false);
            Utils.flushBarErrorMessage(
                AppLocalization.of(context).getTranslatedValue("postCreatedTitle").toString(),
                AppLocalization.of(context).getTranslatedValue("postCreatedSubtitle").toString(),
                context);
            reinitialize();
          });
        }
      } else {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
              AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString(),
              context);
        }
      }
    } else {
      setloading(false);
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue("fillAllDetails").toString(), context);
    }
  }

  void updatePost(BuildContext context, String feedId, bool isShared) async {
    if (currentSelectedCategory.isNotEmpty) {
      setloading(true);
      FocusManager.instance.primaryFocus?.unfocus();
      final data = await _homeTabViewModel.updatePost(
          context, currentSelectedCategory, caption, feedId, isShared);
      setfetchMyPost(true);
      if (data) {
        await Future.delayed(const Duration(seconds: 1), () {
          goBack(context);
          setloading(false);
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("postCreatedTitle").toString(),
              AppLocalization.of(context).getTranslatedValue("postEditedSubtitle").toString(),
              context);
          reinitialize();
        });
      }
      // } else {
      //   if (context.mounted) {
      //     Utils.flushBarErrorMessage(
      //         AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
      //         AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString(),
      //         context);
      //   }
      // }
    } else {
      setloading(false);
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue("fillAllDetails").toString(), context);
    }
  }
}
