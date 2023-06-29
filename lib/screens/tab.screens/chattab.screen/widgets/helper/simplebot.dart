import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/chat_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
                  itemCount: provider.chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = provider.chatMessages[index];
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          provider.chatMessages.length > 1
                              ? BubbleSpecialThree(
                                  text: message["question_hi"],
                                  color: AppColor.chatBubbleColor,
                                  tail: true,
                                  isSender: message["isMe"],
                                  textStyle: const TextStyle(
                                      color: AppColor.whiteColor, fontSize: 16),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(left: 18),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  height: dimension['height']! * 0.073,
                                  width: dimension['width']! * 0.735,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColor.chatBubbleColor,
                                  ),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        message["question_hi"],
                                        textStyle: const TextStyle(
                                            color: AppColor.whiteColor,
                                            fontSize: 16,
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
                          provider.showFirstBubbleLoader
                              ? const ChatLoader()
                              : Container()
                        ],
                      );
                    }
                    if (index == 1) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: AppColor.chatBubbleColor,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: const TextStyle(
                                color: AppColor.whiteColor, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showSecondBubbleLoader
                              ? const ChatLoader()
                              : Container()
                        ],
                      );
                    }
                    if (index == 2) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: AppColor.chatBubbleColor,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: const TextStyle(
                                color: AppColor.whiteColor, fontSize: 16),
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
                                    itemCount: message["options_hi"].length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: message["isAnswerSelected"]
                                            ? null
                                            : () {
                                                provider.selectAge(
                                                    context,
                                                    message["options_hi"]
                                                        [index],
                                                    message["id"]);
                                              },
                                        child: BubbleSpecialThree(
                                          text: message["options_hi"][index],
                                          color: AppColor.chatSent,
                                          tail: false,
                                          isSender: false,
                                          textStyle: const TextStyle(
                                              color: AppColor.darkBlackColor,
                                              fontSize: 16),
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
                                  color: AppColor.chatSent,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: const TextStyle(
                                      color: AppColor.darkBlackColor,
                                      fontSize: 16),
                                )
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showThirdLoader
                              ? const ChatLoader()
                              : Container()
                        ],
                      );
                    }
                    if (index == 3) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: AppColor.chatBubbleColor,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: const TextStyle(
                                color: AppColor.whiteColor, fontSize: 16),
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
                                    itemCount: message["options_hi"].length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: message["isAnswerSelected"]
                                            ? null
                                            : () {
                                                provider.handleSelctCrop(
                                                    context,
                                                    message["options_hi"]
                                                        [index],
                                                    message["id"]);
                                              },
                                        child: BubbleSpecialThree(
                                          text: message["options_hi"][index],
                                          color: AppColor.chatSent,
                                          tail: false,
                                          isSender: false,
                                          textStyle: const TextStyle(
                                              color: AppColor.darkBlackColor,
                                              fontSize: 16),
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
                                  color: AppColor.chatSent,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: const TextStyle(
                                      color: AppColor.darkBlackColor,
                                      fontSize: 16),
                                )
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showFourthLoader
                              ? const ChatLoader()
                              : Container()
                        ],
                      );
                    }
                    if (index == 4) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: AppColor.chatBubbleColor,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: const TextStyle(
                                color: AppColor.whiteColor, fontSize: 16),
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
                                    itemCount: message["options_hi"].length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: message["isAnswerSelected"]
                                            ? null
                                            : () {
                                                provider.selectCropDisease(
                                                    context,
                                                    message["options_hi"]
                                                        [index],
                                                    message["id"]);
                                              },
                                        child: BubbleSpecialThree(
                                          text: message["options_hi"][index],
                                          color: AppColor.chatSent,
                                          tail: false,
                                          isSender: false,
                                          textStyle: const TextStyle(
                                              color: AppColor.darkBlackColor,
                                              fontSize: 16),
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
                                  color: AppColor.chatSent,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: const TextStyle(
                                      color: AppColor.darkBlackColor,
                                      fontSize: 16),
                                )
                              : Container(),
                          provider.showFifthBubbleLoader
                              ? const ChatLoader()
                              : Container()
                        ],
                      );
                    }
                    if (index == 5) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: AppColor.chatBubbleColor,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: const TextStyle(
                                color: AppColor.whiteColor, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          message["options_hi"].length > 0
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
                                              message["options_hi"].length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: message["isAnswerSelected"]
                                                  ? null
                                                  : null,
                                              child: BubbleSpecialThree(
                                                text: message["options_hi"]
                                                    [index],
                                                color: AppColor.chatSent,
                                                tail: false,
                                                isSender: false,
                                                textStyle: const TextStyle(
                                                    color:
                                                        AppColor.darkBlackColor,
                                                    fontSize: 16),
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
                                  color: AppColor.chatSent,
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                )
                              : Container(),
                          provider.showSixthBubbleLoader
                              ? const ChatLoader()
                              : Container(),
                          message["showCameraIcon"] == null
                              ? Container()
                              : Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.camera),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                        ],
                      );
                    }
                    if (index == 6) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: AppColor.darkColor,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: const TextStyle(
                                color: AppColor.whiteColor, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          message["options_hi"].length > 0
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
                                              message["options_hi"].length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: message["isAnswerSelected"]
                                                  ? null
                                                  : null,
                                              child: BubbleSpecialThree(
                                                text: message["options_hi"]
                                                    [index],
                                                color: AppColor.chatSent,
                                                tail: false,
                                                isSender: false,
                                                textStyle: const TextStyle(
                                                    color:
                                                        AppColor.darkBlackColor,
                                                    fontSize: 16),
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
                                  textStyle: const TextStyle(
                                      color: AppColor.darkBlackColor,
                                      fontSize: 16),
                                )
                              : Container(),
                          provider.showFifthBubbleLoader
                              ? const ChatLoader()
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showCropImageLoader
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 20, bottom: 10),
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
                                          animationDuration:
                                              const Duration(milliseconds: 200),
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
                                      margin: const EdgeInsets.only(
                                          right: 16, bottom: 10),
                                      height: dimension['height']! * 0.40,
                                      width: dimension['width']! * 0.6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://d336izsd4bfvcs.cloudfront.net/${provider.cropImage.split('https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1]}',
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Skeleton(
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
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      );
                    }
                    if (index == 7) {
                      return Column(
                        children: [
                          provider.showSeventhBubbleLoader
                              ? const ChatLoader()
                              : Container(),
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: AppColor.chatBubbleColor,
                            tail: true,
                            isSender: message["isMe"],
                            textStyle: const TextStyle(
                                color: AppColor.whiteColor, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showLastMessage
                              ? AnimatedTextKit(
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      "फसलों की सुरक्षा एग्री-चिकित्सा",
                                      textStyle: const TextStyle(
                                          fontSize: 16,
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
