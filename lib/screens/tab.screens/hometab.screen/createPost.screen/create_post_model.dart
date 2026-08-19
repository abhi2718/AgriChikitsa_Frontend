import 'dart:async';
import 'dart:io';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/category_model.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  VideoPlayerController? videoController;
  TextEditingController youtubeUrlController = TextEditingController();
  bool isPostPicked = false;
  String currentSelectedCategory = "";
  // var categoryLoading = true;

  Map<String, String> dropdownOptions = {};
  var imagePath = [];
  var imageUrl = "";
  var buttonloading = false;
  var caption = '';
  var category = '';
  List<PostImageItem> postImages = [];
  bool isUploading = false;
  bool isUploadSuccess = false;
  bool isUploadError = false;

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
    if (feed['mediaType'] == "image" && feed['images'].isNotEmpty && feed["images"].length > 1) {
      imagePath = feed['images'];
    } else if (feed['mediaType'] == "image" && feed['images'].length == 1) {
      imagePath = [feed['images'][0]];
    } else {
      imagePath = [];
    }
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

  setUploading(bool value) {
    isUploading = value;
    notifyListeners();
  }

  setUploadSuccess(bool value) {
    isUploadSuccess = value;
    notifyListeners();
  }

  setUploadError(bool value) {
    isUploadError = value;
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
      if (videoController != null) {
        videoController!.dispose();
        videoController = null;
      }
      captionController.clear();
      youtubeUrlController.clear();
      imagePath = [];
      isUploading = false;
      imageUrl = "";
      youtubeVideoPath = '';
      isPostPicked = false;
      videoPicked = null;
      caption = "";
      currentSelectedCategory = "";
      buttonloading = false;
      postImages = [];
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
    imagePath.clear();
    postImages.clear();
    notifyListeners();
  }

