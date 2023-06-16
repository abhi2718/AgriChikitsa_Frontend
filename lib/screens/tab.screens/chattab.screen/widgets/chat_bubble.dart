import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../model/bot_message_model.dart';
import '../chat_tab_view_model.dart';

class ChatBubbles extends HookWidget {
  const ChatBubbles.first(
      {super.key,
      required this.userImage,
      required this.message,
      required this.isMe,
      this.options})
      : isFirstInSequence = true;
  const ChatBubbles.next(
      {super.key, required this.message, required this.isMe, this.options})
      : isFirstInSequence = false,
        userImage = null;
  final bool isFirstInSequence;
  final String? userImage;
  final String message;
  final bool isMe;
  final List? options;

  Widget buildOptions(BuildContext context, List<Option> options) {
    final useViewModel =
        useMemoized(() => Provider.of<ChatTabViewModel>(context, listen: true));
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options
              .map((option) => InkWell(
                    onTap: () {
                      useViewModel.setMessageFieldOption(option.optionHi);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.chatBubbleColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: BaseText(
                          title: option.optionHi,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.darkBlackColor,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: BaseText(
                        title: message,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.darkBlackColor),
                      )),
                  if (options!.isNotEmpty)
                    buildOptions(context, options!.cast<Option>())
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
