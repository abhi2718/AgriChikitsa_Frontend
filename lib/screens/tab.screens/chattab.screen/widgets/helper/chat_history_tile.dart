import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';
import 'chat_description.dart';

// class ChatHistoryTile extends StatelessWidget {
//   const ChatHistoryTile({super.key, required this.chat});
//   final dynamic chat;
//   @override
//   Widget build(BuildContext context) {
//     final date =
//         DateFormat('dd-MM-yyyy hh:mma').format(DateTime.parse(chat["createdAt"]).toLocal());
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListTile(
//         onTap: () => Utils.model(
//             context,
//             ChatDescription(
//               chat: chat,
//             )),
//         tileColor: AppColor.notificationBgColor,
//         title: Text(date),
//         trailing: const Icon(Icons.description),
//       ),
//     );
//   }
// }
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
    final date =
        DateFormat('dd-MM-yyyy hh:mma').format(DateTime.parse(widget.chat["createdAt"]).toLocal());
    final bool isAdminReplied = widget.chat["isReplied"] ?? true;
    // final bool isAdminReplied = true;
    final useViewModel = Provider.of<ChatTabViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.chat["isReplied"]
          ? Dismissible(
              key: Key(widget.chat["id"].toString()),
              direction: DismissDirection.horizontal, // Allow scrolling in both directions
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog(
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
                            AppLocalization.of(context).getTranslatedValue("no").toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            useViewModel.deleteChatHistory(context, widget.chat["_id"]);
                          },
                          child: Text(
                            AppLocalization.of(context).getTranslatedValue("yes").toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return false; // Prevent dismissal in other directions
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.notificationBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  onTap: () {
                    if (!widget.chat["isOpened"]) {
                      useViewModel.markChatAsOpened(widget.chat["_id"]);
                      setState(() {
                        widget.chat["isOpened"] = true;
                      });
                    }
                    Utils.model(
                      context,
                      ChatDescription(chat: widget.chat),
                    );
                  },
                  title: Row(
                    children: [
                      Text(date),
                      if (!isOpened)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("newChatTitle")
                                .toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.description),
                  subtitle: isAdminReplied
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("adminReplied")
                                .toString(),
                            style:
                                const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        )
                      : null,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: AppColor.notificationBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () {
                  if (!widget.chat["isOpened"]) {
                    useViewModel.markChatAsOpened(widget.chat["_id"]);
                    setState(() {
                      widget.chat["isOpened"] = true;
                    });
                  }
                  Utils.model(
                    context,
                    ChatDescription(chat: widget.chat),
                  );
                },
                title: Row(
                  children: [
                    Text(date),
                    if (!isOpened)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          AppLocalization.of(context).getTranslatedValue("newChatTitle").toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.description),
                subtitle: isAdminReplied
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          AppLocalization.of(context).getTranslatedValue("adminReplied").toString(),
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      )
                    : null,
              ),
            ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Dismissible(
    //     key: Key(widget.chat["id"].toString()),
    //     direction: DismissDirection.endToStart,
    //     background: Container(
    //       color: Colors.red,
    //       padding: const EdgeInsets.only(right: 20),
    //       alignment: Alignment.centerRight,
    //       child: const Icon(Icons.delete, color: Colors.white),
    //     ),
    //     confirmDismiss: (direction) async {
    //       return await showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //           title:
    //               Text(AppLocalization.of(context).getTranslatedValue("warningTitle").toString()),
    //           content: Text(AppLocalization.of(context)
    //               .getTranslatedValue("warningDeleteChatSubTitle")
    //               .toString()),
    //           actions: [
    //             TextButton(
    //               onPressed: () => Navigator.of(context).pop(false),
    //               child: Text(AppLocalization.of(context).getTranslatedValue("no").toString(),
    //                   style: const TextStyle(color: Colors.black)),
    //             ),
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop(true);
    //                 useViewModel.deleteChatHistory(context, widget.chat["_id"]);
    //               },
    //               child: Text(
    //                 AppLocalization.of(context).getTranslatedValue("yes").toString(),
    //                 style: const TextStyle(color: Colors.red),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: AppColor.notificationBgColor,
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //       child: ListTile(
    //         onTap: () {
    //           if (!widget.chat["isOpened"]) {
    //             useViewModel.markChatAsOpened(widget.chat["_id"]);
    //             setState(() {
    //               widget.chat["isOpened"] = true;
    //             });
    //           }
    //           Utils.model(
    //             context,
    //             ChatDescription(chat: widget.chat),
    //           );
    //         },
    //         title: Row(
    //           children: [
    //             Text(date),
    //             if (!isOpened)
    //               Container(
    //                 margin: const EdgeInsets.only(left: 8),
    //                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    //                 decoration: BoxDecoration(
    //                   color: Colors.red,
    //                   borderRadius: BorderRadius.circular(4),
    //                 ),
    //                 child: Text(
    //                   AppLocalization.of(context).getTranslatedValue("newChatTitle").toString(),
    //                   style: const TextStyle(color: Colors.white, fontSize: 12),
    //                 ),
    //               ),
    //           ],
    //         ),
    //         trailing: const Icon(Icons.description),
    //         subtitle: isAdminReplied
    //             ? Container(
    //                 padding: const EdgeInsets.all(4),
    //                 decoration: BoxDecoration(
    //                   color: Colors.green.withOpacity(0.2),
    //                   borderRadius: BorderRadius.circular(4),
    //                 ),
    //                 child: Text(
    //                   AppLocalization.of(context).getTranslatedValue("adminReplied").toString(),
    //                   style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    //                 ),
    //               )
    //             : null,
    //       ),
    //     ),
    //   ),
    // );
  }
}
