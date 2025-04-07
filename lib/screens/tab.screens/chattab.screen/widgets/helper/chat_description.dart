import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/skeleton/skeleton.dart';
import '../../../../../widgets/text.widgets/text.dart';

class ChatDescription extends HookWidget {
  ChatDescription({super.key, required this.chat, this.isFromNotifications = false});
  final dynamic chat;
  bool isFromNotifications = false;
  // Future<void> _createPDF(BuildContext ctx) async {
  //   PdfDocument document = PdfDocument();
  //   final page = document.pages.add();

  //   final pageWidth = page.getClientSize().width;

  //   // Add Age message (Left-aligned)
  //   _drawLeftAlignedBubble(
  //     page: page,
  //     // text: 'कृपया अपनी आयु सीमा चुनें।',
  //     text: 'Please select your age.',
  //     top: 10,
  //     bubbleColor: PdfColor(139, 195, 74),
  //     pageWidth: pageWidth,
  //   );

  //   // Add User response (Right-aligned)
  //   _drawRightAlignedBubble(
  //     page: page,
  //     // text: '#30 साल से कम',
  //     text: 'Less than 30',
  //     top: 50,
  //     bubbleColor: PdfColor(238, 238, 238),
  //     pageWidth: pageWidth,
  //   );

  //   // Add Crop request (Left-aligned)
  //   _drawLeftAlignedBubble(
  //     page: page,
  //     // text: 'कृपया अपनी फसल चुनें',
  //     text: 'Please select your crop.',
  //     top: 90,
  //     bubbleColor: PdfColor(139, 195, 74),
  //     pageWidth: pageWidth,
  //   );

  //   // Add User response (Right-aligned)
  //   _drawRightAlignedBubble(
  //     page: page,
  //     // text: 'धान',
  //     text: 'Wheat',
  //     top: 130,
  //     bubbleColor: PdfColor(238, 238, 238),
  //     pageWidth: pageWidth,
  //   );

  //   // Add Thanks message (Left-aligned)
  //   _drawLeftAlignedBubble(
  //     page: page,
  //     // text: 'अपनी फसल चुनने के लिए धन्यवाद, कृपया अपनी फसल की समस्या चुनें',
  //     text: 'Thankyou for choosing your crop, please select the problem you are facing.',
  //     top: 170,
  //     bubbleColor: PdfColor(139, 195, 74),
  //     pageWidth: pageWidth,
  //   );

  //   // Add User response (Right-aligned)
  //   _drawRightAlignedBubble(
  //     page: page,
  //     // text: 'पतियों का गहर हरा',
  //     text: 'Darkining of leaves',
  //     top: 220,
  //     bubbleColor: PdfColor(238, 238, 238),
  //     pageWidth: pageWidth,
  //   );

  //   // Add "उतर आना बाकी..." message
  //   page.graphics.drawString(
  //     // 'उतर आना बाकी...',
  //     'Reply Pending...',
  //     PdfStandardFont(PdfFontFamily.helvetica, 12),
  //     bounds: Rect.fromLTWH(10, 270, pageWidth - 20, 20),
  //     brush: PdfBrushes.gray,
  //   );

  //   List<int> bytes = await document.save();
  //   document.dispose();

  //   saveAndLaunchFile(bytes, "ChatOutput.pdf", ctx);
  // }

  // void _drawLeftAlignedBubble({
  //   required PdfPage page,
  //   required String text,
  //   required double top,
  //   required PdfColor bubbleColor,
  //   required double pageWidth,
  // }) {
  //   final bubbleWidth = pageWidth * 0.75;
  //   final bubbleHeight = 40.0;

  //   // Draw bubble
  //   page.graphics.drawRectangle(
  //     bounds: Rect.fromLTWH(10, top, bubbleWidth, bubbleHeight),
  //     pen: PdfPen(bubbleColor),
  //     brush: PdfSolidBrush(bubbleColor),
  //     // radius: const Radius.circular(10),
  //   );

