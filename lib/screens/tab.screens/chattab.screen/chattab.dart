import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/chat_history.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../widgets/text.widgets/text.dart';
import 'chat_tab_view_model.dart';
import 'widgets/helper/simplebot.dart';

class ChatTabScreen extends HookWidget {
  const ChatTabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<ChatTabViewModel>(context, listen: false);
    useEffect(() {
      Future.delayed(Duration.zero, () {});
    }, []);
    Future<bool> _onWillPop() async {
      return false;
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff018715),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: AppColor.whiteColor,
          backgroundColor: const Color(0xff018715),
          foregroundColor: AppColor.whiteColor,
          centerTitle: false,
          leading: null,
          automaticallyImplyLeading: false,
          title: Consumer<ChatTabViewModel>(builder: (context, provider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                    onTap: () {
                      useViewModel.goBack(context);
                    },
                    child: const Icon(Icons.arrow_back)),
                Expanded(
                  child: ListTile(
                    leading: const CircleAvatar(
                        backgroundImage: AssetImage(
                      'assets/images/logoagrichikitsa.png',
                    )),
                    title: BaseText(
                        title: AppLocalization.of(context)
                            .getTranslatedValue("chatBotTitle")
                            .toString(),
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 18, color: AppColor.whiteColor)),
                    subtitle: provider.isChatCompleted
                        ? null
                        : Text("Online",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColor.whiteColor)),
                  ),
                ),
              ],
            );
          }),
          // title: BaseText(
          //     title: AppLocalization.of(context).getTranslatedValue("chatBotTitle").toString(),
          //     style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 18)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                  onTap: () {
                    useViewModel.isChatCompleted
                        ? Utils.model(context, const ChatHistory1())
                        : Utils.snackbar(
                            AppLocalization.of(context)
                                .getTranslatedValue("chatActiveWarning")
                                .toString(),
                            context);
                  },
                  child: const Icon(Icons.history)),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(child: ChatScreen()),
            Consumer<ChatTabViewModel>(builder: (context, provider, chlid) {
              return provider.enableKeyBoard || provider.showCameraButton
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.darkBlackColor),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: dimension['width']! - 160,
                                    child: TextField(
                                      enabled: provider.enableKeyBoard,
                                      controller: useViewModel.textEditingController,
                                      decoration: InputDecoration(
                                        disabledBorder: const OutlineInputBorder(
                                            // borderSide: BorderSide(color: AppColor.iconColor),
                                            borderSide: BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                8,
                                              ),
                                            )),
                                        enabledBorder: const OutlineInputBorder(
                                          // borderSide: BorderSide(color: AppColor.darkColor),
                                          borderSide: BorderSide(color: Colors.transparent),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          // borderSide: BorderSide(color: AppColor.darkColor),
                                          borderSide: BorderSide(color: Colors.transparent),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        hintText: provider.showCameraButton
                                            ? AppLocalization.of(context)
                                                .getTranslatedValue('uploadPhotoChat')
                                                .toString()
                                            : AppLocalization.of(context)
                                                .getTranslatedValue("typeHere")
                                                .toString(),
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (useViewModel.showCameraButton) {
                                          useViewModel.uploadImage(context);
                                        }
                                      },
                                      child: provider.showCameraButton
                                          // ? Image.asset(
                                          //     'assets/icons/camera.png',
                                          //     width: 24,
                                          //     height: 24,
                                          //   )
                                          ? const Icon(
                                              Icons.photo_camera_outlined,
                                              size: 25,
                                            )
                                          : const Icon(
                                              Icons.no_photography_rounded,
                                              color: AppColor.iconColor,
                                              size: 25,
                                            )),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (useViewModel.showCameraButton) {
                                          useViewModel.uploadGallery(context);
                                        }
                                      },
                                      child: provider.showCameraButton
                                          // ? Image.asset('assets/icons/gallery.png',
                                          //     width: 24, height: 24)
                                          ? const Icon(Icons.image_outlined, size: 25)
                                          : const Icon(
                                              Icons.hide_image,
                                              color: AppColor.iconColor,
                                              size: 25,
                                            )),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                useViewModel.handleUserInput(context);
                              },
                              child: const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xff4BA859),
                                child: Icon(
                                  Icons.send,
                                  color: AppColor.whiteColor,
                                  size: 21,
                                ),
                              ),
                              // child: CircleAvatar(
                              //   backgroundColor: AppColor.extraDark,
                              //   child: Center(
                              //     child: Image.asset(
                              //       "assets/icons/send_icon.png",
                              //       height: 26,
                              //       width: 26,
                              //     ),
                              //   ),
                              // ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }
}
