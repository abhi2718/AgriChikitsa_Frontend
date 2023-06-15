import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/user_model.dart';
import '../../../services/auth.dart';
import '../profiletab.screen/profile_view_model.dart';
import 'widgets/chat_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: true);
    final useViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final user = User.fromJson(authService.userInfo["user"]);
    // int index = 0;
    return Consumer<ChatTabViewModel>(builder: (context, provider, child) {
      return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 30,
            left: 13,
            right: 13,
          ),
          itemCount: provider.chatMessageList.length,
          reverse: true,
          itemBuilder: (context, index) {
            final messageList = provider.chatMessageList.reversed;
            if (provider.chatMessageList.elementAt(index).isMe == false) {
              return const ChatBubbles.next(
                  message:
                      "नमस्कार Atin जी🤗, आपका एग्रीचिकित्सा  मे स्वागत है ।\n\n\nइस मंच से हम आपके फसलों के रोगों एवं संबंधित समस्याओं का समाधान देने की कोशिश कर रहे है। कृपया नीचे पूछे गए सवालों के सही उत्तर चुने।⏬\n\n\nकृपया अपनी उम्र सीमा चुने ।",
                  isMe: false);
            } else {
              return ChatBubbles.first(
                  userImage: user.profileImage,
                  message: messageList.elementAt(index).message,
                  isMe: messageList.elementAt(index).isMe);
            }
          });
    });
  }
}