  //   // Draw text inside the bubble
  //   page.graphics.drawString(
  //     text,
  //     PdfStandardFont(PdfFontFamily.helvetica, 12),
  //     bounds: Rect.fromLTWH(15, top + 10, bubbleWidth - 10, bubbleHeight),
  //   );
  // }

  // void _drawRightAlignedBubble({
  //   required PdfPage page,
  //   required String text,
  //   required double top,
  //   required PdfColor bubbleColor,
  //   required double pageWidth,
  // }) {
  //   final bubbleWidth = pageWidth * 0.55;
  //   final bubbleHeight = 40.0;

  //   // Draw bubble
  //   page.graphics.drawRectangle(
  //     bounds: Rect.fromLTWH(pageWidth - bubbleWidth - 10, top, bubbleWidth, bubbleHeight),
  //     pen: PdfPen(bubbleColor),
  //     brush: PdfSolidBrush(bubbleColor),
  //     // radius: const Radius.circular(10),
  //   );

  //   // Draw text inside the bubble
  //   page.graphics.drawString(
  //     text,
  //     PdfStandardFont(PdfFontFamily.helvetica, 12),
  //     bounds: Rect.fromLTWH(pageWidth - bubbleWidth + 5, top + 10, bubbleWidth - 10, bubbleHeight),
  //   );
  // }

  // //Will be removed, just for testing
  // Future<void> saveAndLaunchFile(List<int> bytes, String fileName, BuildContext ctx) async {
  //   final path = (await getExternalStorageDirectory())!.path;
  //   final file = File('$path/$fileName');
  //   await file.writeAsBytes(bytes, flush: true);

  //   Utils.model(
  //       ctx,
  //       PDFScreen(
  //         path: '$path/$fileName',
  //         filename: fileName,
  //       ));
  // }

