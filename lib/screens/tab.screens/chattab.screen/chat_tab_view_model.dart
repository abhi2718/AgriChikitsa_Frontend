import 'dart:async';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool chatRestartLoader = false;
  bool showFirstBubbleLoader = false;
  bool showSecondBubbleLoader = false;
  bool showThirdLoader = false;
  bool showFourthLoader = false;
  bool showFifthBubbleLoader = false;
  bool showSixthBubbleLoader = false;
  bool showSeventhBubbleLoader = false;
  bool showEightBubbleLoader = false;
  bool showNinethBubbleLoader = false;
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
  String selectedAgCrop = "";
  String selectedAgCropCategory = "";
  String selectedReason = "";
  String selectedUserMessage = "";
  bool uploadImageAfterUserMessage = false;
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

  var chatMessages = [];

  //Feedback
  bool isFeedbackLoading = false;
  double chatRating = 3.5;
  TextEditingController userFeedbackController = TextEditingController();

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
    selectedUserMessage = "";
    enableKeyBoard = false;
    questionAsked = "";
    chatMessages.clear();
    questionIndex = 0;
    timmerInstances.forEach((timer) {
      timer.cancel();
    });
    textEditingController.clear();
    timmerInstances.clear();
    chatHistoryLoader = false;
    chatLoader = false;
    isChatCompleted = false;
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
    showCropImage2Loader = false;
    uploadImageAfterUserMessage = false;
    cropImage = "";
    cropImage2 = "";
    selectedDisease = '';
    cameraQuestionId = '';
    selectedAge = "";
    selectedCrop = "";
    selectedCropCategory = "";
    selectedAgCrop = "";
    selectedAgCropCategory = "";
    selectedReason = "";
    imageConfirm = null;
    imageFile = null;
    imageFile2 = null;
    isSecondTry = false;
    isFeedbackLoading = false;
    userFeedbackController.clear();
    chatRating = 3.5;
  }

  void disposeValues() {
    clearAge();
  }

  void enableKeyboard(bool value) {
    enableKeyBoard = value;
    notifyListeners();
  }

  void setChatHistoryLoader(bool value) {
    chatHistoryLoader = value;
    notifyListeners();
  }

  void setChatRestartLoader(bool value) {
    chatRestartLoader = value;
    notifyListeners();
  }

  void setImageCheck(bool value, BuildContext context, String? selectedOption) async {
    imageConfirm = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    notifyListeners();
    if (imageConfirm!) {
      chatMessages.add(
        {
          "id": "9",
          "question_hi": "",
          "question_en": "",
          "options_hi": [],
          "options_en": [],
          "isAnswerSelected": true,
          "answer": selectedOption,
          "isMe": false,
        },
      );
      notifyListeners();
      isSecondTry = true;
      setShowCameraButton(true);
    } else {
      isSecondTry = false;
      uploadImageToServer(context);
    }
  }

  void setChatLoader(bool value) {
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
    setChatHistoryLoader(false);
  }

  void restartChat(BuildContext context) {
    setChatHistoryLoader(true);
    timmerInstances.forEach((timer) {
      timer.cancel();
    });
    initialTask(context);
  }

  void sendQuestion() async {
    final userImageAttachments = [];
    if (cropImageBucketPath.isNotEmpty) userImageAttachments.add(cropImageBucketPath);
    if (cropImage2.isNotEmpty) userImageAttachments.add(cropImage2);
    final payloadStructure = {
      "ageGroup": selectedAge,
      "crop": selectedCrop,
      "cropCategory": selectedCropCategory,
      "cropAg": selectedAgCrop,
      "cropCategoryAg": selectedAgCropCategory,
      "problemSection": selectedReason,
      if (selectedUserMessage.trim().isNotEmpty) "userMessage": selectedUserMessage,
      if (cropImage2.isNotEmpty) "userImageAttachment": cropImage2,
      if (userImageAttachments.isNotEmpty) "userImageAttachments": userImageAttachments
    };
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
      final age = await getSelectedAge();
      if (age == null) {
        final t2 = Timer(const Duration(seconds: 1), () {
          fetchSecondQuestion(context, "2");
        });
        timmerInstances.add(t2);
      } else {
        chatMessages.add({'render': false, 'id': 2});
        selectedAge = age;
        loadQuestionFour(context);
      }
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

  Future<String?> getSelectedAge() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('age')) {
      String? selectedAge = prefs.getString('age');
      return selectedAge;
    }
    return null;
  }

  Future<void> setAge(String age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('age', age);
  }

  Future<void> clearAge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('age');
  }

  void fetchSecondQuestion(BuildContext context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add({...data["question"], 'render': true});
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
    setAge(selectedAge);
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
      showSecondBubbleLoader = false;
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

  void handleSelctCrop(context, Map<String, dynamic> crop, String id) {
    var updatedChatMessages = chatMessages.map((item) {
      if (item['id'] == id) {
        return {
          ...item,
          "isAnswerSelected": true,
          "answer": crop["name"],
        };
      }
      return item;
    });
    selectedCropCategory = crop["name"];
    selectedAgCropCategory = crop["id"];
    questionIndex = 4;
    chatMessages = updatedChatMessages.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    showFourthLoader = true;
    notifyListeners();
    final t5 = Timer(const Duration(seconds: 1), () {
      fetchFouthQuestion(context, "4", selectedAgCropCategory);
      notifyListeners();
    });
    timmerInstances.add(t5);
  }

  void fetchFouthQuestion(BuildContext context, String id, String cropCategoryId) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id, cropCategoryId);
      chatMessages.add(data["question"]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showFourthLoader = false;
      notifyListeners();
    } catch (error) {
      showFourthLoader = false;
      notifyListeners();
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void handleSelctCategoriesdCrop(context, Map<String, dynamic> crop, String id) {
    var updatedChatMessages = chatMessages.map((item) {
      if (item['id'] == id) {
        return {
          ...item,
          "isAnswerSelected": true,
          "answer": crop["name"],
        };
      }
      return item;
    });
    selectedCrop = crop["name"];
    selectedAgCrop = crop["id"];
    questionIndex = 5;
    chatMessages = updatedChatMessages.toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    showFifthBubbleLoader = true;
    notifyListeners();
    final t6 = Timer(const Duration(seconds: 1), () {
      fetchFifthQuestion(context, "5");
      questionIndex = 5;
      notifyListeners();
    });
    timmerInstances.add(t6);
  }

  void fetchFifthQuestion(BuildContext context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showFifthBubbleLoader = false;
      notifyListeners();
    } catch (error) {
      showFifthBubbleLoader = false;
      notifyListeners();
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
    showSixthBubbleLoader = true;
    notifyListeners();
    final t6 = Timer(const Duration(seconds: 1), () {
      fetchSixthQuestion(context, disease);
    });
    timmerInstances.add(t6);
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
      final checkList = ['अन्य', 'खरपतवार'];
      if (!checkList.contains(id)) {
        final isToShowCameraIcon = question["showCameraIcon"] == null ? false : true;
        if (!isToShowCameraIcon) {
          showSeventhBubbleLoader = true;
          notifyListeners();
          final t7 = Timer(const Duration(seconds: 1), () {
            fetchSeventhQuestion(context, '6${question["id"]}');
          });
          timmerInstances.add(t7);
        }
      } else {
        enableKeyboard(true);
      }
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

  void fetchSeventhQuestion(context, String id) async {
    try {
      final data = await _chatTabRepository.fetchBotQuestion(id);
      chatMessages.add(data["question"]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
      showSeventhBubbleLoader = false;
      final question = data["question"];
      final isToShowCameraIcon = question["showCameraIcon"] == null ? false : true;
      if (isToShowCameraIcon) {
        setShowCameraButton(true);
        cameraQuestionId = id;
      }
      notifyListeners();
    } catch (error) {
      showSeventhBubbleLoader = false;
      notifyListeners();
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
        handleSelctCrop(
            context, {"id": "", "name": textEditingController.text}, currentQuestion["id"]);
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
        textEditingController.clear();
        showSeventhBubbleLoader = true;
        notifyListeners();
        final t7 = Timer(const Duration(seconds: 1), () {
          chatMessages.add(
            {
              "id": "8",
              "question_hi": "क्या आप इसके साथ कोई फोटो भेजना चाहते हैं?",
              "question_en": "Do you want to attach any photo with this?",
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
          notifyListeners();
        });
        timmerInstances.add(t7);
      }
    }
  }

  void uploadImage(context) async {
    try {
      if (isSecondTry) {
        if (!context.mounted) return;
        imageFile2 = await Utils.capturePhoto();
        if (imageFile2 == null) {
          return;
        }
      } else {
        if (!context.mounted) return;
        imageFile = await Utils.capturePhoto();
        if (imageFile == null) {
          return;
        }
      }
      setShowCameraButton(false);
      if (isSecondTry) {
        if (imageFile2 != null) {
          showNinethBubbleLoader = true;
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          showNinethBubbleLoader = true;
          notifyListeners();
          uploadImage2ToServer(context);
          notifyListeners();
        }
      } else {
        if (imageFile != null) {
          showCropImageLoader = true;
          notifyListeners();

          cropImage = imageFile.path;
          showCropImageLoader = false;
          if (!uploadImageAfterUserMessage) {
            showEightBubbleLoader = true;
          }
          notifyListeners();
          if (selectedUserMessage.isEmpty) {
            final t8 = Timer(const Duration(seconds: 1), () {
              chatMessages.add(
                {
                  "id": "8",
                  "question_hi": "क्या आप इसके साथ एक और फोटो भेजना चाहते हैं?",
                  "question_en": "Do you want to attach another photo with this?",
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
              if (!uploadImageAfterUserMessage) {
                showEightBubbleLoader = false;
              }
              notifyListeners();
            });
            timmerInstances.add(t8);
          } else {
            enableKeyboard(false);
            isChatCompleted = true;
            notifyListeners();
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
      setShowCameraButton(false);
      if (isSecondTry) {
        if (imageFile2 != null) {
          showSeventhBubbleLoader = true;
          showNinethBubbleLoader = true;
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          showNinethBubbleLoader = true;
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
          if (!uploadImageAfterUserMessage) {
            showEightBubbleLoader = true;
          }
          notifyListeners();
          if (selectedUserMessage.isEmpty) {
            final t8 = Timer(const Duration(seconds: 1), () {
              chatMessages.add(
                {
                  "id": "8",
                  "question_hi": "क्या आप इसके साथ एक और फोटो भेजना चाहते हैं?",
                  "question_en": "Do you want to attach another photo with this?",
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
              if (!uploadImageAfterUserMessage) {
                showEightBubbleLoader = false;
              }
              notifyListeners();
            });
            timmerInstances.add(t8);
          } else {
            enableKeyboard(false);
            isChatCompleted = true;
            notifyListeners();
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
      showNinethBubbleLoader = true;
      isChatCompleted = true;
      notifyListeners();
      final data = await Utils.uploadImage(imageFile);
      cropImageBucketPath = data["imgurl"]!;
      if (selectedUserMessage.isNotEmpty) {
        showEightBubbleLoader = false;
        notifyListeners();
      }
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
        showNinethBubbleLoader = false;
        showLastMessage = true;
        isChatCompleted = true;
        sendQuestion();
        notifyListeners();
      });
      timmerInstances.add(t9);
    } catch (error) {
      showSeventhBubbleLoader = false;
      showNinethBubbleLoader = false;
      showLastMessage = true;
      isChatCompleted = true;
      sendQuestion();
      notifyListeners();
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
      showNinethBubbleLoader = true;
      notifyListeners();
      final data = await Utils.uploadImage(imageFile2);
      cropImage2 = data["imgurl"]!;
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
        showNinethBubbleLoader = false;
        showLastMessage = true;
        isChatCompleted = true;
        sendQuestion();
        notifyListeners();
      });
      timmerInstances.add(t9);
    } catch (error) {
      showCropImage2Loader = false;
      showNinethBubbleLoader = false;
      showLastMessage = true;
      isChatCompleted = true;
      sendQuestion();
      notifyListeners();
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

  void setImageAfterText(bool value, BuildContext context, String selectedOption) {
    enableKeyboard(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    notifyListeners();
    if (value) {
      chatMessages.add(
        {
          "id": "8",
          "question_hi": "",
          "question_en": "",
          "options_hi": [],
          "options_en": [],
          "isAnswerSelected": true,
          "answer": selectedOption,
          "isMe": false,
        },
      );
      uploadImageAfterUserMessage = true;
      notifyListeners();
      enableKeyboard(false);
      setShowCameraButton(true);
      return;
    } else {
      showNinethBubbleLoader = true;
      uploadImageAfterUserMessage = false;
      notifyListeners();
      chatMessages.add(
        {
          "id": "8",
          "question_hi": "",
          "question_en": "",
          "options_hi": [],
          "options_en": [],
          "isAnswerSelected": true,
          "answer": selectedOption,
          "isMe": false,
        },
      );
      chatMessages.add(
        {
          "id": "9",
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
      showNinethBubbleLoader = false;
      notifyListeners();
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

  void setIsFeedbackLoader(bool value) {
    isFeedbackLoading = value;
    notifyListeners();
  }

  void setChatRating(double value) {
    chatRating = value;
  }

  Future<dynamic> sendChatFeedback(BuildContext context, String chatId) async {
    setIsFeedbackLoader(true);
    try {
      final payloadStructure = {
        "rating": chatRating,
        if (userFeedbackController.text.trim().isNotEmpty)
          "feedback": userFeedbackController.text.trim(),
      };
      final data = await _chatTabRepository.postchatRating(chatId, payloadStructure);
      chatRating = 3.5;
      userFeedbackController.clear();
      setIsFeedbackLoader(false);
      return data;
    } catch (e) {
      setIsFeedbackLoader(false);
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              e.toString(),
              context);
        }
      }
      return {"success": false};
    }
  }
}
