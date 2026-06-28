import 'dart:convert';
import 'dart:io';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:another_flushbar/flushbar_route.dart';
import "package:fluttertoast/fluttertoast.dart";
import 'package:agriChikitsa/data/app_excaptions.dart';
import 'package:agriChikitsa/res/app_url.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class Utils {
  static void toastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static Map<String, double> getDimensions(BuildContext context, bool includeAppBarHeight) {
    final appBarHeight = includeAppBarHeight ? AppBar().preferredSize.height : 0;
    final deviceHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final deviceWidth = MediaQuery.of(context).size.width;
    return {"height": deviceHeight, "width": deviceWidth};
  }

  static void model(BuildContext context, Widget widgetContainer) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: false,
      builder: (BuildContext context) => widgetContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    );
  }

  static void launchDialer(String phoneNumber) async {
    try {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    } catch (error) {
      Utils.toastMessage(error.toString());
    }
  }

  static Future<void> launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static void flushBarErrorMessage(String title, String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        title: title,
        message: message,
        backgroundColor: AppColor.darkColor,
        duration: const Duration(seconds: 8),
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context),
    );
  }

  static String getBackendErrorMessage(dynamic error, BuildContext context) {
    if (error is AppException) {
      final message = error.message;
      if (message is Map) {
        final localeCode = AppLocalization.of(context).locale.languageCode;
        if (localeCode == "hi" && message.containsKey("message_hi") && message["message_hi"] != null) {
          return message["message_hi"].toString();
        }
        if (message.containsKey("message_en") && message["message_en"] != null) {
          return message["message_en"].toString();
        }
        if (message.containsKey("message") && message["message"] != null) {
          return message["message"].toString();
        }
      }
      return message.toString();
    }
    if (error is Map) {
      final localeCode = AppLocalization.of(context).locale.languageCode;
      if (localeCode == "hi" && error.containsKey("message_hi") && error["message_hi"] != null) {
        return error["message_hi"].toString();
      }
      if (error.containsKey("message_en") && error["message_en"] != null) {
        return error["message_en"].toString();
      }
      if (error.containsKey("message") && error["message"] != null) {
        return error["message"].toString();
      }
    }
    return error.toString();
  }

  static void snackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'mkv':
        return 'video/x-matroska';
      case 'avi':
        return 'video/x-msvideo';
      case 'webm':
        return 'video/webm';
      default:
        if (filePath.contains('image')) {
          return 'image/jpeg';
        } else if (filePath.contains('video')) {
          return 'video/mp4';
        }
        return 'application/octet-stream';
    }
  }

  static String getCloudFrontUrl(String s3Url) {
    try {
      final uri = Uri.parse(s3Url);
      if (uri.host.contains('agrichikitsabucket')) {
        return 'https://d36yh71dpxszen.cloudfront.net${uri.path}';
      }
    } catch (_) {}
    return s3Url;
  }

  static Future<dynamic> uploadImage(XFile image, {String forPurpose = 'feed'}) async {
    try {
      final localStorage = await SharedPreferences.getInstance();
      final mapString = localStorage.getString('profile');
      if (mapString == null) {
        return AppException("Token does not exist");
      }
      final profile = jsonDecode(mapString);
      final token = profile["token"];

      final fileName = image.path.split('/').last;
      final fileType = _getMimeType(image.path);

      // Step 1: Get presigned URL
      final getPresignedUrl = Uri.parse(AppUrl.getUploadUrlEndPoint);
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'fileName': fileName,
        'fileType': fileType,
        'forPurpose': forPurpose,
      });

      final presignedResponse = await http.post(getPresignedUrl, headers: headers, body: body);
      if (presignedResponse.statusCode != 200) {
        throw FetchDataException("Failed to get presigned URL: ${presignedResponse.body}");
      }

      final presignedData = jsonDecode(presignedResponse.body);
      if (presignedData['response'] != true) {
        throw FetchDataException("Presigned URL response is false");
      }

      final uploadUrl = presignedData['data']['uploadUrl'];
      final fileUrl = presignedData['data']['fileUrl'];

      // Step 2: Upload file directly to S3 PUT URL using StreamedRequest for memory efficiency
      final file = File(image.path);
      final request = http.StreamedRequest('PUT', Uri.parse(uploadUrl));
      request.headers['Content-Type'] = fileType;
      request.headers['Content-Length'] = (await file.length()).toString();

      final fileStream = file.openRead();
      fileStream.listen(
        (chunk) => request.sink.add(chunk),
        onDone: () => request.sink.close(),
        onError: (err) => request.sink.close(),
        cancelOnError: true,
      );

      final s3Response = await http.Response.fromStream(await request.send());
      if (s3Response.statusCode == 200 || s3Response.statusCode == 201 || s3Response.statusCode == 204) {
        return {
          'success': true,
          'imgurl': fileUrl,
        };
      } else {
        throw FetchDataException("S3 upload failed with status: ${s3Response.statusCode}");
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> uploadVideo(String video, {String forPurpose = 'feed'}) async {
    try {
      final localStorage = await SharedPreferences.getInstance();
      final mapString = localStorage.getString('profile');
      if (mapString == null) {
        return AppException("Token does not exist");
      }
      final profile = jsonDecode(mapString);
      final token = profile["token"];

      final fileName = video.split('/').last;
      final fileType = _getMimeType(video);

      // Step 1: Get presigned URL
      final getPresignedUrl = Uri.parse(AppUrl.getUploadUrlEndPoint);
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'fileName': fileName,
        'fileType': fileType,
        'forPurpose': forPurpose,
      });

      final presignedResponse = await http.post(getPresignedUrl, headers: headers, body: body);
      if (presignedResponse.statusCode != 200) {
        throw FetchDataException("Failed to get presigned URL: ${presignedResponse.body}");
      }

      final presignedData = jsonDecode(presignedResponse.body);
      if (presignedData['response'] != true) {
        throw FetchDataException("Presigned URL response is false");
      }

      final uploadUrl = presignedData['data']['uploadUrl'];
      final fileUrl = presignedData['data']['fileUrl'];

      // Step 2: Upload file directly to S3 PUT URL using StreamedRequest for memory efficiency
      final file = File(video);
      final request = http.StreamedRequest('PUT', Uri.parse(uploadUrl));
      request.headers['Content-Type'] = fileType;
      request.headers['Content-Length'] = (await file.length()).toString();

      final fileStream = file.openRead();
      fileStream.listen(
        (chunk) => request.sink.add(chunk),
        onDone: () => request.sink.close(),
        onError: (err) => request.sink.close(),
        cancelOnError: true,
      );

      final s3Response = await http.Response.fromStream(await request.send());
      if (s3Response.statusCode == 200 || s3Response.statusCode == 201 || s3Response.statusCode == 204) {
        return {
          'success': true,
          'url': fileUrl,
        };
      } else {
        throw FetchDataException("S3 upload failed with status: ${s3Response.statusCode}");
      }
    } catch (error) {
      rethrow;
    }
  }


  static Future<dynamic> capturePhoto() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo == null) {
        return null;
      }
      return photo;
    } catch (error) {
      rethrow;
    }
  }

  //For single image
  static Future<dynamic> pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return image;
    } catch (error) {
      rethrow;
    }
  }

  //For multiple images
  static Future<List<XFile>?> pickMultipleImages() async {
    try {
      final List<XFile> images = await ImagePicker().pickMultiImage();
      if (images.isEmpty) return null;
      return images;
    } catch (error) {
      rethrow;
    }
  }

  static Future<CroppedFile?> cropImage(String imagePath, dynamic dimension) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio:
            CropAspectRatio(ratioX: dimension['width']! - 16, ratioY: dimension['width']! - 16),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColor.extraDark,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );
      return croppedFile;
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> pickVideo() async {
    try {
      final XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (video == null) return null;
      final VideoPlayerController videoController = VideoPlayerController.file(File(video.path));
      await videoController.initialize();
      final Duration videoDuration = videoController.value.duration;
      videoController.dispose();
      if (videoDuration.inSeconds > 60) {
        return 'Video exceeds the maximum duration of 1 minute.';
      }
      return video;
    } catch (error) {
      rethrow;
    }
  }

  static void showAlert(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        });
  }

  String formatCommentTimeDifference(String timestamp) {
    DateTime inputTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();

    Duration difference = now.difference(inputTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}m';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }

  static String cleanHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '').replaceAll('&nbsp;', ' ').trim();
  }

  static void showResultDialog(
    BuildContext context,
    dynamic dimension,
    Image? image,
    Function callback,
    String message,
    bool isSuccess,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 3), () {
          if (Navigator.canPop(dialogContext)) Navigator.of(dialogContext).pop();
          callback();
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: dimension["height"]! * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isSuccess
                    ? ClipRRect(borderRadius: BorderRadius.circular(10), child: image)
                    : Lottie.asset(
                        'assets/lottie/fail.json',
                        height: dimension['height']! * 0.10,
                        width: dimension['width']! * 0.30,
                      ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool> ensureStoragePermission(BuildContext context) async {
    if (!Platform.isAndroid) return true;

    var status = await Permission.storage.status;

    if (status.isGranted) return true;

    // Ask again if denied
    status = await Permission.storage.request();

    if (status.isGranted) return true;

    // Permanently denied → redirect to settings
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    if (context.mounted) {
      toastMessage(AppLocalization.of(context).getTranslatedValue("errorMessage").toString());
    }

    return false;
  }

  static Future<void> showAutoCloseDialog(
    BuildContext context, {
    required String title,
    required String message,
    required bool success,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: success ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
