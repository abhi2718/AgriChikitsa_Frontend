import 'dart:async';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../../repository/chat_tab.repo/chat_tab_repository.dart';

class ChatTabViewModel with ChangeNotifier {
  final _chatTabRepository = ChatTabRepository();
  final textEditingController = TextEditingController();
  dynamic timmerInstances = [];
  bool showFirstBubbleLoader = false;
  bool showSecondBubbleLoader = false;
  bool showThirdLoader = false;
  bool showFourthLoader = false;
  bool showFifthBubbleLoader = false;
  bool showSixthBubbleLoader = false;
  bool showSeventhBubbleLoader = false;
  bool showLastMessage = false;
  bool showCropImageLoader = false;
  bool showCameraButton = false;
  bool enableKeyBoard = false;
  var questionAsked = "";
  var cropImage = "";
  var questionIndex = 0;
  var selectedDisease = '';
  var cameraQuestionId = '';

  final dynamic questions = [
    {
      "id": "1",
      "question_hi": "🍃अपनी फसल के बारे में जाने एग्रीचिकित्सा के साथ। �",
      "question_en": "Know about your crop with Agrichikitsa",
      "isMe": false,
    }
  ];
  var chatMessages = [];
  void setShowCameraButton(bool value) {
    showCameraButton = value;
  }

  void unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void goBack(BuildContext context) {
    unfocusKeyboard();
    reinitilize();
    Navigator.pop(context);
  }

  void reinitilize() {
    timmerInstances.forEach((timer) => timer.cancel());
    enableKeyBoard = false;
    questionAsked = "";
    chatMessages.clear();
    questionIndex = 0;
    textEditingController.clear();
    timmerInstances.clear();
    showFirstBubbleLoader = false;
    showSecondBubbleLoader = false;
    showThirdLoader = false;
    showFourthLoader = false;
    showFifthBubbleLoader = false;
    showSixthBubbleLoader = false;
    showSeventhBubbleLoader = false;
    showLastMessage = false;
    showCameraButton = false;
    showCropImageLoader = false;
    cropImage = "";
  }

