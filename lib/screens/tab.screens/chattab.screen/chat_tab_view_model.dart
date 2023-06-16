import 'package:flutter/material.dart';
import 'package:agriChikitsa/utils/utils.dart';
import '../../../model/bot_message_model.dart';
import '../../../model/chat_message_model.dart';
import '../../../repository/chat_tab.repo/chat_tab_repository.dart';
import '../../../services/auth.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ChatTabViewModel with ChangeNotifier {
  final _chatTabRepository = ChatTabRepository();
  List<dynamic> chatMessageList = [];
  List botMessageList = [];
  int totalMessageCount = 0;
  var messageController = TextEditingController();
  String message = "";
  var _loading = false;
  bool get loading {
    return _loading;
  }

  setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setMessageField() {
    message = messageController.text;
    notifyListeners();
  }

  void setMessageFieldOption(value) {
    message = value;
    setChatMessagesList();
    notifyListeners();
  }

  void disposeValues() {
    _loading = false;
  }

  void fetchCategory() async {
    try {} catch (e) {}
  }

  void fetchBotMessages() async {
    final filePath = 'assets/chatBotScript.json'; // Replace with your file path
    botMessageList = await loadBotMessages(filePath);
    if (botMessageList.length >= 1) {
      chatMessageList.add(botMessageList[0]);
      totalMessageCount += 1;
    }

    if (botMessageList.length >= 2) {
      chatMessageList.add(botMessageList[1]);
      totalMessageCount += 1;
    }
  }

  void setChatMessagesList() async {
    try {
      if (message.isNotEmpty) {
        chatMessageList.addAll(mapChatMessages(message));
        chatMessageList.addAll(mapBotMessages());
        message = "";
        messageController.clear();
      }
      notifyListeners();
    } catch (error) {
      // Handle error
    }
  }

  List<dynamic> mapChatMessages(String message) {
    final newMessage = ChatMessage(text: message);
    return [newMessage];
  }

  List<dynamic> mapBotMessages() {
    List<dynamic> botMessages = [];
    if (botMessageList.isNotEmpty) {
      // Assuming totalMessageCount is properly initialized and incremented elsewhere
      if (totalMessageCount < botMessageList.length) {
        botMessages.add(botMessageList[totalMessageCount]);
        totalMessageCount += 1;
      }
    }
    return botMessages;
  }

  void captureProfileImage(context, AuthService authService) async {
    try {
      final data = await Utils.capturePhoto();
      if (data != null) {
        // final response = await Utils.uploadImage(data);
        // print(response);
        // final user = User.fromJson(authService.userInfo["user"]);
        // final userInfo = {"_id": user.sId, "profileImage": response["imgurl"]};
        // updateProfile(userInfo, context, authService);
      }
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void pickProfileImage(context, AuthService authService) async {
    try {
      final data = await Utils.pickImage();
      if (data != null) {
        // final response = await Utils.uploadImage(data);
        // final user = User.fromJson(authService.userInfo["user"]);
        // final userInfo = {"_id": user.sId, "profileImage": response["imgurl"]};
        // updateProfile(userInfo, context, authService);
      }
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  Future<List<BotMessage1>> loadBotMessages(String filePath) async {
    final jsonString = await rootBundle.loadString(filePath);
    final jsonData = json.decode(jsonString) as List<dynamic>;
    return jsonData.map((json) => BotMessage1.fromJson(json)).toList();
  }
}
