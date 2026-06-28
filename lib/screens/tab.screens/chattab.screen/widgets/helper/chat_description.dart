import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  void showFeedbackDialog(BuildContext context, dynamic dimension) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<ChatTabViewModel>(builder: (context, provider, _) {
                  return AbsorbPointer(
                    absorbing: provider.isFeedbackLoading,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Text(
                          AppLocalization.of(context)
                              .getTranslatedValue("feedbackTitle")
                              .toString(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        RatingBar.builder(
                          initialRating: provider.chatRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 36,
                          unratedColor: Colors.grey.shade300,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {
                            provider.setChatRating(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                            enabled: !provider.isFeedbackLoading,
                            controller: provider.userFeedbackController,
                            cursorColor: AppColor.darkBlackColor,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: AppColor.darkBlackColor),
                            decoration: InputDecoration(
                              hintText: AppLocalization.of(context)
                                  .getTranslatedValue("feedback")
                                  .toString(),
                              filled: true,
                              fillColor: AppColor.whiteColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus()),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: provider.isFeedbackLoading
                              ? null
                              : () {
                                  provider.sendChatFeedback(context, chat["_id"]).then((result) {
                                    if (result["success"] && context.mounted) {
                                      Utils.showResultDialog(
                                          context,
                                          dimension,
                                          Image.asset(
                                            'assets/images/plot_success.png',
                                            fit: BoxFit.cover,
                                          ), () {
                                        chat["isUserFeedbackGiven"] = true;
                                        if (Navigator.canPop(context)) Navigator.pop(context);
                                        if (Navigator.canPop(context)) Navigator.pop(context);
                                      },
                                          AppLocalization.of(context)
                                              .getTranslatedValue("feedbackSuccess")
                                              .toString(),
                                          true);
                                    } else {
                                      Utils.showResultDialog(context, dimension, null, () {
                                        if (Navigator.canPop(context)) Navigator.pop(context);
                                        if (Navigator.canPop(context)) Navigator.pop(context);
                                      },
                                          AppLocalization.of(context)
                                              .getTranslatedValue("errorMessage")
                                              .toString(),
                                          false);
                                    }
                                  });
                                },
                          child: GradientButton(
                            height: dimension["height"]! * 0.08,
                            width: dimension["width"],
                            isLoading: provider.isFeedbackLoading,
                            title: AppLocalization.of(context)
                                .getTranslatedValue("submitButton")
                                .toString(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<ChatTabViewModel>(context, listen: false));
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.fetchChatHistory(
            context, isFromNotifications ? chat['relatedTo'] : chat['_id']);
      });
      return null;
    }, []);
    return WillPopScope(
      onWillPop: () async {
        final hasFeedback = chat is Map && chat["isUserFeedbackGiven"] == true;
        final hasReplied = chat is Map && chat["isReplied"] == true;
        if (!hasFeedback && hasReplied) {
          showFeedbackDialog(context, dimension);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.notificationBgColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.darkBlackColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final hasFeedback = chat is Map && chat["isUserFeedbackGiven"] == true;
              final hasReplied = chat is Map && chat["isReplied"] == true;
              if (!hasFeedback && hasReplied) {
                showFeedbackDialog(context, dimension);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            AppLocalization.of(context).getTranslatedValue("chatHistoryTitle").toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: Container(
            color: AppColor.notificationBgColor,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Column(
              children: [
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
                                        textStyle: const TextStyle(
                                            color: AppColor.whiteColor, fontSize: 16),
                                      ),
                                      BubbleSpecialThree(
                                        text: provider.chatMessagesList["ageGroup"],
                                        color: AppColor.whiteColor,
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
                                        textStyle: const TextStyle(
                                            color: AppColor.whiteColor, fontSize: 16),
                                      ),
                                      BubbleSpecialThree(
                                        text: provider.chatMessagesList["cropCategory"],
                                        color: AppColor.whiteColor,
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
                                        textStyle: const TextStyle(
                                            color: AppColor.whiteColor, fontSize: 16),
                                      ),
                                      BubbleSpecialThree(
                                        text: provider.chatMessagesList["crop"],
                                        color: AppColor.whiteColor,
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
                                        textStyle: const TextStyle(
                                            color: AppColor.whiteColor, fontSize: 16),
                                      ),
                                      BubbleSpecialThree(
                                        text: provider.chatMessagesList["problemSection"],
                                        color: AppColor.whiteColor,
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
                                        textStyle: const TextStyle(
                                            color: AppColor.whiteColor, fontSize: 16),
                                      ),
                                      provider.chatMessagesList["userImageAttachments"].isNotEmpty
                                          ? provider.chatMessagesList["userImageAttachments"]
                                                      .length >
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
                                                    BubbleSpecialThree(
                                                      text: isEnglish
                                                          ? "Do you want to attach another photo with this?"
                                                          : "क्या आप इसके साथ एक और फोटो भेजना चाहते हैं?",
                                                      color: AppColor.chatBubbleColor,
                                                      tail: true,
                                                      isSender: false,
                                                      textStyle: const TextStyle(
                                                          color: AppColor.whiteColor, fontSize: 16),
                                                    ),
                                                    BubbleSpecialThree(
                                                      text: AppLocalization.of(context)
                                                          .getTranslatedValue("yes")
                                                          .toString(),
                                                      color: AppColor.whiteColor,
                                                      tail: false,
                                                      isSender: true,
                                                      textStyle: const TextStyle(
                                                          color: AppColor.darkBlackColor,
                                                          fontSize: 16),
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
                                              : Column(
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
                                                    BubbleSpecialThree(
                                                      text: isEnglish
                                                          ? "Do you want to attach another photo with this?"
                                                          : "क्या आप इसके साथ एक और फोटो भेजना चाहते हैं?",
                                                      color: AppColor.chatBubbleColor,
                                                      tail: true,
                                                      isSender: false,
                                                      textStyle: const TextStyle(
                                                          color: AppColor.whiteColor, fontSize: 16),
                                                    ),
                                                    BubbleSpecialThree(
                                                      text: AppLocalization.of(context)
                                                          .getTranslatedValue("no")
                                                          .toString(),
                                                      color: AppColor.whiteColor,
                                                      tail: false,
                                                      isSender: true,
                                                      textStyle: const TextStyle(
                                                          color: AppColor.darkBlackColor,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                )
                                          : BubbleSpecialThree(
                                              text: provider.chatMessagesList["problemSection"],
                                              color: AppColor.whiteColor,
                                              tail: false,
                                              isSender: true,
                                              textStyle: const TextStyle(
                                                  color: AppColor.darkBlackColor, fontSize: 16),
                                            ),
                                      provider.chatMessagesList.containsKey("userMessage")
                                          ? BubbleSpecialThree(
                                              text: provider.chatMessagesList["userMessage"],
                                              color: AppColor.whiteColor,
                                              tail: false,
                                              isSender: true,
                                              textStyle: const TextStyle(
                                                  color: AppColor.darkBlackColor, fontSize: 16),
                                            )
                                          : const SizedBox.shrink(),
                                      provider.chatMessagesList["isReplied"] == true
                                          ? Column(
                                              children: [
                                                provider.chatMessagesList
                                                            .containsKey("adminReply") &&
                                                        provider.chatMessagesList["adminReply"]
                                                            .isNotEmpty
                                                    ? BubbleSpecialThree(
                                                        text:
                                                            provider.chatMessagesList["adminReply"],
                                                        color: AppColor.chatBubbleColor,
                                                        tail: true,
                                                        isSender: false,
                                                        textStyle: const TextStyle(
                                                            color: AppColor.whiteColor,
                                                            fontSize: 16),
                                                      )
                                                    : const SizedBox.shrink(),
                                                provider.chatMessagesList
                                                            .containsKey("adminRepliedImage") &&
                                                        provider
                                                            .chatMessagesList["adminRepliedImage"]
                                                            .isNotEmpty
                                                    ? Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Container(
                                                          margin: const EdgeInsets.symmetric(
                                                              vertical: 8, horizontal: 8),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(8)),
                                                          height: dimension['height']! * 0.40,
                                                          width: dimension['width']! * 0.6,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(8),
                                                            child: CachedNetworkImage(
                                                              imageUrl: provider.chatMessagesList[
                                                                  "adminRepliedImage"],
                                                              fit: BoxFit.fill,
                                                              placeholder: (context, url) =>
                                                                  Skeleton(
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
                                                          launchUrl(Uri.parse(
                                                              provider.chatMessagesList[
                                                                  'adminRepliedUrl']));
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
      ),
    );
  }
}
