import 'dart:async';
import 'dart:developer';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../repository/chat_tab.repo/chat_tab_repository.dart';
import '../../../repository/notification.repo/notification_tab_repository.dart';

class ChatTabViewModel with ChangeNotifier {
  final _chatTabRepository = ChatTabRepository();
  final textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  dynamic timmerInstances = [];
  dynamic chatHistoryList = [];
  dynamic chatMessagesList = {};
  bool isChatCompleted = false;
  bool chatHistoryLoader = false;
  bool chatLoader = false;
  bool showFirstBubbleLoader = false;
  bool showSecondBubbleLoader = false;
  bool showThirdLoader = false;
  bool showCategoriesdCropLoader = false;
  bool showFourthLoader = false;
  bool showFifthBubbleLoader = false;
  bool showSixthBubbleLoader = false;
  bool showSeventhBubbleLoader = false;
  bool showLastMessage = false;
  bool showCropImageLoader = false;
  bool showCropImage2Loader = false;
  bool showCameraButton = false;
  bool enableKeyBoard = false;
  bool? imageConfirm;
  bool isSecondTry = false;
  dynamic imageFile;
  dynamic imageFile2;
  String selectedAge = "";
  String selectedCrop = "";
  String selectedCropCategory = "";
  String selectedReason = "";
  String selectedUserMessage = "";
  var questionAsked = "";
  var cropImage = "";
  var cropImageBucketPath = "";
  var cropImage2 = "";
  var questionIndex = 0;
  var selectedDisease = '';
  var cameraQuestionId = '';

  final dynamic questions = [
    {
      "id": "1",
      "question_hi": "🍃अपनी फसल के स्वास्थ्य के बारे में जाने, एग्रीचिकित्सा के साथ।",
      "question_en": "Know about health of your crop with Agrichikitsa",
      "isMe": false,
    }
  ];

  final dynamic categorisedCrops = {
    "Grains": {
      "options_en": [
        "Wheat",
        "Rice (Paddy)",
        "Maize",
        "Barley",
        "Pearl Millet (Bajra)",
      ],
      "options_hi": ["गेहूँ", "धान", "मक्का", "जौ", "बाजरा"],
    },
    'Pulses': {
      'options_en': [
        "Pigeon Pea (Arhar)",
        "Chickpea (Chana)",
        "Black Gram (Urad)",
        "Lentil (Masoor)",
        "Green Gram (Moong)",
        "Kidney Bean (Rajma)",
      ],
      'options_hi': ["अरहर", "चना", "उड़द", "मसूर", "मूंग", "राजमा"],
    },
    'Oilseeds': {
      'options_en': [
        "Mustard",
        "Soybean",
        "Groundnut (Peanut)",
        "Linseed (Flaxseed)",
        "Sesame",
      ],
      'options_hi': ["सरसों", "सोयाबीन", "मूंगफली", "अलसी", "तिल"],
    },
    'Vegetables': {
      'options_en': [
        "Potato",
        "Tomato",
        "Cauliflower",
        "Cabbage",
        "Brinjal (Eggplant)",
        "Okra (Lady Finger)",
        "Bitter Gourd",
        "Peas",
        "Chili",
        "Capsicum (Bell Pepper)",
        "Onion",
        "Carrot",
        "Beetroot",
        "Ginger",
        "Cucumber",
      ],
      'options_hi': [
        "आलू",
        "टमाटर",
        "फूलगोभी",
        "पत्तागोभी",
        "बैंगन",
        "भिंडी",
        "करेला",
        "मटर",
        "मिर्च",
        "शिमलामिर्च",
        "प्याज",
        "गाजर",
        "चुकंदर",
        "अदरक",
        "खीरा",
      ],
    },
    'Spices': {
      'options_en': [
        "Garlic",
        "Ginger",
        "Turmeric",
        "Cumin",
        "Carom Seeds (Ajwain)",
      ],
      'options_hi': ["लहसुन", "अदरक", "हल्दी", "जीरा", "अजवायन"],
    },
    'Fruits': {
      'options_en': [
        "Mango",
        "Guava",
        "Banana",
        "Grapes",
        "Lemon",
        "Orange",
        "Pomegranate",
      ],
      'options_hi': ["आम", "अमरूद", "केला", "अंगूर", "नींबू", "संतरा", "अनार"],
    },
  };
  var chatMessages = [];
  void setShowCameraButton(bool value) {
    showCameraButton = value;
  }

