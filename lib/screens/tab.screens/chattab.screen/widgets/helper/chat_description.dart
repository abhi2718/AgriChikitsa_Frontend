import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/skeleton/skeleton.dart';
import '../../../../../widgets/text.widgets/text.dart';

class ChatDescription extends HookWidget {
  const ChatDescription({super.key, required this.chat});
  final dynamic chat;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<ChatTabViewModel>(context, listen: false));
    useEffect(() {
      useViewModel.fetchChatHistory(context, chat['_id']);
    }, []);
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25.5),
        height: dimension['height']! - 160,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).pop(), child: const Icon(Icons.arrow_back)),
                BaseText(
                  title:
                      AppLocalization.of(context).getTranslatedValue("chatHistoryTitle").toString(),
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Remix.close_circle_line,
                  ),
                ),
              ],
            ),
            Consumer<ChatTabViewModel>(builder: (context, provider, child) {
              return provider.chatHistoryLoader
                  ? SizedBox(
                      height: dimension['height']! - 300,
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: AppColor.extraDark,
                      )))
                  : useViewModel.chatMessagesList.isEmpty
                      ? SizedBox(
                          height: dimension['height']! - 180,
                          child: Center(
                            child: BaseText(
                                title: AppLocalization.of(context)
                                    .getTranslatedValue("noChatHistoryFound")
                                    .toString(),
                                style: const TextStyle()),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView.builder(
                                itemCount: useViewModel.chatMessagesList['allChats'].length,
                                itemBuilder: (context, index) {
                                  final chatItem = useViewModel.chatMessagesList['allChats'][index];
                                  return chatItem['answer'] == "None"
                                      ? BubbleSpecialThree(
                                          text: AppLocalization.of(context)
                                              .getTranslatedValue("pendingReplyText")
                                              .toString(),
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
                                                  chatItem.containsKey('imageQuestion')
                                                      ? SizedBox(
                                                          child: Column(
                                                            children: [
                                                              BubbleSpecialThree(
                                                                text: chatItem['question'],
                                                                color: AppColor.chatBubbleColor,
                                                                tail: true,
                                                                isSender: false,
                                                                textStyle: const TextStyle(
                                                                    color: AppColor.whiteColor,
                                                                    fontSize: 16),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.end,
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets.only(
                                                                        right: 16, bottom: 10),
                                                                    height:
                                                                        dimension['height']! * 0.40,
                                                                    width:
                                                                        dimension['width']! * 0.6,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(8),
                                                                    ),
                                                                    child: ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(8),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: chatItem[
                                                                            'imageQuestion'],
                                                                        progressIndicatorBuilder:
                                                                            (context, url,
                                                                                    downloadProgress) =>
                                                                                Skeleton(
                                                                          height:
                                                                              dimension['height']! *
                                                                                  0.40,
                                                                          width:
                                                                              dimension['width']! *
                                                                                  0.6,
                                                                          radius: 8,
                                                                        ),
                                                                        errorWidget: (context, url,
                                                                                error) =>
                                                                            const Icon(Icons.error),
                                                                        fit: BoxFit.cover,
                                                                        height:
                                                                            dimension['height']! *
                                                                                0.40,
                                                                        width: dimension['width']! *
                                                                            0.6,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              BubbleSpecialThree(
                                                                text: chatItem['answer'],
                                                                color: AppColor.chatBubbleColor,
                                                                tail: true,
                                                                isSender: false,
                                                                textStyle: const TextStyle(
                                                                    color: AppColor.whiteColor,
                                                                    fontSize: 16),
                                                              ),
                                                              chat['imgurl'] != null
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment.centerLeft,
                                                                      child: Container(
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 8,
                                                                            horizontal: 8),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(8)),
                                                                        height:
                                                                            dimension['height']! *
                                                                                0.40,
                                                                        width: dimension['width']! *
                                                                            0.6,
                                                                        child: ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  8),
                                                                          child: CachedNetworkImage(
                                                                            imageUrl:
                                                                                chat['imgurl'],
                                                                            fit: BoxFit.fill,
                                                                            placeholder:
                                                                                (context, url) =>
                                                                                    Skeleton(
                                                                              height: dimension[
                                                                                      "height"]! *
                                                                                  0.4,
                                                                              width: dimension[
                                                                                      "width"]! *
                                                                                  0.6,
                                                                              radius: 10,
                                                                            ),
                                                                            errorWidget: (context,
                                                                                    url, error) =>
                                                                                const Icon(
                                                                                    Icons.error),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          child: Column(
                                                            children: [
                                                              BubbleSpecialThree(
                                                                text: chatItem['question'],
                                                                color: AppColor.chatSent,
                                                                tail: false,
                                                                isSender: true,
                                                                textStyle: const TextStyle(
                                                                    color: AppColor.darkBlackColor,
                                                                    fontSize: 16),
                                                              ),
                                                              BubbleSpecialThree(
                                                                text: chatItem['answer'],
                                                                color: AppColor.chatBubbleColor,
                                                                tail: true,
                                                                isSender: false,
                                                                textStyle: const TextStyle(
                                                                    color: AppColor.whiteColor,
                                                                    fontSize: 16),
                                                              ),
                                                              chat['imgurl'] != null
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment.centerLeft,
                                                                      child: Container(
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 8,
                                                                            horizontal: 8),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(8)),
                                                                        height:
                                                                            dimension['height']! *
                                                                                0.40,
                                                                        width: dimension['width']! *
                                                                            0.6,
                                                                        child: ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  8),
                                                                          child: CachedNetworkImage(
                                                                            imageUrl:
                                                                                chat['imgurl'],
                                                                            fit: BoxFit.fill,
                                                                            placeholder:
                                                                                (context, url) =>
                                                                                    Skeleton(
                                                                              height: dimension[
                                                                                      "height"]! *
                                                                                  0.4,
                                                                              width: dimension[
                                                                                      "width"]! *
                                                                                  0.6,
                                                                              radius: 10,
                                                                            ),
                                                                            errorWidget: (context,
                                                                                    url, error) =>
                                                                                const Icon(
                                                                                    Icons.error),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                        )
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              child: Column(children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: BubbleSpecialThree(
                                                  text: chatItem['question'],
                                                  color: AppColor.chatBubbleColor,
                                                  tail: true,
                                                  isSender: false,
                                                  textStyle: const TextStyle(
                                                      color: AppColor.whiteColor, fontSize: 16),
                                                ),
                                              ),
                                              BubbleSpecialThree(
                                                text: chatItem['answer'],
                                                color: AppColor.chatSent,
                                                tail: false,
                                                isSender: true,
                                                textStyle: const TextStyle(
                                                    color: AppColor.darkBlackColor, fontSize: 16),
                                              ),
                                            ]));
                                }),
                          ),
                        );
            })
          ],
        ));
    // return Container(
    //   padding: const EdgeInsets.only(left: 16, right: 16, top: 25.5),
    //   height: dimension['height']! - 160,
    //   child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           InkWell(
    //               onTap: () => Navigator.of(context).pop(), child: const Icon(Icons.arrow_back)),
    //           BaseText(
    //             title: AppLocalizations.of(context)!.chatHistory,
    //             style: const TextStyle(fontSize: 20),
    //           ),
    //           InkWell(
    //             onTap: () => Navigator.of(context).pop(),
    //             child: const Icon(
    //               Remix.close_circle_line,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
