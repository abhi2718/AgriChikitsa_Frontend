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
    return Text("Welcome to the chat");
  }
}
