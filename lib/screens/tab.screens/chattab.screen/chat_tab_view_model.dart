import 'package:flutter/material.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../model/chat_message_model.dart';
import '../../../repository/chat_tab.repo/chat_tab_repository.dart';
import '../../../services/auth.dart';

class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}

class ChatTabViewModel with ChangeNotifier {
  //final textEditingController = useTextEditingController();
  final List<ChatMessage> chatMessages = [];
  void handleUserQuery(String query) {
    
    if (query.isNotEmpty) {
      final botResponse = generateBotResponse(query);

      final botMessage = ChatMessage(text: botResponse, isUserMessage: false);

      chatMessages.add(botMessage);
      notifyListeners();
    }
  }

  String generateBotResponse(String userQuery) {
    for (final rule in rules) {
      final pattern = rule['pattern'] as String;
      final response = rule['response'] as String;

      if (userQuery.toLowerCase().contains(pattern)) {
        return response;
      }
    }

    return 'Sorry, I don\'t understand. Can you please rephrase your query?';
  }

  final List<Map<String, dynamic>> rules = [
    {
      'pattern': 'hi',
      'response': 'Hello! How can I assist you?',
    },
    {
      'pattern': 'how are you',
      'response': 'I am doing well. Thank you!',
    },
    // Add more rules as needed
  ];

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
