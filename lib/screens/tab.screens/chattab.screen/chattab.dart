import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../services/auth.dart';
import '../../../widgets/text.widgets/text.dart';
import 'chat_tab_view_model.dart';
import 'widgets/helper/simplebot.dart';

class ChatTabScreen extends HookWidget {
  const ChatTabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<ChatTabViewModel>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: true);
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
                useViewModel.reinitilize();
              },
              child: const Icon(Icons.arrow_back)),
          title: BaseText(
              title: AppLocalizationsHi().chatPancham,
              style: const TextStyle()),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Expanded(child: ChatScreen()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          useViewModel.uploadImage(context);
                        },
                        child: Image.asset('assets/icons/camera.png')),
                    InkWell(
                        onTap: () {
                          useViewModel.uploadGallery(context);
                        },
                        child: Image.asset('assets/icons/gallery.jpg')),
                    SizedBox(
                      width: dimension['width']! - 160,
                      child: TextField(
                        controller: useViewModel.textEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          hintText: AppLocalizationsHi().typeHere,
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                8,
                              ),
                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
