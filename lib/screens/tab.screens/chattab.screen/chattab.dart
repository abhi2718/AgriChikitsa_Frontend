import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.darkBlackColor,
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                useViewModel.goBack(context);
              },
              child: const Icon(Icons.arrow_back)),
          title: BaseText(
              title: AppLocalizations.of(context)!.chatPanchamhi, style: const TextStyle()),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Expanded(child: ChatScreen()),
            Consumer<ChatTabViewModel>(builder: (context, provider, chlid) {
              return provider.enableKeyBoard || provider.showCameraButton
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (useViewModel.showCameraButton) {
                                    useViewModel.uploadImage(context);
                                  }
                                },
                                child: provider.showCameraButton
                                    ? Image.asset(
                                        'assets/icons/camera.png',
                                        width: 26,
                                        height: 26,
                                      )
                                    : const Icon(
                                        Icons.no_photography_rounded,
                                        color: AppColor.iconColor,
                                        size: 30,
                                      )),
                            InkWell(
                                onTap: () {
                                  if (useViewModel.showCameraButton) {
                                    useViewModel.uploadGallery(context);
                                  }
                                },
                                child: provider.showCameraButton
                                    ? Image.asset('assets/icons/gallery.png', width: 24, height: 24)
                                    : const Icon(
                                        Icons.hide_image,
                                        color: AppColor.iconColor,
                                        size: 30,
                                      )),
                            SizedBox(
                              width: dimension['width']! - 160,
                              child: TextField(
                                enabled: provider.enableKeyBoard,
                                controller: useViewModel.textEditingController,
                                decoration: InputDecoration(
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.iconColor),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          8,
                                        ),
                                      )),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColor.darkColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        8,
                                      ),
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColor.darkColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        8,
                                      ),
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  hintText: AppLocalizations.of(context)!.typeHerehi,
                                  hintStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                useViewModel.handleUserInput(context);
                              },
                              child: Image.asset(
                                "assets/icons/send_icon.png",
                                height: 26,
                                width: 26,
                              ),
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
