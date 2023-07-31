import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../res/color.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/skeleton/skeleton.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../notification_view_model.dart';

class ChatHistory extends HookWidget {
  dynamic notificationItem;
  ChatHistory({super.key, required this.notificationItem});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final useViewModel = useMemoized(
        () => Provider.of<NotificationViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.fetchChatHistory(context, notificationItem['relatedTo']);
    }, []);
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25.5),
        height: dimension['height']! - 220,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back)),
                BaseText(
                  title: AppLocalizations.of(context)!.chatHistory,
                  style: const TextStyle(fontSize: 20),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Remix.close_circle_line,
                  ),
                ),
              ],
            ),
            Consumer<NotificationViewModel>(
                builder: (context, provider, child) {
              return provider.chatLoader
                  ? SizedBox(
                      height: dimension['height']! - 300,
                      child: const Center(child: CircularProgressIndicator()))
                  : useViewModel.chatHistoryList.isEmpty
                      ? SizedBox(
                          height: dimension['height']! - 180,
                          child: Center(
                            child: BaseText(
                                title: AppLocalizations.of(context)!
                                    .noChatHistoryhi,
                                style: const TextStyle()),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListView.builder(
                              itemCount: useViewModel
                                  .chatHistoryList['allChats'].length,
                              itemBuilder: (context, index) {
                                final chatItem = useViewModel
                                    .chatHistoryList['allChats'][index];
                                return chatItem['answer'] == "None"
                                    ? const BubbleSpecialThree(
                                        text: "Pending Reply...",
                                        color: Colors.transparent,
                                        tail: true,
                                        isSender: false,
                                        textStyle: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: AppColor.iconColor,
                                            fontSize: 16),
                                      )
                                    : chatItem['adminReply']
                                        ? SizedBox(
                                            child: Column(
                                              children: [
                                                chatItem.containsKey(
                                                        'imageQuestion')
                                                    ? SizedBox(
                                                        child: Column(
                                                          children: [
                                                            BubbleSpecialThree(
                                                              text: chatItem[
                                                                  'question'],
                                                              color: AppColor
                                                                  .chatBubbleColor,
                                                              tail: true,
                                                              isSender: false,
                                                              textStyle: const TextStyle(
                                                                  color: AppColor
                                                                      .whiteColor,
                                                                  fontSize: 16),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      right: 16,
                                                                      bottom:
                                                                          10),
                                                                  height: dimension[
                                                                          'height']! *
                                                                      0.40,
                                                                  width: dimension[
                                                                          'width']! *
                                                                      0.6,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          'https://d336izsd4bfvcs.cloudfront.net/${chatItem['imageQuestion'].split('https://agrichikitsaimagebucket.s3.ap-south-1.amazonaws.com/')[1]}',
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          Skeleton(
                                                                        height: dimension['height']! *
                                                                            0.40,
                                                                        width: dimension['width']! *
                                                                            0.6,
                                                                        radius:
                                                                            8,
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height: dimension[
                                                                              'height']! *
                                                                          0.40,
                                                                      width: dimension[
                                                                              'width']! *
                                                                          0.6,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            BubbleSpecialThree(
                                                              text: chatItem[
                                                                  'answer'],
                                                              color: AppColor
                                                                  .chatBubbleColor,
                                                              tail: true,
                                                              isSender: false,
                                                              textStyle: const TextStyle(
                                                                  color: AppColor
                                                                      .whiteColor,
                                                                  fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        child: Column(
                                                          children: [
                                                            BubbleSpecialThree(
                                                              text: chatItem[
                                                                  'question'],
                                                              color: AppColor
                                                                  .chatSent,
                                                              tail: false,
                                                              isSender: true,
                                                              textStyle: const TextStyle(
                                                                  color: AppColor
                                                                      .darkBlackColor,
                                                                  fontSize: 16),
                                                            ),
                                                            BubbleSpecialThree(
                                                              text: chatItem[
                                                                  'answer'],
                                                              color: AppColor
                                                                  .chatBubbleColor,
                                                              tail: true,
                                                              isSender: false,
                                                              textStyle: const TextStyle(
                                                                  color: AppColor
                                                                      .whiteColor,
                                                                  fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            child: Column(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: BubbleSpecialThree(
                                                text: chatItem['question'],
                                                color: AppColor.chatBubbleColor,
                                                tail: true,
                                                isSender: false,
                                                textStyle: const TextStyle(
                                                    color: AppColor.whiteColor,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            BubbleSpecialThree(
                                              text: chatItem['answer'],
                                              color: AppColor.chatSent,
                                              tail: false,
                                              isSender: true,
                                              textStyle: const TextStyle(
                                                  color:
                                                      AppColor.darkBlackColor,
                                                  fontSize: 16),
                                            ),
                                          ]));
                              }),
                        ));
            })
          ],
        ));
  }
}