  void unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void goBack(BuildContext context) {
    unfocusKeyboard();
    reinitilize(context);
    Navigator.pop(context);
  }

  void reinitilize(BuildContext context) {
    timmerInstances.forEach((timer) {
      timer.cancel();
    });
    selectedUserMessage = "";
    enableKeyBoard = false;
    questionAsked = "";
    chatMessages.clear();
    questionIndex = 0;
    textEditingController.clear();
    timmerInstances.clear();
    chatHistoryLoader = false;
    chatLoader = false;
    isChatCompleted = false;
    showFirstBubbleLoader = false;
    showSecondBubbleLoader = false;
    showThirdLoader = false;
    showCategoriesdCropLoader = false;
    showFourthLoader = false;
    showFifthBubbleLoader = false;
    showSixthBubbleLoader = false;
    showSeventhBubbleLoader = false;
    showLastMessage = false;
    showCameraButton = false;
    showCropImageLoader = false;
    showCropImage2Loader = false;
    cropImage = "";
    cropImage2 = "";
    selectedDisease = '';
    cameraQuestionId = '';
    selectedAge = "";
    selectedCrop = "";
    selectedCropCategory = "";
    selectedReason = "";
    imageConfirm = null;
    imageFile = null;
    imageFile2 = null;
    isSecondTry = false;
  }

  void enableKeyboard(bool value) {
    enableKeyBoard = value;
    notifyListeners();
  }

  setChatHistoryLoader(value) {
    chatHistoryLoader = value;
  }

  setImageCheck(bool value, BuildContext context) async {
    imageConfirm = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    notifyListeners();
    if (imageConfirm!) {
      isSecondTry = false;
      uploadImageToServer(context);
    } else {
      isSecondTry = true;
      setShowCameraButton(true);
    }
  }

  setChatLoader(value) {
    chatLoader = value;
  }

