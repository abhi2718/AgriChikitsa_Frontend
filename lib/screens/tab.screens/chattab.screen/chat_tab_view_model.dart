import 'package:flutter/material.dart';
import 'package:agriChikitsa/utils/utils.dart';
import '../../../model/bot_message_model.dart';
import '../../../model/chat_message_model.dart';
import '../../../repository/chat_tab.repo/chat_tab_repository.dart';
import '../../../services/auth.dart';

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

  void setMessageFieldOption(BuildContext context, value) {
    message = value;
    addQuestion(context, message);
    setChatMessagesList();
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

  // Future<List<BotMessage1>> loadBotMessages(String data) async {
  //   final jsonData = json.decode(data) as List<dynamic>;
  //   return jsonData.map((json) => BotMessage1.fromJson(json)).toList();
  // }
  void fetchBotMessages(BuildContext context) async {
    // final filePath = 'assets/chatBotScript.json'; // Replace with your file path
    // botMessageList = await loadBotMessages(filePath);
    // if (botMessageList.length >= 1) {
    //   chatMessageList.add(botMessageList[0]);
    //   totalMessageCount += 1;
    // }

    // if (botMessageList.length >= 2) {
    //   chatMessageList.add(botMessageList[1]);
    //   totalMessageCount += 1;
    // }
    try {
      final data = await _chatTabRepository.fetchBotMessage();
      loadBotMessages(data);
      if (botMessageList.length >= 1) {
        chatMessageList.add(botMessageList[0]);
        totalMessageCount += 1;
      }
      if (botMessageList.length >= 2) {
        chatMessageList.add(botMessageList[1]);
        totalMessageCount += 1;
      }
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void loadBotMessages(dynamic data) {
    final List<dynamic> messages = data;
    botMessageList =
        messages.map((message) => BotMessage1.fromJson(message)).toList();
  }

  void addQuestion(BuildContext context, String chatMessage) async {
    try {
      //There might be a parsing issue here.
      final payload = {"question": chatMessage};
      final data = await _chatTabRepository.addQuestion(payload);
      //Here {"answer":"random tex"} this is being generated  which is not getting mapped i guess.
      // loadBotMessages(data);

      //Solution 1- Create a new model BotMessage and manipulate condition on frontend.
      // final newMessage = BotMessage(text: data['answer']);
      // chatMessageList = [...chatMessageList, newMessage];
      notifyListeners();
    } catch (error) {
      setloading(false);
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }
}
