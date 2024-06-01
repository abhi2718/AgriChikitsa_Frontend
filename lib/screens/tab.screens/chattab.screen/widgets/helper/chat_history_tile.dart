import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import 'chat_description.dart';

class ChatHistoryTile extends StatelessWidget {
  const ChatHistoryTile({super.key, required this.chat});
  final dynamic chat;
  @override
  Widget build(BuildContext context) {
    final date =
        DateFormat('dd-MM-yyyy hh:mma').format(DateTime.parse(chat["createdAt"]).toLocal());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () => Utils.model(
            context,
            ChatDescription(
              chat: chat,
            )),
        tileColor: AppColor.notificationBgColor,
        title: Text(date),
        trailing: const Icon(Icons.description),
      ),
    );
  }
}
