import 'package:flutter/material.dart';
import 'package:agriChikitsa/utils/utils.dart';
import '../../../model/chat_message_model.dart';
import '../../../repository/chat_tab.repo/chat_tab_repository.dart';
import '../../../services/auth.dart';

class ChatTabViewModel with ChangeNotifier {
  final _chatTabRepository = ChatTabRepository();
  List<ChatMessageModel> chatMessageList = [];
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

  void disposeValues() {
    _loading = false;
  }

  void fetchCategory() async {
    try {} catch (e) {}
  }

  void setChatMessagesList() async {
    try {
      if (message.isNotEmpty) {
        chatMessageList = mapChatMessages(message);
        message = "";
        messageController.clear();
      }

      notifyListeners();
    } catch (error) {
      // Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  List<ChatMessageModel> mapChatMessages(String message) {
    return [...chatMessageList, ChatMessageModel(message: message, isMe: true)];
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
}
