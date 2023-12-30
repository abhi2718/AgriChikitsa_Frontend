import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/chat_loader.dart';
import 'package:agriChikitsa/screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/skeleton/skeleton.dart';
import '../../chat_tab_view_model.dart';

class ChatScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<ChatTabViewModel>(context, listen: false);
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final dimension = Utils.getDimensions(context, true);
    useEffect(() {
      useViewModel.initialTask(context);
    }, []);
    return Scaffold(
      body: Consumer<ChatTabViewModel>(
        builder: (context, provider, child) {
          return Column(
            children: [
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
                          provider.chatMessages.length > 1
                              ? BubbleSpecialThree(
                                  text: profileViewModel.locale["language"] == "en"
                                      ? message["question_en"]
                                      : message["question_hi"],
                                  color: AppColor.botText,
                                  tail: true,
                                  isSender: message["isMe"],
                                  textStyle: GoogleFonts.inter(
                                      color: AppColor.darkBlackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          profileViewModel.locale["language"] == "en" ? 14 : 16),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(left: 18),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  height: dimension['height']! * 0.073,
                                  width: dimension['width']! * 0.735,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColor.botText,
                                  ),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        profileViewModel.locale["language"] == "en"
                                            ? message["question_en"]
                                            : message["question_hi"],
                                        textStyle: GoogleFonts.inter(
                                            color: AppColor.darkBlackColor,
                                            fontSize: profileViewModel.locale["language"] == "en"
                                                ? 14
                                                : 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                    onTap: null,
                                    isRepeatingAnimation: false,
                                    totalRepeatCount: 1,
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          provider.showFirstBubbleLoader ? const ChatLoader() : Container()
                        ],
                      );
                    }
                    if (index == 1) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: profileViewModel.locale["language"] == "en"
                                ? message["question_en"]
                                : message["question_hi"],
                            color: AppColor.botText,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: GoogleFonts.inter(
                                color: AppColor.darkBlackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: profileViewModel.locale["language"] == "en" ? 14 : 16),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showSecondBubbleLoader ? const ChatLoader() : Container()
                        ],
                      );
                    }
                    if (index == 2) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: profileViewModel.locale["language"] == "en"
                                ? message["question_en"]
                                : message["question_hi"],
                            color: AppColor.botText,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: GoogleFonts.inter(
                                color: AppColor.darkBlackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: profileViewModel.locale["language"] == "en" ? 14 : 16),
                          ),
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
                                                    profileViewModel.locale["language"] == "en"
                                                        ? message["options_en"][index]
                                                        : message["options_hi"][index],
                                                    message["id"]);
                                              },
                                        child: BubbleSpecialThree(
                                          text: profileViewModel.locale["language"] == "en"
                                              ? message["options_en"][index]
                                              : message["options_hi"][index],
                                          color:
                                              provider.selectedAge == message["options_hi"][index]
                                                  ? AppColor.selectedOptionChatBot
                                                  : AppColor.chatSent,
                                          tail: false,
                                          isSender: false,
                                          textStyle: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.darkBlackColor,
                                              fontSize: profileViewModel.locale["language"] == "en"
                                                  ? 14
                                                  : 16),
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
                              ? BubbleSpecialThree(
                                  text: message["answer"],
                                  color: AppColor.userText,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.darkBlackColor,
                                      fontSize:
                                          profileViewModel.locale["language"] == "en" ? 14 : 16),
                                )
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showThirdLoader ? const ChatLoader() : Container()
                        ],
                      );
                    }
                    if (index == 3) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: profileViewModel.locale["language"] == "en"
                                ? message["question_en"]
                                : message["question_hi"],
                            color: AppColor.botText,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: AppColor.darkBlackColor,
                                fontSize: profileViewModel.locale["language"] == "en" ? 14 : 16),
                          ),
                          const SizedBox(
                            height: 16,
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
                                                    provider.handleSelctCrop(
                                                        context,
                                                        profileViewModel.locale["language"] == "en"
                                                            ? message["options_en"][index]
                                                            : message["options_hi"][index],
                                                        message["id"]);
                                                  },
                                            child: BubbleSpecialThree(
                                              text: profileViewModel.locale["language"] == "en"
                                                  ? message["options_en"][index]
                                                  : message["options_hi"][index],
                                              color: provider.selectedCrop ==
                                                      (profileViewModel.locale["language"] == "en"
                                                          ? message["options_en"][index]
                                                          : message["options_hi"][index])
                                                  ? AppColor.selectedOptionChatBot
                                                  : AppColor.chatSent,
                                              tail: false,
                                              isSender: false,
                                              textStyle: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.darkBlackColor,
                                                  fontSize:
                                                      profileViewModel.locale["language"] == "en"
                                                          ? 14
                                                          : 16),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                message["options_en"].length > 10 ||
                                        message["options_hi"].length > 10
                                    ? SingleChildScrollView(
                                        child: SizedBox(
                                          width: dimension['width']! - 32,
                                          height: dimension['height']! * 0.06,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: profileViewModel.locale["language"] == "en"
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
                                                              profileViewModel.locale["language"] ==
                                                                      "en"
                                                                  ? message["options_en"]
                                                                      [currentIndex]
                                                                  : message["options_hi"]
                                                                      [currentIndex],
                                                              message["id"]);
                                                        },
                                                  child: BubbleSpecialThree(
                                                    text:
                                                        profileViewModel.locale["language"] == "en"
                                                            ? message["options_en"][currentIndex]
                                                            : message["options_hi"][currentIndex],
                                                    color: provider.selectedCrop ==
                                                            (profileViewModel.locale["language"] ==
                                                                    "en"
                                                                ? message["options_en"]
                                                                    [currentIndex]
                                                                : message["options_hi"]
                                                                    [currentIndex])
                                                        ? AppColor.selectedOptionChatBot
                                                        : AppColor.chatSent,
                                                    tail: false,
                                                    isSender: false,
                                                    textStyle: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColor.darkBlackColor,
                                                        fontSize:
                                                            profileViewModel.locale["language"] ==
                                                                    "en"
                                                                ? 14
                                                                : 16),
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
                              ? BubbleSpecialThree(
                                  text: message["answer"],
                                  color: AppColor.userText,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.darkBlackColor,
                                      fontSize:
                                          profileViewModel.locale["language"] == "en" ? 14 : 16),
                                )
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showFourthLoader ? const ChatLoader() : Container()
                        ],
                      );
                    }
                    if (index == 4) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: profileViewModel.locale["language"] == "en"
                                ? message["question_en"]
                                : message["question_hi"],
                            color: AppColor.botText,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: AppColor.darkBlackColor,
                                fontSize: profileViewModel.locale["language"] == "en" ? 14 : 16),
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
                                                    profileViewModel.locale["language"] == "en"
                                                        ? message["options_en"][index]
                                                        : message["options_hi"][index],
                                                    message["options_hi"][index],
                                                    message["id"]);
                                              },
                                        child: BubbleSpecialThree(
                                          text: profileViewModel.locale["language"] == "en"
                                              ? message["options_en"][index]
                                              : message["options_hi"][index],
                                          color: provider.selectedReason ==
                                                  (profileViewModel.locale["language"] == "en"
                                                      ? message["options_en"][index]
                                                      : message["options_hi"][index])
                                              ? AppColor.selectedOptionChatBot
                                              : AppColor.chatSent,
                                          tail: false,
                                          isSender: false,
                                          textStyle: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.darkBlackColor,
                                              fontSize: profileViewModel.locale["language"] == "en"
                                                  ? 14
                                                  : 16),
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
                              ? BubbleSpecialThree(
                                  text: message["answer"],
                                  color: AppColor.userText,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.darkBlackColor,
                                      fontSize:
                                          profileViewModel.locale["language"] == "en" ? 14 : 16),
                                )
                              : Container(),
                          provider.showFifthBubbleLoader ? const ChatLoader() : Container()
                        ],
                      );
                    }
                    if (index == 5) {
                      return Column(
                        children: [
                          (profileViewModel.locale["language"] == "en"
                                      ? message["question_en"]
                                      : message["question_hi"]) ==
                                  ""
                              ? Container()
                              : BubbleSpecialThree(
                                  text: profileViewModel.locale["language"] == "en"
                                      ? message["question_en"]
                                      : message["question_hi"],
                                  color: AppColor.botText,
                                  tail: true,
                                  isSender: message["isMe"],
                                  textStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.darkBlackColor,
                                      fontSize:
                                          profileViewModel.locale["language"] == "en" ? 14 : 16),
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
                                          itemCount: profileViewModel.locale["language"] == "en"
                                              ? message["options_en"].length
                                              : message["options_hi"].length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: message["isAnswerSelected"] ? null : null,
                                              child: BubbleSpecialThree(
                                                text: profileViewModel.locale["language"] == "en"
                                                    ? message["options_en"][index]
                                                    : message["options_hi"][index],
                                                color: AppColor.chatSent,
                                                tail: false,
                                                isSender: false,
                                                textStyle: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.darkBlackColor,
                                                    fontSize:
                                                        profileViewModel.locale["language"] == "en"
                                                            ? 14
                                                            : 16),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          message["isAnswerSelected"]
                              ? BubbleSpecialThree(
                                  text: message["answer"],
                                  color: AppColor.userText,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize:
                                          profileViewModel.locale["language"] == "en" ? 14 : 16),
                                )
                              : Container(),
                          provider.showSixthBubbleLoader ? const ChatLoader() : Container(),
                        ],
                      );
                    }
                    if (index == 6) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: profileViewModel.locale["language"] == "en"
                                ? message["question_en"]
                                : message["question_hi"],
                            color: AppColor.botText,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: AppColor.darkBlackColor,
                                fontSize: profileViewModel.locale["language"] == "en" ? 14 : 16),
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
                                          itemCount: profileViewModel.locale["language"] == "en"
                                              ? message["options_en"].length
                                              : message["options_hi"].length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: message["isAnswerSelected"] ? null : null,
                                              child: BubbleSpecialThree(
                                                text: profileViewModel.locale["language"] == "en"
                                                    ? message["options_en"][index]
                                                    : message["options_hi"][index],
                                                color: AppColor.chatSent,
                                                tail: false,
                                                isSender: false,
                                                textStyle: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.darkBlackColor,
                                                    fontSize:
                                                        profileViewModel.locale["language"] == "en"
                                                            ? 14
                                                            : 16),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                )
                              : Container(),
                          message["isAnswerSelected"]
                              ? BubbleSpecialThree(
                                  text: message["answer"],
                                  color: AppColor.errorColor,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.darkBlackColor,
                                      fontSize:
                                          profileViewModel.locale["language"] == "en" ? 14 : 16),
                                )
                              : Container(),
                          provider.showFifthBubbleLoader ? const ChatLoader() : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showCropImageLoader
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
                                        color: AppColor.chatSent,
                                      ),
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
                          provider.cropImage != ""
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
                                        child: CachedNetworkImage(
                                          imageUrl: provider.cropImage,
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) => Skeleton(
                                            height: dimension['height']! * 0.40,
                                            width: dimension['width']! * 0.6,
                                            radius: 8,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          height: dimension['height']! * 0.40,
                                          width: dimension['width']! * 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      );
                    }
                    if (index == 7) {
                      return Column(
                        children: [
                          provider.showSeventhBubbleLoader ? const ChatLoader() : Container(),
                          message["question_hi"].isNotEmpty
                              ? BubbleSpecialThree(
                                  text: profileViewModel.locale["language"] == "en"
                                      ? message["question_en"]
                                      : message["question_hi"],
                                  color: AppColor.botText,
                                  tail: true,
                                  isSender: message["isMe"],
                                  textStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.darkBlackColor,
                                      fontSize:
                                          profileViewModel.locale["language"] == "en" ? 14 : 16),
                                )
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showLastMessage
                              ? AnimatedTextKit(
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      AppLocalization.of(context)
                                          .getTranslatedValue("chatBotEndTagline")
                                          .toString(),
                                      textStyle: GoogleFonts.inter(
                                          fontSize:
                                              profileViewModel.locale["language"] == "en" ? 14 : 16,
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
                          provider.isChatCompleted ? const Divider() : Container(),
                          provider.isChatCompleted
                              ? ElevatedButton(
                                  onPressed: () => provider.initialTask(context),
                                  child: Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValue("restartChat")
                                        .toString(),
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500, color: AppColor.extraDark),
                                  ))
                              : Container(),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                      );
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
