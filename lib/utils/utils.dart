import 'dart:convert';
import 'package:http/http.dart' as http;
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

class Utils {
  static void toastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static Map<String, double> getDimensions(
      BuildContext context, bool includeAppBarHeight) {
    final appBarHeight =
        includeAppBarHeight ? AppBar().preferredSize.height : 0;
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

  static void flushBarErrorMessage(
      String title, String message, BuildContext context) {
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

  static void snackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static Future<dynamic> uploadImage(XFile image) async {
    try {
      final localStorage = await SharedPreferences.getInstance();
      final mapString = localStorage.getString('profile');
      if (mapString == null) {
        return AppException("Token does not exist");
      }
      final profile = jsonDecode(mapString);
      final url = Uri.parse(AppUrl.uploadImageEndPoint);
      final headers = {'Authorization': 'Bearer ${profile["token"]}'};
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await http.Response.fromStream(await request.send());
      final body = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          return body;
        case 201:
          return body;
        case 400:
          throw BadRequestException(body["message"].toString());
        case 404:
          throw UnAuthorisedException(body["message"].toString());
        default:
          throw FetchDataException(body["message"].toString());
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> capturePhoto() async {
    try {
      final XFile? photo =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo == null) {
        return null;
      }
      return photo;
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> pickImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return image;
    } catch (error) {
      rethrow;
    }
  }

  static showAlert(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        });
  }
}
