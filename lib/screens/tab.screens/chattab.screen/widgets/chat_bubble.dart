import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles.first(
      {super.key,
      required this.userImage,
      required this.message,
      required this.isMe})
      : isFirstInSequence = true;
  const ChatBubbles.next({super.key, required this.message, required this.isMe})
      : isFirstInSequence = false,
        userImage = null;
  final bool isFirstInSequence;
  final String? userImage;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence)
                    const SizedBox(
                      height: 18,
                    ),
                  Container(
                      decoration: BoxDecoration(
                        color:
                            isMe ? AppColor.chatSent : AppColor.chatBubbleColor,
                        borderRadius: BorderRadius.only(
                          topLeft: !isMe && isFirstInSequence
                              ? Radius.zero
                              : const Radius.circular(12),
                          topRight: isMe && isFirstInSequence
                              ? Radius.zero
                              : const Radius.circular(12),
                          bottomLeft: const Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        ),
                      ),
                      constraints: const BoxConstraints(maxWidth: 246),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      // margin:
                      //     const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      child: BaseText(
                        title: message,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.darkBlackColor),
                      ))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
