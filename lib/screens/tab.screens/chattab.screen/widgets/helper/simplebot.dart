import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:jumping_dot/jumping_dot.dart';
import '../../../../../utils/utils.dart';
import '../../chat_tab_view_model.dart';

class ChatScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<ChatTabViewModel>(context, listen: false);
    final dimension = Utils.getDimensions(context, true);
    useEffect(() {
      useViewModel.initialTask();
      useViewModel.loadGreating("Abhishek Singh");
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
                                  color: Color(0xFF1B97F3),
                                  tail: true,
                                  isSender: message["isMe"],
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              : AnimatedTextKit(
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      message["question_hi"],
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                  onTap: null,
                                  isRepeatingAnimation: false,
                                  totalRepeatCount: 1,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          provider.showFirstBubbleLoader
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    JumpingDots(
                                      color: Colors.green,
                                      radius: 4,
                                      numberOfDots: 3,
                                      animationDuration:
                                          const Duration(milliseconds: 200),
                                    )
                                  ],
                                )
                              : Container()
                        ],
                      );
                    }
                    if (index == 1) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: Color(0xFF1B97F3),
                            tail: true,
                            isSender: message["isMe"],
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          provider.showSecondBubbleLoader
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    JumpingDots(
                                      color: Colors.green,
                                      radius: 4,
                                      numberOfDots: 3,
                                      animationDuration:
                                          const Duration(milliseconds: 200),
                                    )
                                  ],
                                )
                              : Container()
                        ],
                      );
                    }
                    if (index == 2) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: Color(0xFF1B97F3),
                            tail: true,
                            isSender: message["isMe"],
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
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
                                                    message["options_hi"]
                                                        [index],
                                                    message["id"]);
                                              },
                                        child: BubbleSpecialThree(
                                          text: message["options_hi"][index],
                                          color: Color(0xFFE8E8EE),
                                          tail: false,
                                          isSender: false,
                                          textStyle: TextStyle(
                                              color: Colors.black,
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
                                  color: Color(0xFFE8E8EE),
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                )
                              : Container(),
                              const SizedBox(height: 16,),
                              provider.showFourthLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    JumpingDots(
                                      color: Colors.green,
                                      radius: 4,
                                      numberOfDots: 3,
                                      animationDuration:
                                          const Duration(milliseconds: 200),
                                    )
                                  ],
                                )
                              : Container()
                        ],
                      );
                    }
                    if (index == 3) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: message["question_hi"],
                            color: Color(0xFF1B97F3),
                            tail: true,
                            isSender: message["isMe"],
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
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
                                                    message["options_hi"]
                                                        [index],
                                                    message["id"]);
                                              },
                                        child: BubbleSpecialThree(
                                          text: message["options_hi"][index],
                                          color: Color(0xFFE8E8EE),
                                          tail: false,
                                          isSender: false,
                                          textStyle: TextStyle(
                                              color: Colors.black,
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
                                  color: Color(0xFFE8E8EE),
                                  tail: false,
                                  isSender: message["isAnswerSelected"],
                                  textStyle: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                )
                              : Container(),
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 60,
                width: dimension["width"],
                child: Container(
                  color: Colors.red,
                  child: TextField(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
