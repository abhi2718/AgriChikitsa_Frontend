import 'dart:io';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/chat_loader.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/helper/custom_text_bubble.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';
import 'package:jumping_dot/jumping_dot.dart';

class UserMessageWithYesNo extends StatelessWidget {
  final String selectedUserMessage;
  final bool isChatCompleted;
  final bool showCameraButton;
  final bool showCropImageLoader;
  final bool showSeventhBubbleLoader;
  final String cropImage;
  final void Function(bool) yesPressed;
  final void Function(bool) noPressed;
  final void Function() restartChat;

  final dynamic message;
  final ProfileViewModel profileViewModel;
  final ChatTabViewModel chatViewModel;
  final int currentIndex;
  final bool showLastMessage;
  final bool chatRestartLoader;

  const UserMessageWithYesNo(
      {super.key,
      required this.selectedUserMessage,
      required this.isChatCompleted,
      required this.showCameraButton,
      required this.showCropImageLoader,
      required this.showSeventhBubbleLoader,
      required this.cropImage,
      required this.yesPressed,
      required this.noPressed,
      required this.message,
      required this.profileViewModel,
      required this.chatViewModel,
      required this.currentIndex,
      required this.chatRestartLoader,
      required this.showLastMessage,
      required this.restartChat});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    final dimension = Utils.getDimensions(context, true);
    if (currentIndex == 7) {
      children.add(Column(
        children: [
          //Question -> Want to add image
          CustomTextBubble(
            text: profileViewModel.locale["language"] == "en"
                ? message["question_en"]
                : message["question_hi"],
            isSender: message["isMe"],
          ),
          SizedBox(
            height: selectedUserMessage.isNotEmpty ? 0 : 16,
          ),
          //Yes/No Buttons below question
          selectedUserMessage.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 70.0),
                  child: Row(
                    children: [
                      isChatCompleted || showCameraButton
                          ? const SizedBox.shrink()
                          : TextButton(
                              onPressed: showCameraButton || isChatCompleted
                                  ? null
                                  : () => yesPressed(true),
                              style: TextButton.styleFrom(
                                backgroundColor: AppColor.whiteColor,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Text(
                                AppLocalization.of(context).getTranslatedValue("yes").toString(),
                                style: const TextStyle(color: AppColor.extraDark),
                              ),
                            ),
                      const SizedBox(width: 8),
                      isChatCompleted || showCameraButton
                          ? const SizedBox.shrink()
                          : TextButton(
                              onPressed: showCameraButton || isChatCompleted
                                  ? null
                                  : () => noPressed(false),
                              style: TextButton.styleFrom(
                                backgroundColor: AppColor.whiteColor,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Text(
                                AppLocalization.of(context).getTranslatedValue("no").toString(),
                                style: const TextStyle(color: AppColor.extraDark),
                              ),
                            )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          showCropImageLoader
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20, bottom: 10),
                      padding: const EdgeInsets.only(
                        top: 14,
                      ),
                      height: dimension['height']! * 0.05,
                      width: dimension['width']! * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color: AppColor.chatSent,
                          color: AppColor.whiteColor),
                      child: Center(
                        child: JumpingDots(
                          color: AppColor.darkColor,
                          radius: 4,
                          numberOfDots: 3,
                          animationDuration: const Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ));
    }
    //Yes/No with/without Image
    if (currentIndex == 8) {
      children.add(Column(
        children: [
          CustomTextBubble(
            text: chatViewModel.uploadImageAfterUserMessage
                ? AppLocalization.of(context).getTranslatedValue("yes").toString()
                : AppLocalization.of(context).getTranslatedValue("no").toString(),
            isSender: true,
          ),
          const SizedBox(
            height: 16,
          ),
          cropImage != ""
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 16, bottom: 10),
                      height: dimension['height']! * 0.40,
                      width: dimension['width']! * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(cropImage),
                          fit: BoxFit.cover,
                          height: dimension['height']! * 0.40,
                          width: dimension['width']! * 0.6,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          //Loader After Img - upload to server going on
          chatViewModel.showNinethBubbleLoader ? const ChatLoader() : Container(),
        ],
      ));
    }
    //Thankyou Messages
    if (currentIndex == 9) {
      children.add(Column(
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
          showLastMessage
              ? AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      AppLocalization.of(context)
                          .getTranslatedValue("chatBotEndTagline")
                          .toString(),
                      textStyle: GoogleFonts.inter(
                          fontSize: profileViewModel.locale["language"] == "en" ? 14 : 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                  onTap: null,
                  isRepeatingAnimation: false,
                  totalRepeatCount: 1,
                )
              : Container(),
          const SizedBox(
            height: 4,
          ),
          isChatCompleted ? const Divider() : Container(),
          isChatCompleted
              ? InkWell(
                  onTap: restartChat,
                  child: GradientButton(
                    isLoading: chatRestartLoader,
                    title: AppLocalization.of(context).getTranslatedValue("restartChat").toString(),
                    height: dimension["height"]! * 0.06,
                    width: dimension["width"]! * 0.3,
                  ))
              : Container(),
          const SizedBox(
            height: 8,
          )
        ],
      ));
    }
    return Column(
      children: children,
    );
  }
}