  void enableKeyboard(bool value) {
    enableKeyBoard = value;
    notifyListeners();
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

  void sendQuestion(
      String id, String scriptQuestion, String answer, String imgurl) async {
    final payloadStructure = {
      "id": id,
      "question": scriptQuestion,
      "answer": answer,
    };
    final finalPayload = imgurl == ""
        ? payloadStructure
        : {...payloadStructure, "imageQuestion": imgurl};
    await _chatTabRepository.postChatQuestion(finalPayload);
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
        sendQuestion(id, item['question_hi'], age, "");
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
        sendQuestion(id, item['question_hi'], crop, "");
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
    selectedDisease = disease;
    var updatedChatMessages = chatMessages.map((item) {
      if (item['id'] == id) {
        sendQuestion(id, item['question_hi'], selectedDisease, "");
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
      final checkList = ['अन्य', 'खरपतवार'];
      if (!checkList.contains(id)) {
        final isToShowCameraIcon =
            question["showCameraIcon"] == null ? false : true;
        if (!isToShowCameraIcon) {
          showSixthBubbleLoader = true;
          final t7 = Timer(const Duration(seconds: 2), () {
            fetchSixthQuestion(context, '6${question["id"]}');
          });
          timmerInstances.add(t7);
        }
      } else {
        enableKeyboard(true);
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
      if (isToShowCameraIcon) {
        setShowCameraButton(true);
        cameraQuestionId = id;
      }
      if (!isToShowCameraIcon) {}
      notifyListeners();
    } catch (error) {
      showSixthBubbleLoader = false;
      Utils.flushBarErrorMessage('Alert', error.toString(), context);
    }
  }

  void handleUserInput(context) {
    if (textEditingController.text.isNotEmpty) {
      unfocusKeyboard();
      if (questionIndex == 3) {
        final currentQuestion = chatMessages[questionIndex];
        handleSelctCrop(
            context, textEditingController.text, currentQuestion["id"]);
        textEditingController.clear();
        questionIndex = 4;
        showFourthLoader = true;
        notifyListeners();
        final t5 = Timer(const Duration(seconds: 2), () {
          questionIndex = 5;
          notifyListeners();
        });
        timmerInstances.add(t5);
      }
      final selectedDiseaseList = ['अन्य', 'Other'];
      if (selectedDiseaseList.contains(selectedDisease)) {
        enableKeyboard(false);
        var updatedChatMessages = chatMessages.map((item) {
          if (item['id'] == chatMessages[chatMessages.length - 1]['id']) {
            sendQuestion(
                'अन्य', item['question_hi'], textEditingController.text, "");
            return {
              ...item,
              "isAnswerSelected": true,
              "answer": textEditingController.text,
            };
          }
          return item;
        });
        chatMessages = updatedChatMessages.toList();
        selectedDisease = '';
        textEditingController.clear();
        showSixthBubbleLoader = true;
        showLastMessage = true;
        notifyListeners();
        final t7 = Timer(const Duration(seconds: 2), () {
          chatMessages.add(
            {
              "id": "7",
              "question_hi":
                  "धन्यवाद \n हमारे कृषि विशेषज्ञ जल्द ही आपकी समस्या देखेंगे",
              "question_en": "Know about your crop with Agrichikitsa",
              "options_hi": [],
              "options_en": [],
              "isAnswerSelected": false,
              "answer": "",
              "isMe": false,
            },
          );
          showSixthBubbleLoader = false;
          notifyListeners();
        });
        timmerInstances.add(t7);
      }
    }
  }

  void uploadImage(context) async {
    try {
      final imageFile = await Utils.capturePhoto();
      if (imageFile != null) {
        showCropImageLoader = true;
        notifyListeners();
        final data = await Utils.uploadImage(imageFile);
        cropImage = data["imgurl"];
        final index = chatMessages.indexWhere((chatMessage) {
          return chatMessage['id'] == cameraQuestionId;
        });
        if (index != -1) {
          final item = chatMessages[index];
          sendQuestion(cameraQuestionId, item['question_hi'], "", cropImage);
        }
        showCropImageLoader = false;
        showSeventhBubbleLoader = true;
        notifyListeners();
        final t8 = Timer(const Duration(seconds: 2), () {
          chatMessages.add(
            {
              "id": "8",
              "question_hi":
                  "धन्यवाद \n हमारे कृषि विशेषज्ञ जल्द ही आपकी समस्या देखेंगे",
              "question_en": "Know about your crop with Agrichikitsa",
              "options_hi": [],
              "options_en": [],
              "isAnswerSelected": false,
              "answer": "",
              "isMe": false,
            },
          );
          setShowCameraButton(false);
          showSeventhBubbleLoader = false;
          showLastMessage = true;
          notifyListeners();
        });
        timmerInstances.add(t8);
      }
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }

  void uploadGallery(context) async {
    try {
      final imageFile = await Utils.pickImage();
      if (imageFile != null) {
        showCropImageLoader = true;
        notifyListeners();
        final data = await Utils.uploadImage(imageFile);
        cropImage = data["imgurl"];
        final index = chatMessages.indexWhere((chatMessage) {
          return chatMessage['id'] == cameraQuestionId;
        });
        if (index != -1) {
          final item = chatMessages[index];
          sendQuestion(cameraQuestionId, item['question_hi'], "", cropImage);
        }
        showCropImageLoader = false;
        showSeventhBubbleLoader = true;
        notifyListeners();
        final t8 = Timer(const Duration(seconds: 2), () {
          chatMessages.add(
            {
              "id": "8",
              "question_hi":
                  "धन्यवाद \n हमारे कृषि विशेषज्ञ जल्द ही आपकी समस्या देखेंगे",
              "question_en": "Know about your crop with Agrichikitsa",
              "options_hi": [],
              "options_en": [],
              "isAnswerSelected": false,
              "answer": "",
              "isMe": false,
            },
          );
          setShowCameraButton(false);
          showSeventhBubbleLoader = false;
          showLastMessage = true;
          notifyListeners();
        });
        timmerInstances.add(t8);
      }
    } catch (error) {
      Utils.flushBarErrorMessage("Alert!", error.toString(), context);
    }
  }
}