  void getAllChatHistory(BuildContext context) async {
    setChatLoader(true);
    try {
      final data = await _chatTabRepository.getChatHistory();
      chatHistoryList = data;
      setChatLoader(false);
      notifyListeners();
    } catch (error) {
      setChatLoader(false);
      if (context.mounted) {
        Utils.flushBarErrorMessage("Umm!", "Some Error Occured", context);
        if (kDebugMode) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }

  void fetchChatHistory(BuildContext context, String id) async {
    setChatHistoryLoader(true);
    try {
      chatMessagesList.clear();
      final data = await NotificationTabRepository().fetchChatScript(id);
      chatMessagesList = data;
      setChatHistoryLoader(false);
      notifyListeners();
    } catch (error) {
      setChatHistoryLoader(false);
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }

  void initialTask(context) {
    reinitilize(context);
    if (chatMessages.isEmpty) {
      chatMessages.add(questions[0]);
      showFirstBubbleLoader = true;
      final t1 = Timer(const Duration(seconds: 1), () {
        fetchFirstQuestion(context, "1");
      });
      timmerInstances.add(t1);
    }
  }

  void sendQuestion() async {
    final userImageAttachments = [];
    if (cropImageBucketPath.isNotEmpty) userImageAttachments.add(cropImageBucketPath);
    if (cropImage2.isNotEmpty) userImageAttachments.add(cropImage2);
    final payloadStructure = {
      "ageGroup": selectedAge,
      "crop": selectedCrop,
      "cropCategory": selectedCropCategory,
      "problemSection": selectedReason,
      if (selectedUserMessage.trim().isNotEmpty) "userMessage": selectedUserMessage,
      if (cropImage2.isNotEmpty) "userImageAttachment": cropImage2,
      if (userImageAttachments.isNotEmpty) "userImageAttachments": userImageAttachments
    };
    if (kDebugMode) {
      log(payloadStructure.toString());
    }
    await _chatTabRepository.postChatQuestion(payloadStructure);
  }

  void markChatAsOpened(String chatId) async {
    final payloadStructure = {
      "isOpened": true,
    };
    await _chatTabRepository.markChatAsOpened(payloadStructure, chatId);
  }

  void fetchFirstQuestion(BuildContext context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showFirstBubbleLoader = false;
      showSecondBubbleLoader = true;
      notifyListeners();
      final t2 = Timer(const Duration(seconds: 1), () {
        fetchSecondQuestion(context, "2");
      });
      timmerInstances.add(t2);
    } catch (error) {
      showSecondBubbleLoader = false;
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void fetchSecondQuestion(BuildContext context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showSecondBubbleLoader = false;
      notifyListeners();
    } catch (error) {
      showSecondBubbleLoader = false;
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
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
    selectedAge = age;
    chatMessages = updatedChatMessages.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    notifyListeners();
    loadQuestionFour(context);
  }

  void loadQuestionFour(context) {
    showThirdLoader = true;
    notifyListeners();
    final t4 = Timer(const Duration(seconds: 1), () {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showThirdLoader = false;
      notifyListeners();
    } catch (error) {
      showThirdLoader = false;
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void handleSelctCrop(context, String category, String crop, String id) {
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
    selectedCropCategory = crop;
    questionIndex = 4;
    chatMessages = updatedChatMessages.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    showCategoriesdCropLoader = true;
    notifyListeners();
    final t5 = Timer(const Duration(seconds: 1), () {
      fetchCategoriesCrops(context, category);
      notifyListeners();
    });
    timmerInstances.add(t5);
  }

  void fetchCategoriesCrops(BuildContext context, String category) async {
    try {
      final selectedCategory = categorisedCrops[category];

      if (selectedCategory == null) {
        throw Exception("Category not found: $category");
      }

      final data = {
        "question": {
          "id": "999",
          "question_en": "Please select your crop",
          "question_hi": "कृपया अपनी फसल चुनें",
          "options_en": selectedCategory["options_en"],
          "options_hi": selectedCategory["options_hi"],
          "isAnswerSelected": false,
          "isMe": false,
          "answer": "",
        }
      };
      Timer(const Duration(seconds: 2), () {
        chatMessages.add(data["question"]);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
        showCategoriesdCropLoader = false;
        notifyListeners();
      });
    } catch (error) {
      showCategoriesdCropLoader = false;
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
          AppLocalization.of(context).getTranslatedValue("alert").toString(),
          error.toString(),
          context,
        );
      }
    }
  }

  void handleSelctCategoriesdCrop(context, String crop, String id) {
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
    selectedCrop = crop;
    questionIndex = 4;
    chatMessages = updatedChatMessages.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    showFourthLoader = true;
    notifyListeners();
    final t5 = Timer(const Duration(seconds: 1), () {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showFourthLoader = false;
      notifyListeners();
    } catch (error) {
      showFourthLoader = false;
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void selectCropDisease(context, String selectedOption, String disease, String id) {
    selectedDisease = disease;
    var updatedChatMessages = chatMessages.map((item) {
      if (item['id'] == id) {
        return {
          ...item,
          "isAnswerSelected": true,
          "answer": selectedOption,
        };
      }
      return item;
    });
    selectedReason = selectedOption;
    questionIndex = 6;
    chatMessages = updatedChatMessages.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    showFifthBubbleLoader = true;
    notifyListeners();
    final t6 = Timer(const Duration(seconds: 1), () {
      fetchFifthQuestion(context, disease);
    });
    timmerInstances.add(t6);
  }

  void fetchFifthQuestion(context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showFifthBubbleLoader = false;
      final question = data["question"];
      final checkList = ['अन्य', 'खरपतवार'];
      if (!checkList.contains(id)) {
        final isToShowCameraIcon = question["showCameraIcon"] == null ? false : true;
        if (!isToShowCameraIcon) {
          showSixthBubbleLoader = true;
          final t7 = Timer(const Duration(seconds: 1), () {
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
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void fetchSixthQuestion(context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showSixthBubbleLoader = false;
      final question = data["question"];
      final isToShowCameraIcon = question["showCameraIcon"] == null ? false : true;
      if (isToShowCameraIcon) {
        setShowCameraButton(true);
        cameraQuestionId = id;
      }
      if (!isToShowCameraIcon) {}
      notifyListeners();
    } catch (error) {
      showSixthBubbleLoader = false;
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void handleUserInput(context) {
    if (textEditingController.text.isNotEmpty) {
      unfocusKeyboard();
      if (questionIndex == 3) {
        final currentQuestion = chatMessages[questionIndex];
        handleSelctCrop(context, "", textEditingController.text, currentQuestion["id"]);
        textEditingController.clear();
        questionIndex = 4;
        showFourthLoader = true;
        notifyListeners();
        final t5 = Timer(const Duration(seconds: 1), () {
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
            selectedUserMessage = textEditingController.text;
            return {
              ...item,
              "isAnswerSelected": true,
              "answer": textEditingController.text,
            };
          }
          return item;
        });
        chatMessages = updatedChatMessages.toList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
        selectedDisease = '';
        textEditingController.clear();
        showSixthBubbleLoader = true;
        notifyListeners();
        final t7 = Timer(const Duration(seconds: 1), () {
          chatMessages.add(
            {
              "id": "8",
              "question_hi": "क्या आप इसके साथ फोटो भेजना चाहते हैं?",
              "question_en": "Do you want to send a photo with this?",
              "options_hi": [],
              "options_en": [],
              "isAnswerSelected": false,
              "answer": "",
              "isMe": false,
            },
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          showSixthBubbleLoader = false;
          notifyListeners();
        });
        timmerInstances.add(t7);
      }
    }
  }

  void uploadImage(context) async {
    try {
      if (isSecondTry) {
        imageFile2 = await Utils.capturePhoto();
        if (imageFile2 == null) {
          return;
        }
      } else {
        imageFile = await Utils.capturePhoto();
        if (imageFile == null) {
          return;
        }
      }
      setShowCameraButton(false);
      if (isSecondTry) {
        if (imageFile2 != null) {
          showSeventhBubbleLoader = true;
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          showSeventhBubbleLoader = true;
          notifyListeners();
          uploadImage2ToServer(context);
          notifyListeners();
        }
      } else {
        if (imageFile != null) {
          cropImage = imageFile.path;
          showCropImageLoader = true;
          notifyListeners();
          showCropImageLoader = false;
          notifyListeners();
          if (selectedUserMessage.isEmpty) {
            final t8 = Timer(const Duration(seconds: 1), () {
              chatMessages.add(
                {
                  "id": "8",
                  "question_hi": "क्या आप इस फोटो के साथ आगे बढ़ना चाहते हैं?",
                  "question_en": "Are you sure you want to proceed with this image?",
                  "options_hi": [],
                  "options_en": [],
                  "isAnswerSelected": false,
                  "answer": "",
                  "isMe": false,
                },
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollController.jumpTo(scrollController.position.maxScrollExtent);
              });
              notifyListeners();
            });
            timmerInstances.add(t8);
          } else {
            enableKeyboard(false);
            uploadImageToServer(context);
          }
        }
      }
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void uploadGallery(context) async {
    try {
      if (isSecondTry) {
        imageFile2 = await Utils.pickImage();
        if (imageFile2 == null) {
          return;
        }
      } else {
        imageFile = await Utils.pickImage();
        if (imageFile == null) {
          return;
        }
      }
      enableKeyboard(false);
      setShowCameraButton(false);
      if (isSecondTry) {
        if (imageFile2 != null) {
          showSeventhBubbleLoader = true;
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          uploadImage2ToServer(context);
          notifyListeners();
        }
      } else {
        if (imageFile != null) {
          cropImage = imageFile.path;
          showCropImageLoader = true;
          notifyListeners();
          showCropImageLoader = false;
          notifyListeners();

          if (selectedUserMessage.isEmpty) {
            final t8 = Timer(const Duration(seconds: 1), () {
              chatMessages.add(
                {
                  "id": "8",
                  "question_hi": "क्या आप इस फोटो के साथ आगे बढ़ना चाहते हैं?",
                  "question_en": "Are you sure you want to proceed with this image?",
                  "options_hi": [],
                  "options_en": [],
                  "isAnswerSelected": false,
                  "answer": "",
                  "isMe": false,
                },
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollController.jumpTo(scrollController.position.maxScrollExtent);
              });
              notifyListeners();
            });
            timmerInstances.add(t8);
          } else {
            enableKeyboard(false);
            uploadImageToServer(context);
          }
        }
      }
    } catch (error) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void uploadImageToServer(BuildContext context) async {
    try {
      showSeventhBubbleLoader = true;
      notifyListeners();
      final data = await Utils.uploadImage(imageFile);
      cropImageBucketPath = data["imgurl"];
      final t9 = Timer(const Duration(seconds: 1), () {
        chatMessages.add(
          {
            "id": "10",
            "question_hi": "धन्यवाद 🙏\n हमारे कृषि विशेषज्ञ जल्द ही आपकी समस्या देखेंगे",
            "question_en": " Thank you 🙏\n Our experts will look into your problem soon",
            "options_hi": [],
            "options_en": [],
            "isAnswerSelected": false,
            "answer": "",
            "isMe": false,
          },
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
        showSeventhBubbleLoader = false;
        showLastMessage = true;
        isChatCompleted = true;
        sendQuestion();
        notifyListeners();
      });
      timmerInstances.add(t9);
    } catch (error) {
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }

  void uploadImage2ToServer(BuildContext context) async {
    try {
      showSeventhBubbleLoader = true;
      notifyListeners();
      final data = await Utils.uploadImage(imageFile2);
      cropImage2 = data["imgurl"];
      final t9 = Timer(const Duration(seconds: 1), () {
        chatMessages.add(
          {
            "id": "10",
            "question_hi": "धन्यवाद 🙏\n हमारे कृषि विशेषज्ञ जल्द ही आपकी समस्या देखेंगे",
            "question_en": " Thank you 🙏\n Our experts will look into your problem soon",
            "options_hi": [],
            "options_en": [],
            "isAnswerSelected": false,
            "answer": "",
            "isMe": false,
          },
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
        showCropImage2Loader = false;
        showSeventhBubbleLoader = false;
        showLastMessage = true;
        isChatCompleted = true;
        sendQuestion();
        notifyListeners();
      });
      timmerInstances.add(t9);
    } catch (error) {
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }

  setImageAfterText(bool value, BuildContext context) {
    enableKeyboard(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    notifyListeners();
    if (value) {
      setShowCameraButton(true);
      return;
    } else {
      chatMessages.add(
        {
          "id": "10",
          "question_hi": "धन्यवाद 🙏\n हमारे कृषि विशेषज्ञ जल्द ही आपकी समस्या देखेंगे",
          "question_en": " Thank you 🙏\n Our experts will look into your problem soon",
          "options_hi": [],
          "options_en": [],
          "isAnswerSelected": false,
          "answer": "",
          "isMe": false,
        },
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showLastMessage = true;
      isChatCompleted = true;
      sendQuestion();
      notifyListeners();
    }
  }

  void deleteChatHistory(BuildContext context, String chatId) async {
    try {
      await _chatTabRepository.deleteChatHistory(chatId);
    } catch (e) {
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              e.toString(),
              context);
        }
      }
    }
  }
}
