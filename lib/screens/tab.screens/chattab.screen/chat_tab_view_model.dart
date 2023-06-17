import 'dart:async';
import 'package:flutter/material.dart';

class ChatTabViewModel with ChangeNotifier {
  bool showFirstBubbleLoader = false;
  bool showSecondBubbleLoader = false;
  bool showFourthLoading = false;
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

  void initialTask() {
    if (chatMessages.isEmpty) {
      chatMessages.add(questions[0]);
      Timer(const Duration(seconds: 2), () {
        showFirstBubbleLoader = true;
        notifyListeners();
      });
      Timer(const Duration(seconds: 4), () {
        showFirstBubbleLoader = false;
        chatMessages.add(questions[1]);
        handleSecondBubbleLoader();
        notifyListeners();
      });
    }
  }
  
  void loadGreating(String name) {
    final messageHi =
        'नमस्कार $name जी🤗, आपका एग्रीचिकित्सा में स्वागत है। इस मच्छ से हम आपके फसलों के रोगों एवं सबंधित समस्याओं का समाधान देनेकी कोशिश कर रहेहै। कृपया नीचे पछूए गए सवालों के सही उत्तर चुने।⏬';
    final messageEn = 'Hello $name, Welcome to Agrichikitsa';
    final greating = {
      "id": "2",
      "question_hi": messageHi,
      "question_en": messageEn,
      "isMe": false,
    };
    questions.insert(1, greating);
  }

  void handleSecondBubbleLoader() {
    showSecondBubbleLoader = true;
    notifyListeners();
    Timer(const Duration(seconds: 4), () {
      showSecondBubbleLoader = false;
      chatMessages.add(questions[2]);
      notifyListeners();
    });
  }

  void selectAge(String age, String id) {
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
    loadQuestionFour();
  }

  void loadQuestionFour() {
    showFourthLoading = true;
    notifyListeners();
    Timer(const Duration(seconds: 4), () {
      showFourthLoading = false;
      chatMessages.add(questions[3]);
      notifyListeners();
    });
  }

void handleSelctCrop(String crop, String id){
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
    chatMessages = updatedChatMessages.toList();
    notifyListeners();
}

  
}
