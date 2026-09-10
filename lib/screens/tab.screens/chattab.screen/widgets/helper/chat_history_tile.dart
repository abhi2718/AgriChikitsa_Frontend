import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import 'chat_description.dart';

class ChatHistoryTile extends StatefulWidget {
  const ChatHistoryTile({super.key, required this.chat});
  final dynamic chat;

  @override
  State<ChatHistoryTile> createState() => _ChatHistoryTileState();
}

class _ChatHistoryTileState extends State<ChatHistoryTile> {
  @override
  Widget build(BuildContext context) {
    bool isOpened = widget.chat["isOpened"] ?? false;
    final String rawDate = widget.chat["createdAt"]?.toString() ?? "";
    String date = "";
    if (rawDate.isNotEmpty) {
      try {
        date = DateFormat('dd-MM-yyyy hh:mma')
            .format(DateTime.parse(rawDate).toLocal());
      } catch (_) {
        date = rawDate;
      }
    }
    final bool isAdminReplied = widget.chat["isReplied"] ?? false;
    final useViewModel = Provider.of<ChatTabViewModel>(context, listen: false);
    final String chatId =
        (widget.chat["_id"] ?? widget.chat["id"] ?? "").toString();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dismissible(
        key: Key(chatId.isNotEmpty ? chatId : UniqueKey().toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(AppLocalization.of(context)
                    .getTranslatedValue("warningTitle")
                    .toString()),
                content: Text(AppLocalization.of(context)
                    .getTranslatedValue("warningDeleteChatSubTitle")
                    .toString()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValue("no")
                          .toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValue("yes")
                          .toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
            return shouldDelete ?? false;
          }
          return false;
        },
        onDismissed: (direction) {
          useViewModel.deleteChatHistory(context, chatId);
        },
        child: Material(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            onTap: () {
              if (!isOpened && chatId.isNotEmpty) {
                setState(() {
                  isOpened = true;
                });
                useViewModel.markChatAsOpened(chatId);
              }
              Utils.model(
                context,
                ChatDescription(chat: {
                  ...widget.chat,
                  "isOpened": true,
                }),
              );
            },
            title: Row(
              children: [
                if (date.isNotEmpty) Text(date),
                if (!isOpened)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValue("newChatTitle")
                          .toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.description),
            subtitle: isAdminReplied
                ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValue("adminReplied")
                          .toString(),
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
