import 'dart:async';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../repository/chat_tab.repo/chat_tab_repository.dart';

class ChatTabViewModel with ChangeNotifier {
  final _chatTabRepository = ChatTabRepository();
  final textEditingController = TextEditingController();
  final dynamic timmerInstances = [];
  bool showFirstBubbleLoader = false;
  bool showSecondBubbleLoader = false;
  bool showThirdLoader = false;
  bool showFourthLoader = false;
  bool showFifthBubbleLoader = false;
  bool showSixthBubbleLoader = false;
  var questionIndex = 0;
  final dynamic questions = [
    {
      "id": "1",
      "question_hi": "🍃अपनी फसल के बारे में जाने एग्रीचिकित्सा के साथ। �",
      "question_en": "Know about your crop with Agrichikitsa",
      "isMe": false,
    },
    {
      "id": "3",
      "question_hi": "कृपया अपनी आयु सीमा चनु े।",
      "question_en": "Choose Your Age",
      "options_hi": ["#30 साल से कम", "#30 साल से 50 साल", "#50 साल से उपर"],
      "options_en": ["Below 30", "In Between 30 to 50", "50 plus"],
      "isAnswerSelected": false,
      "answer": "",
      "isMe": false,
    },
    {
      "id": "4",
      "question_hi":
          "कृपया अपनी फसल चुनें, यदि आपकी फसल यहाँ लिस्ट में नहीं है तो अकिंकित करें। ⏬",
      "question_en":
          "Now Select your crop. Note: If the crop is not in the list, then type your crop name",
      "options_hi": [
        "धान",
        "गेहूँ",
        "अरहर",
        "शलजम",
        "धनया",
        "मूल",
        "गाजर",
        "फूलगोभी",
        "पागोभी",
        "बैगन",
        "खीरा",
        "चुकंदर",
        "याज",
        "मच",
        "शमलामच",
        "अदरक",
        "आम",
        "केला",
        "पपीता"
      ],
      "isAnswerSelected": false,
      "answer": "",
      "isMe": false,
    }
  ];
  var chatMessages = [];

  void reinitilize() {
    timmerInstances.forEach((timer) => timer.cancel());
    chatMessages.clear();
    questionIndex = 0;
    textEditingController.clear();
    timmerInstances.clear();
    showFirstBubbleLoader = false;
    showSecondBubbleLoader = false;
    showThirdLoader = false;
    showFourthLoader = false;
    showFifthBubbleLoader = false;
  }

  void initialTask(context) {
    if (chatMessages.isEmpty) {
      chatMessages.add(questions[0]);
      showFirstBubbleLoader = true;
      final t1 = Timer(const Duration(seconds: 2), () {
        fetchFirstQuestion(context, "1");
      });
      timmerInstances.add(t1);
    }
  }

  void fetchFirstQuestion(BuildContext context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      showFirstBubbleLoader = false;
      showSecondBubbleLoader = true;
      notifyListeners();
      final t2 = Timer(const Duration(seconds: 2), () {
        fetchSecondQuestion(context, "2");
      });
      timmerInstances.add(t2);
    } catch (error) {
      showSecondBubbleLoader = false;
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void fetchSecondQuestion(BuildContext context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      showSecondBubbleLoader = false;
      notifyListeners();
    } catch (error) {
      showSecondBubbleLoader = false;
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void selectAge(context, String age, String id) {
    var updatedChatMessages = chatMessages.map((item) {
      if (item['id'] == id) {
        return {
          ...item,
          "isAnswerSelected": true,
          "answer": age,
        };
      }
      return item;
    });
    chatMessages = updatedChatMessages.toList();
    notifyListeners();
    loadQuestionFour(context);
  }

  void loadQuestionFour(context) {
    showThirdLoader = true;
    notifyListeners();
    final t4 = Timer(const Duration(seconds: 2), () {
      fetchThirdQuestion(context, "3");
      questionIndex = 3;
      notifyListeners();
    });
    timmerInstances.add(t4);
  }

  void fetchThirdQuestion(BuildContext context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      showThirdLoader = false;
      notifyListeners();
    } catch (error) {
      showThirdLoader = false;
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void handleSelctCrop(context, String crop, String id) {
    var updatedChatMessages = chatMessages.map((item) {
      if (item['id'] == id) {
        return {
          ...item,
          "isAnswerSelected": true,
          "answer": crop,
        };
      }
      return item;
    });
    questionIndex = 4;
    chatMessages = updatedChatMessages.toList();
    showFourthLoader = true;
    notifyListeners();
    final t5 = Timer(const Duration(seconds: 2), () {
      fetchFouthQuestion(context, "4");
      questionIndex = 5;
      notifyListeners();
    });
    timmerInstances.add(t5);
  }

  void fetchFouthQuestion(BuildContext context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      showFourthLoader = false;
      notifyListeners();
    } catch (error) {
      showFourthLoader = false;
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void selectCropDisease(context, String disease, String id) {
    var updatedChatMessages = chatMessages.map((item) {
      if (item['id'] == id) {
        return {
          ...item,
          "isAnswerSelected": true,
          "answer": disease,
        };
      }
      return item;
    });
    questionIndex = 6;
    chatMessages = updatedChatMessages.toList();
    showFifthBubbleLoader = true;
    notifyListeners();
    final t6 = Timer(const Duration(seconds: 2), () {
      fetchFifthQuestion(context, disease);
    });
    timmerInstances.add(t6);
  }

  void fetchFifthQuestion(context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      showFifthBubbleLoader = false;
      final question = data["question"];
      final isToShowCameraIcon =
          question["showCameraIcon"] == null ? false : true;
      if (!isToShowCameraIcon) {
        showSixthBubbleLoader = true;
        final t7 = Timer(const Duration(seconds: 2), () {
          fetchSixthQuestion(context, '6${question["id"]}');
        });
        timmerInstances.add(t7);
      }
      notifyListeners();
    } catch (error) {
      showFifthBubbleLoader = false;
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void fetchSixthQuestion(context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      showSixthBubbleLoader = false;
      final question = data["question"];
      final isToShowCameraIcon =
          question["showCameraIcon"] == null ? false : true;
      if (!isToShowCameraIcon) {}
      notifyListeners();
    } catch (error) {
      showSixthBubbleLoader = false;
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void handleUserInput(context) {
    if (questionIndex == 3) {
      final currentQuestion = chatMessages[questionIndex];
      handleSelctCrop(
          context, textEditingController.text, currentQuestion["id"]);
      textEditingController.clear();
      questionIndex = 4;
      showFourthLoader = true;
      notifyListeners();
      final t5 = Timer(const Duration(seconds: 2), () {
        fetchFouthQuestion(context, "4");
        questionIndex = 5;
        notifyListeners();
      });
      timmerInstances.add(t5);
    } else {
      Utils.flushBarErrorMessage(
          "Alert!", "Answer is allredy selected", context);
      textEditingController.clear();
    }
  }
}