  // Future<Uint8List> _readImageData(String name) async {
  //   final data = await rootBundle.load('assets/images/$name');
  //   return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  // }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<ChatTabViewModel>(context, listen: false));
    useEffect(() {
      // useViewModel.fetchChatHistory(context, chat['_id']);
      useViewModel.fetchChatHistory(context, isFromNotifications ? chat['relatedTo'] : chat['_id']);
    }, []);
    return Scaffold(
      body: Container(
          color: AppColor.whiteColor,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 25.5),
          // height: dimension['height']! - 160,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back)),
                  BaseText(
                    title: AppLocalization.of(context)
                        .getTranslatedValue("chatHistoryTitle")
                        .toString(),
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container()
                ],
              ),
              Consumer<ChatTabViewModel>(builder: (context, provider, child) {
                bool isEnglish = AppLocalization.of(context).locale.toString() == "en";
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
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    BubbleSpecialThree(
                                      text: isEnglish
                                          ? "Choose your age"
                                          : "कृपया अपनी आयु सीमा चुने।",
                                      color: AppColor.chatBubbleColor,
                                      tail: true,
                                      isSender: false,
                                      textStyle:
                                          const TextStyle(color: AppColor.whiteColor, fontSize: 16),
                                    ),
                                    BubbleSpecialThree(
                                      text: provider.chatMessagesList["ageGroup"],
                                      color: AppColor.chatSent,
                                      tail: false,
                                      isSender: true,
                                      textStyle: const TextStyle(
                                          color: AppColor.darkBlackColor, fontSize: 16),
                                    ),
                                    BubbleSpecialThree(
                                      text: isEnglish
                                          ? "Please choose your crop category."
                                          : "कृप्या अपनी फसल से सम्बंधित कैटेगरी चुने",
                                      color: AppColor.chatBubbleColor,
                                      tail: true,
                                      isSender: false,
                                      textStyle:
                                          const TextStyle(color: AppColor.whiteColor, fontSize: 16),
                                    ),
                                    BubbleSpecialThree(
                                      text: provider.chatMessagesList["cropCategory"],
                                      color: AppColor.chatSent,
                                      tail: false,
                                      isSender: true,
                                      textStyle: const TextStyle(
                                          color: AppColor.darkBlackColor, fontSize: 16),
                                    ),
                                    BubbleSpecialThree(
                                      text: isEnglish
                                          ? "Please select your crop."
                                          : "कृपया अपनी फसल चुनें",
                                      color: AppColor.chatBubbleColor,
                                      tail: true,
                                      isSender: false,
                                      textStyle:
                                          const TextStyle(color: AppColor.whiteColor, fontSize: 16),
                                    ),
                                    BubbleSpecialThree(
                                      text: provider.chatMessagesList["crop"],
                                      color: AppColor.chatSent,
                                      tail: false,
                                      isSender: true,
                                      textStyle: const TextStyle(
                                          color: AppColor.darkBlackColor, fontSize: 16),
                                    ),
                                    BubbleSpecialThree(
                                      text: isEnglish
                                          ? "Thankyou for selecting your crop. Now select problem you are facing."
                                          : "अपनी फसल चुनने के लिए धन्यवाद, कृपया अपनी फसल की समस्या चुने",
                                      color: AppColor.chatBubbleColor,
                                      tail: true,
                                      isSender: false,
                                      textStyle:
                                          const TextStyle(color: AppColor.whiteColor, fontSize: 16),
                                    ),
                                    BubbleSpecialThree(
                                      text: provider.chatMessagesList["problemSection"],
                                      color: AppColor.chatSent,
                                      tail: false,
                                      isSender: true,
                                      textStyle: const TextStyle(
                                          color: AppColor.darkBlackColor, fontSize: 16),
                                    ),
                                    BubbleSpecialThree(
                                      text: provider.chatMessagesList["problemSection"] == "अन्य"
                                          ? isEnglish
                                              ? "To know more details about your problem, please provide details and share photo of your crop."
                                              : "कृपा अपनी समस्या लिख ​​कर /टाइप कर के बताएं और हो सके तो फोटो भी स्लैग (संलग्न) करें"
                                          : isEnglish
                                              ? "To know more details about your problem, please share a photo of your crop."
                                              : "अपने फसल के समस्या की अधिक जानकारी पाने के लिए अपने फसल के प्रभावित भाग की फोटो भेजे",
                                      color: AppColor.chatBubbleColor,
                                      tail: true,
                                      isSender: false,
                                      textStyle:
                                          const TextStyle(color: AppColor.whiteColor, fontSize: 16),
                                    ),
                                    provider.chatMessagesList["userImageAttachments"].isNotEmpty
                                        ? provider.chatMessagesList["userImageAttachments"].length >
                                                1
                                            ? Column(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Container(
                                                      margin: const EdgeInsets.symmetric(
                                                          vertical: 8, horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8)),
                                                      height: dimension['height']! * 0.40,
                                                      width: dimension['width']! * 0.6,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: CachedNetworkImage(
                                                          imageUrl: provider.chatMessagesList[
                                                              "userImageAttachments"][0],
                                                          fit: BoxFit.fill,
                                                          placeholder: (context, url) => Skeleton(
                                                            height: dimension["height"]! * 0.4,
                                                            width: dimension["width"]! * 0.6,
                                                            radius: 10,
                                                          ),
                                                          errorWidget: (context, url, error) =>
                                                              const Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Container(
                                                      margin: const EdgeInsets.symmetric(
                                                          vertical: 8, horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8)),
                                                      height: dimension['height']! * 0.40,
                                                      width: dimension['width']! * 0.6,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: CachedNetworkImage(
                                                          imageUrl: provider.chatMessagesList[
                                                              "userImageAttachments"][1],
                                                          fit: BoxFit.fill,
                                                          placeholder: (context, url) => Skeleton(
                                                            height: dimension["height"]! * 0.4,
                                                            width: dimension["width"]! * 0.6,
                                                            radius: 10,
                                                          ),
                                                          errorWidget: (context, url, error) =>
                                                              const Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(
                                                      vertical: 8, horizontal: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8)),
                                                  height: dimension['height']! * 0.40,
                                                  width: dimension['width']! * 0.6,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: CachedNetworkImage(
                                                      imageUrl: provider.chatMessagesList[
                                                          "userImageAttachments"][0],
                                                      fit: BoxFit.fill,
                                                      placeholder: (context, url) => Skeleton(
                                                        height: dimension["height"]! * 0.4,
                                                        width: dimension["width"]! * 0.6,
                                                        radius: 10,
                                                      ),
                                                      errorWidget: (context, url, error) =>
                                                          const Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : BubbleSpecialThree(
                                            text: provider.chatMessagesList["problemSection"],
                                            color: AppColor.chatSent,
                                            tail: false,
                                            isSender: true,
                                            textStyle: const TextStyle(
                                                color: AppColor.darkBlackColor, fontSize: 16),
                                          ),
                                    provider.chatMessagesList.containsKey("userMessage")
                                        ? BubbleSpecialThree(
                                            text: provider.chatMessagesList["userMessage"],
                                            color: AppColor.chatSent,
                                            tail: false,
                                            isSender: true,
                                            textStyle: const TextStyle(
                                                color: AppColor.darkBlackColor, fontSize: 16),
                                          )
                                        : const SizedBox.shrink(),
                                    provider.chatMessagesList["isReplied"]
                                        ? Column(
                                            children: [
                                              provider.chatMessagesList.containsKey("adminReply") &&
                                                      provider
                                                          .chatMessagesList["adminReply"].isNotEmpty
                                                  ? BubbleSpecialThree(
                                                      text: provider.chatMessagesList["adminReply"],
                                                      color: AppColor.chatBubbleColor,
                                                      tail: true,
                                                      isSender: false,
                                                      textStyle: const TextStyle(
                                                          color: AppColor.whiteColor, fontSize: 16),
                                                    )
                                                  : const SizedBox.shrink(),
                                              provider.chatMessagesList
                                                          .containsKey("adminRepliedImage") &&
                                                      provider.chatMessagesList["adminRepliedImage"]
                                                          .isNotEmpty
                                                  ? Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Container(
                                                        margin: const EdgeInsets.symmetric(
                                                            vertical: 8, horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8)),
                                                        height: dimension['height']! * 0.40,
                                                        width: dimension['width']! * 0.6,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(8),
                                                          child: CachedNetworkImage(
                                                            imageUrl: provider.chatMessagesList[
                                                                "adminRepliedImage"],
                                                            fit: BoxFit.fill,
                                                            placeholder: (context, url) => Skeleton(
                                                              height: dimension["height"]! * 0.4,
                                                              width: dimension["width"]! * 0.6,
                                                              radius: 10,
                                                            ),
                                                            errorWidget: (context, url, error) =>
                                                                const Icon(Icons.error),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                              provider.chatMessagesList
                                                          .containsKey("adminRepliedUrl") &&
                                                      provider.chatMessagesList["adminRepliedUrl"]
                                                          .isNotEmpty
                                                  ? InkWell(
                                                      onTap: () {
                                                        launchUrl(Uri.parse(provider
                                                            .chatMessagesList['adminRepliedUrl']));
                                                      },
                                                      child: BubbleSpecialThree(
                                                        text: provider
                                                            .chatMessagesList["adminRepliedUrl"],
                                                        color: AppColor.chatBubbleColor,
                                                        tail: true,
                                                        isSender: false,
                                                        textStyle: const TextStyle(
                                                            color: AppColor.whiteColor,
                                                            fontSize: 16),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ],
                                          )
                                        : BubbleSpecialThree(
                                            text: AppLocalization.of(context)
                                                .getTranslatedValue("pendingReplyText")
                                                .toString(),
                                            color: Colors.transparent,
                                            tail: true,
                                            isSender: false,
                                            textStyle: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: AppColor.iconColor,
                                                fontSize: 16),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          );
              })
            ],
          )),
    );
  }
}
