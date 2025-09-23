import 'dart:developer';
import 'dart:io';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/chat.sections/chat_with_images.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/chat.sections/user_text_with_image.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/chat_loader.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/helper/custom_chat_button.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/helper/custom_text_bubble.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../../../utils/utils.dart';
import '../../chat_tab_view_model.dart';

class ChatScreen extends HookWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<ChatTabViewModel>(context, listen: false);
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final dimension = Utils.getDimensions(context, true);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.initialTask(context);
      });
      return null;
    }, []);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff018715),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      body: Consumer<ChatTabViewModel>(
        builder: (context, provider, child) {
          return provider.chatMessages.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<ChatTabViewModel>(builder: (context, provider, child) {
                      final message = provider.chatMessages[0];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        color: const Color(0xff05921A),
                        width: dimension['width'],
                        height: dimension['height']! * 0.07,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              profileViewModel.locale["language"] == "en"
                                  ? message["question_en"]
                                  : message["question_hi"],
                              textAlign: TextAlign.center,
                              textStyle: GoogleFonts.inter(
                                  color: AppColor.whiteColor,
                                  fontSize: profileViewModel.locale["language"] == "en" ? 14 : 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                          onTap: null,
                          isRepeatingAnimation: false,
                          totalRepeatCount: 1,
                        ),
                      );
                    }),
                    Expanded(
                      child: ListView.builder(
                        controller: useViewModel.scrollController,
                        itemCount: provider.chatMessages.length,
                        itemBuilder: (context, index) {
                          final message = provider.chatMessages[index];
                          if (index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                provider.showFirstBubbleLoader ? const ChatLoader() : Container()
                              ],
                            );
                          }
                          if (index == 1) {
                            return Column(
                              children: [
                                CustomTextBubble(
                                    text: profileViewModel.locale["language"] == "en"
                                        ? message["question_en"]
                                        : message["question_hi"],
                                    isSender: message["isMe"]),
                                const SizedBox(
                                  height: 6,
                                ),
                                provider.showSecondBubbleLoader ? const ChatLoader() : Container()
                              ],
                            );
                          }
                          //Age Select Category Box
                          if (index == 2) {
                            if (message["render"] != true) return const SizedBox.shrink();
                            return Column(
                              children: [
                                CustomTextBubble(
                                    text: profileViewModel.locale["language"] == "en"
                                        ? message["question_en"]
                                        : message["question_hi"],
                                    isSender: message["isMe"]),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: dimension['width']! - 32,
                                  height: dimension['height']! * 0.06,
                                  child: SingleChildScrollView(
                                    child: SizedBox(
                                      width: dimension['width']! - 32,
                                      height: dimension['height']! * 0.06,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: profileViewModel.locale["language"] == "en"
                                              ? message["options_en"].length
                                              : message["options_hi"].length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: message["isAnswerSelected"]
                                                  ? null
                                                  : () {
                                                      provider.selectAge(
                                                          context,
                                                          profileViewModel.locale["language"] ==
                                                                  "en"
                                                              ? message["options_en"][index]
                                                              : message["options_hi"][index],
                                                          message["id"]);
                                                    },
                                              child: CustomChatButton(
                                                text: profileViewModel.locale["language"] == "en"
                                                    ? message["options_en"][index]
                                                    : message["options_hi"][index],
                                                isSelected: provider.selectedAge ==
                                                        message["options_hi"][index]
                                                    ? true
                                                    : false,
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                message["isAnswerSelected"]
                                    ? CustomTextBubble(
                                        text: message["answer"],
                                        isSender: message["isAnswerSelected"],
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 16,
                                ),
                                provider.showThirdLoader ? const ChatLoader() : Container()
                              ],
                            );
                          }
                          //Select Crop Category
                          if (index == 3) {
                            return Column(
                              children: [
                                //Choose your crop question
                                CustomTextBubble(
                                  text: profileViewModel.locale["language"] == "en"
                                      ? message["question_en"]
                                      : message["question_hi"],
                                  isSender: message["isMe"],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                //List of Crop Categories
                                SizedBox(
                                  width: dimension['width']! - 32,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width: dimension['width']! - 32,
                                          height: dimension['height']! * 0.06,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: profileViewModel.locale["language"] == "en"
                                                  ? message["options_en"].length > 10
                                                      ? 10
                                                      : message["options_en"].length
                                                  : message["options_hi"].length > 10
                                                      ? 10
                                                      : message["options_hi"].length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: message["isAnswerSelected"]
                                                      ? null
                                                      : () {
                                                          provider.handleSelctCrop(
                                                              context,
                                                              profileViewModel.locale["language"] ==
                                                                      "en"
                                                                  ? message["options_en"][index]
                                                                  : message["options_hi"][index],
                                                              message["id"]);
                                                        },
                                                  child: CustomChatButton(
                                                    isCrops: true,
                                                    text:
                                                        profileViewModel.locale["language"] == "en"
                                                            ? message["options_en"][index]["name"]
                                                            : message["options_hi"][index]["name"],
                                                    isSelected: provider.selectedCropCategory ==
                                                            (profileViewModel.locale["language"] ==
                                                                    "en"
                                                                ? message["options_en"][index]
                                                                    ["name"]
                                                                : message["options_hi"][index]
                                                                    ["name"])
                                                        ? true
                                                        : false,
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      //In case more than 10 categories, a new row
                                      message["options_en"].length > 10 ||
                                              message["options_hi"].length > 10
                                          ? SingleChildScrollView(
                                              child: SizedBox(
                                                width: dimension['width']! - 32,
                                                height: dimension['height']! *
                                                    (profileViewModel.locale["language"] == "en"
                                                        ? 0.067
                                                        : 0.065),
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount:
                                                        profileViewModel.locale["language"] == "en"
                                                            ? message["options_en"].length - 10
                                                            : message["options_hi"].length - 10,
                                                    itemBuilder: (context, index) {
                                                      int currentIndex = index + 10;
                                                      return InkWell(
                                                        onTap: message["isAnswerSelected"]
                                                            ? null
                                                            : () {
                                                                provider.handleSelctCrop(
                                                                    context,
                                                                    profileViewModel.locale[
                                                                                "language"] ==
                                                                            "en"
                                                                        ? message["options_en"]
                                                                            [currentIndex]
                                                                        : message["options_hi"]
                                                                            [currentIndex],
                                                                    message["id"]);
                                                              },
                                                        child: CustomChatButton(
                                                          isCrops: true,
                                                          text:
                                                              profileViewModel.locale["language"] ==
                                                                      "en"
                                                                  ? message["options_en"]
                                                                      [currentIndex]["name"]
                                                                  : message["options_hi"]
                                                                      [currentIndex]["name"],
                                                          isSelected: provider
                                                                      .selectedCropCategory ==
                                                                  (profileViewModel
                                                                              .locale["language"] ==
                                                                          "en"
                                                                      ? message["options_en"]
                                                                          [currentIndex]["name"]
                                                                      : message["options_hi"]
                                                                          [currentIndex]["name"])
                                                              ? true
                                                              : false,
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                message["isAnswerSelected"]
                                    ? CustomTextBubble(
                                        text: message["answer"],
                                        isSender: message["isAnswerSelected"],
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 16,
                                ),
                                provider.showFourthLoader ? const ChatLoader() : Container()
                              ],
                            );
                          }
                          //Select Crop based on previously  selected category
                          if (index == 4) {
                            return Column(
                              children: [
                                CustomTextBubble(
                                  text: profileViewModel.locale["language"] == "en"
                                      ? message["question_en"]
                                      : message["question_hi"],
                                  isSender: message["isMe"],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: dimension['width']! - 32,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          width: dimension['width']! - 32,
                                          height: dimension['height']! * 0.06,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: profileViewModel.locale["language"] == "en"
                                                  ? message["options_en"].length > 10
                                                      ? 10
                                                      : message["options_en"].length
                                                  : message["options_hi"].length > 10
                                                      ? 10
                                                      : message["options_hi"].length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: message["isAnswerSelected"]
                                                      ? null
                                                      : () {
                                                          provider.handleSelctCategoriesdCrop(
                                                              context,
                                                              profileViewModel.locale["language"] ==
                                                                      "en"
                                                                  ? message["options_en"][index]
                                                                  : message["options_hi"][index],
                                                              message["id"]);
                                                        },
                                                  child: CustomChatButton(
                                                    isCrops: true,
                                                    text:
                                                        profileViewModel.locale["language"] == "en"
                                                            ? message["options_en"][index]["name"]
                                                            : message["options_hi"][index]["name"],
                                                    isSelected: provider.selectedCrop ==
                                                            (profileViewModel.locale["language"] ==
                                                                    "en"
                                                                ? message["options_en"][index]
                                                                    ["name"]
                                                                : message["options_hi"][index]
                                                                    ["name"])
                                                        ? true
                                                        : false,
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // For crops more than 10, new row
                                      message["options_en"].length > 10 ||
                                              message["options_hi"].length > 10
                                          ? SingleChildScrollView(
                                              child: SizedBox(
                                                width: dimension['width']! - 32,
                                                height: dimension['height']! *
                                                    (profileViewModel.locale["language"] == "en"
                                                        ? 0.067
                                                        : 0.065),
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount:
                                                        profileViewModel.locale["language"] == "en"
                                                            ? message["options_en"].length - 10
                                                            : message["options_hi"].length - 10,
                                                    itemBuilder: (context, index) {
                                                      int currentIndex = index + 10;
                                                      return InkWell(
                                                        onTap: message["isAnswerSelected"]
                                                            ? null
                                                            : () {
                                                                provider.handleSelctCategoriesdCrop(
                                                                    context,
                                                                    profileViewModel.locale[
                                                                                "language"] ==
                                                                            "en"
                                                                        ? message["options_en"]
                                                                            [currentIndex]
                                                                        : message["options_hi"]
                                                                            [currentIndex],
                                                                    message["id"]);
                                                              },
                                                        child: CustomChatButton(
                                                          isCrops: true,
                                                          text:
                                                              profileViewModel.locale["language"] ==
                                                                      "en"
                                                                  ? message["options_en"]
                                                                      [currentIndex]["name"]
                                                                  : message["options_hi"]
                                                                      [currentIndex]["name"],
                                                          isSelected: provider.selectedCrop ==
                                                                  (profileViewModel
                                                                              .locale["language"] ==
                                                                          "en"
                                                                      ? message["options_en"]
                                                                          [currentIndex]["name"]
                                                                      : message["options_hi"]
                                                                          [currentIndex]["name"])
                                                              ? true
                                                              : false,
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                message["isAnswerSelected"]
                                    ? CustomTextBubble(
                                        text: message["answer"],
                                        isSender: message["isAnswerSelected"],
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 16,
                                ),
                                provider.showFifthBubbleLoader ? const ChatLoader() : Container()
                              ],
                            );
                          }
                          //Crop Disease
                          if (index == 5) {
                            return Column(
                              children: [
                                CustomTextBubble(
                                  text: profileViewModel.locale["language"] == "en"
                                      ? message["question_en"]
                                      : message["question_hi"],
                                  isSender: message["isMe"],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: dimension['width']! - 32,
                                  height: 40,
                                  child: SingleChildScrollView(
                                    child: SizedBox(
                                      width: dimension['width']! - 32,
                                      height: 40,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: profileViewModel.locale["language"] == "en"
                                              ? message["options_en"].length
                                              : message["options_hi"].length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: message["isAnswerSelected"]
                                                  ? null
                                                  : () {
                                                      provider.selectCropDisease(
                                                          context,
                                                          profileViewModel.locale["language"] ==
                                                                  "en"
                                                              ? message["options_en"][index]
                                                              : message["options_hi"][index],
                                                          message["options_hi"][index],
                                                          message["id"]);
                                                    },
                                              child: CustomChatButton(
                                                text: profileViewModel.locale["language"] == "en"
                                                    ? message["options_en"][index]
                                                    : message["options_hi"][index],
                                                isSelected: provider.selectedReason ==
                                                        (profileViewModel.locale["language"] == "en"
                                                            ? message["options_en"][index]
                                                            : message["options_hi"][index])
                                                    ? true
                                                    : false,
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                message["isAnswerSelected"]
                                    ? CustomTextBubble(
                                        text: message["answer"],
                                        isSender: message["isAnswerSelected"],
                                      )
                                    : Container(),
                                provider.showSixthBubbleLoader ? const ChatLoader() : Container()
                              ],
                            );
                          }
                          //Shows additional options if any
                          if (index == 6) {
                            return Column(
                              children: [
                                (profileViewModel.locale["language"] == "en"
                                            ? message["question_en"]
                                            : message["question_hi"]) ==
                                        ""
                                    ? Container()
                                    : CustomTextBubble(
                                        text: profileViewModel.locale["language"] == "en"
                                            ? message["question_en"]
                                            : message["question_hi"],
                                        isSender: message["isMe"],
                                      ),
                                const SizedBox(
                                  height: 16,
                                ),
                                message["options_en"].length > 0 || message["options_hi"].length > 0
                                    ? SizedBox(
                                        width: dimension['width']! - 32,
                                        height: 40,
                                        child: SingleChildScrollView(
                                          child: SizedBox(
                                            width: dimension['width']! - 32,
                                            height: 40,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount:
                                                    profileViewModel.locale["language"] == "en"
                                                        ? message["options_en"].length
                                                        : message["options_hi"].length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap:
                                                        message["isAnswerSelected"] ? null : null,
                                                    child: CustomChatButton(
                                                      text: profileViewModel.locale["language"] ==
                                                              "en"
                                                          ? message["options_en"][index]
                                                          : message["options_hi"][index],
                                                      isSelected: false,
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: provider.selectedUserMessage.isNotEmpty ? 0 : 16,
                                ),
                                message["isAnswerSelected"]
                                    ? CustomTextBubble(
                                        text: message["answer"],
                                        isSender: message["isAnswerSelected"],
                                      )
                                    : Container(),
                                provider.showSeventhBubbleLoader ? const ChatLoader() : Container(),
                              ],
                            );
                          }
                          //Separates in 2 parts -> user input / only images flow
                          if (['अन्य', 'खरपतवार'].contains(provider.selectedDisease)) {
                            return UserMessageWithYesNo(
                                selectedUserMessage: provider.selectedUserMessage,
                                isChatCompleted: provider.isChatCompleted,
                                showCameraButton: provider.showCameraButton,
                                showCropImageLoader: provider.showCropImageLoader,
                                showSeventhBubbleLoader: provider.showSeventhBubbleLoader,
                                cropImage: provider.cropImage,
                                yesPressed: (_) {
                                  if (!(provider.showCameraButton || provider.isChatCompleted)) {
                                    provider.setImageAfterText(
                                      true,
                                      context,
                                      AppLocalization.of(context)
                                          .getTranslatedValue("yes")
                                          .toString(),
                                    );
                                  }
                                },
                                noPressed: (_) {
                                  if (!(provider.showCameraButton || provider.isChatCompleted)) {
                                    provider.setImageAfterText(
                                      false,
                                      context,
                                      AppLocalization.of(context)
                                          .getTranslatedValue("no")
                                          .toString(),
                                    );
                                  }
                                },
                                restartChat: () {
                                  if (!provider.chatRestartLoader) {
                                    provider.restartChat(context);
                                  }
                                },
                                message: message,
                                profileViewModel: profileViewModel,
                                chatViewModel: provider,
                                currentIndex: index,
                                showLastMessage: provider.showLastMessage,
                                chatRestartLoader: provider.chatRestartLoader);
                          } else {
                            return ChatWithImages(
                                isChatCompleted: provider.isChatCompleted,
                                message: message,
                                profileViewModel: profileViewModel,
                                chatViewModel: provider,
                                currentIndex: index,
                                chatRestartLoader: provider.chatRestartLoader,
                                showLastMessage: provider.showLastMessage,
                                restartChat: () {
                                  if (!provider.chatRestartLoader) {
                                    provider.restartChat(context);
                                  }
                                });
                          }
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