//For a single image
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

  //for multiple images
  void pickPostImages(BuildContext context, dynamic dimension) async {
    try {
      if (isPostPicked) {
        return;
      }

      final List<XFile>? images = await Utils.pickMultipleImages();
      if (images == null) return;

      // Limit to a maximum of 4 images
      if (images.length > 4) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("multipleImageWarning").toString(),
            AppLocalization.of(context).getTranslatedValue("deselctImageWarning").toString(),
            context,
          );
        }
        return;
      }
      if (images.isNotEmpty) {
        for (var image in images) {
          // Crop each image
          final original = image;
          final croppedFile = await Utils.cropImage(image.path, dimension);
          if (croppedFile != null) {
            postImages
                .add(PostImageItem(originalFile: original, croppedFile: XFile(croppedFile.path)));
          }
        }

        if (postImages.isNotEmpty) {
          isPostPicked = true;
          Navigator.pop(context);
          notifyListeners();
        }
      }
    } catch (error) {
      if (context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  static String formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    int i = (bytes.bitLength - 1) ~/ 10;
    double size = bytes / (1 << (i * 10));
    return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  //For removing selected images
  void removeImage(int index) {
    if (index >= 0 && index < postImages.length) {
      postImages.removeAt(index);
      if (postImages.isEmpty) {
        isPostPicked = false;
      }
      notifyListeners();
    }
  }

  void pickPostVideo(context, AuthService authService) async {
    try {
      if (isPostPicked) {
        return;
      }
      videoPicked = await Utils.pickVideo();
      if (videoPicked is String) {
        Fluttertoast.showToast(
            msg: AppLocalization.of(context).getTranslatedValue("videoWarning").toString());
        return;
      } else {
        if (videoPicked != null) {
          videoPicked = videoPicked.path;
          Navigator.pop(context);
          Navigator.pop(context);
          isPostPicked = true;
          if (videoController != null) {
            videoController!.dispose();
          }
          videoController = VideoPlayerController.file(File(videoPicked))
            ..addListener(() {
              notifyListeners();
            })
            ..setLooping(true)
            ..initialize().then((value) {
              // notifyListeners();
              videoController?.play();
            });
          notifyListeners();
        }
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

//old method
  // void createPost(
  //   BuildContext context,
  // ) async {
  //   if (currentSelectedCategory.isNotEmpty &&
  //       (imagePath.isNotEmpty || videoPicked != null || youtubeVideoPath.isNotEmpty)) {
  //     setloading(true);
  //     FocusManager.instance.primaryFocus?.unfocus();
  //     var response;
  //     if (imagePath.isNotEmpty) {
  //       response = await Utils.uploadImage(imagePicked);
  //     } else if (videoPicked != null) {
  //       response = await Utils.uploadVideo(videoPicked);
  //     } else {
  //       response = {'success': true, 'url': youtubeVideoPath};
  //     }
  //     if (response['success']) {
  //       final passedUrl = imagePath.isEmpty ? response['url'] : response['imgurl'];
  //       final data = await _homeTabViewModel.createPost(
  //           context, currentSelectedCategory, caption, passedUrl, imagePath.isNotEmpty);
  //       setfetchMyPost(true);
  //       if (data) {
  //         await Future.delayed(const Duration(seconds: 1), () {
  //           goBack(context);
  //           setloading(false);
  //           Utils.flushBarErrorMessage(
  //               AppLocalization.of(context).getTranslatedValue("postCreatedTitle").toString(),
  //               AppLocalization.of(context).getTranslatedValue("postCreatedSubtitle").toString(),
  //               context);
  //           reinitialize();
  //         });
  //       }
  //     } else {
  //       if (context.mounted) {
  //         Utils.flushBarErrorMessage(
  //             AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
  //             AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString(),
  //             context);
  //       }
  //     }
  //   } else {
  //     setloading(false);
  //     Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
  //         AppLocalization.of(context).getTranslatedValue("fillAllDetails").toString(), context);
  //   }
  // }

  void createPost(BuildContext context, VoidCallback onPostCreated) async {
    if (currentSelectedCategory.isNotEmpty &&
        (postImages.isNotEmpty || videoPicked != null || youtubeVideoPath.isNotEmpty)) {
      setUploading(true);

      // Pre-capture localized success toast string
      final successMsg =
          AppLocalization.of(context).getTranslatedValue("postCreatedSubtitle").toString();

      // Copy variables to local variables to prevent race condition during page pop
      final localPostImages = List<PostImageItem>.from(postImages);
      final localVideoPicked = videoPicked;
      final localYoutubeVideoPath = youtubeVideoPath;
      final localCaption = caption;
      final localCategory = currentSelectedCategory;

      if (videoController != null) {
        videoController!.pause();
      }

      // Navigate to Home Screen immediately
      Navigator.pop(context);

      // Start upload in the background
      uploadPostInBackground(
        context,
        onPostCreated,
        localPostImages,
        localVideoPicked,
        localYoutubeVideoPath,
        localCaption,
        localCategory,
        successMsg,
      );
    } else {
      Utils.flushBarErrorMessage(
        AppLocalization.of(context).getTranslatedValue("alert").toString(),
        AppLocalization.of(context).getTranslatedValue("fillAllDetails").toString(),
        context,
      );
    }
  }

  bool checkPostImageData() {
    for (var postImage in postImages) {
      if (postImage.thumbnailUrl == null ||
          postImage.originalUrl == null ||
          postImage.thumbnailUrl!.isEmpty ||
          postImage.originalUrl!.isEmpty) {
        return false;
      }
    }
    return true;
  }

  List<Map<String, String>> getFeedImagePayload() {
    List<Map<String, String>> imagesPayload = [];
    for (var postImage in postImages) {
      imagesPayload.add({
        "originalUrl": postImage.originalUrl ?? "",
        "thumbnailUrl": postImage.thumbnailUrl ?? "",
      });
    }
    return imagesPayload;
  }

  List<Map<String, String>> getFeedImagePayloadFromList(List<PostImageItem> images) {
    List<Map<String, String>> imagesPayload = [];
    for (var postImage in images) {
      imagesPayload.add({
        "originalUrl": postImage.originalUrl ?? "",
        "thumbnailUrl": postImage.thumbnailUrl ?? "",
      });
    }
    return imagesPayload;
  }

  Future<void> uploadPostInBackground(
    BuildContext context,
    VoidCallback onPostCreated,
    List<PostImageItem> localPostImages,
    dynamic localVideoPicked,
    String localYoutubeVideoPath,
    String localCaption,
    String localCategory,
    String successMsg,
  ) async {
    dynamic response;

    // Upload images
    if (localPostImages.isNotEmpty) {
      for (var postItem in localPostImages) {
        var croppedResponse = await Utils.uploadImage(postItem.croppedFile!);
        var ogImgResponse = await Utils.uploadImage(postItem.originalFile!);
        if (croppedResponse['success']) {
          postItem.thumbnailUrl = croppedResponse['imgurl'];
          postItem.originalUrl = ogImgResponse['imgurl'];
        } else {
          if (context.mounted) {
            Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
              AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString(),
              context,
            );
          }
          setUploading(false);
          setUploadError(true);
          Timer(const Duration(seconds: 3), () {
            setUploadError(false);
          });
          return;
        }
      }
    }

    // Upload video
    if (localVideoPicked != null) {
      response = await Utils.uploadVideo(localVideoPicked);
    } else {
      response = {'success': true, 'url': localYoutubeVideoPath};
    }

    bool isImageUploaded = localPostImages.isNotEmpty;
    if (response['success'] || isImageUploaded) {
      final passedUrl = isImageUploaded ? getFeedImagePayloadFromList(localPostImages) : response['url'];
      final data = await _homeTabViewModel.createPost(
        context,
        localCategory,
        localCaption,
        passedUrl,
        isImageUploaded,
      );

      if (data) {
        onPostCreated();
        Utils.toastMessage(successMsg);
        setfetchMyPost(true);
        setUploading(false);
        setUploadSuccess(true);
        Timer(const Duration(seconds: 3), () {
          setUploadSuccess(false);
        });
      } else {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
            AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString(),
            context,
          );
        }
        setUploading(false);
        setUploadError(true);
        Timer(const Duration(seconds: 3), () {
          setUploadError(false);
        });
      }
    } else {
      setUploading(false);
      setUploadError(true);
      Timer(const Duration(seconds: 3), () {
        setUploadError(false);
      });
      if (context.mounted) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("oopsTitle").toString(),
          AppLocalization.of(context).getTranslatedValue("someErrorOccured").toString(),
          context,
        );
      }
    }
    reinitialize();
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
    } else {
      setloading(false);
      Utils.flushBarErrorMessage(AppLocalization.of(context).getTranslatedValue("alert").toString(),
          AppLocalization.of(context).getTranslatedValue("fillAllDetails").toString(), context);
    }
  }
}

class PostImageItem {
  XFile? originalFile;
  XFile? croppedFile;

  String? originalUrl;
  String? thumbnailUrl;

  PostImageItem({
    this.originalFile,
    this.croppedFile,
    this.originalUrl,
    this.thumbnailUrl,
  });
}
