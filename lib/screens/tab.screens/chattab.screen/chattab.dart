import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_message.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/chat_card.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/header.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/header.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'chat_tab_view_model.dart';

class ChatTabScreen extends HookWidget {
  const ChatTabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<ChatTabViewModel>(context, listen: true));
    useEffect(() {
      Future.delayed(Duration.zero, () {});
    }, []);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ChatHeaderWidget(),
            const SizedBox(
              height: 5,
            ),
            const Expanded(child: ChatMessages()),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColor.whiteColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/camera.png'),
                        const SizedBox(
                          width: 16,
                        ),
                        Image.asset(
                          'assets/icons/gallery.jpg',
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 26,
                  ),
                  Expanded(
                    child: Container(
                      height: 41,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColor.chatBubbleColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                            hintText: "Aa",
                            enabled: false,
                            border: InputBorder.none),
                        // controller: messageController,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Image.asset(
                    'assets/icons/send_icon.png',
                    height: 25,
                    width: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
