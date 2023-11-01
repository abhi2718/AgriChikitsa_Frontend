import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/chattab.screen/widgets/helper/chat_history_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ChatHistory1 extends HookWidget {
  const ChatHistory1({super.key});

  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<ChatTabViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.getAllChatHistory(context);
    }, []);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: AppColor.darkBlackColor,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Chat History"),
      ),
      body: Consumer<ChatTabViewModel>(
        builder: (context, provider, child) {
          return provider.chatLoader
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.chatHistoryList.isEmpty
                  ? const Center(
                      child: Text("No Chat History Found!"),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...provider.chatHistoryList.reversed
                              .map((chat) => ChatHistoryTile(
                                    chat: chat,
                                  ))
                              .toList()
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
