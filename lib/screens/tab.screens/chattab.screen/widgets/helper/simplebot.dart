import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../chat_tab_view_model.dart';

class ChatScreen extends HookWidget {

  @override
  Widget build(BuildContext context) {
  final useViewModel =
        Provider.of<ChatTabViewModel>(context, listen: true);
   

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:useViewModel.chatMessages.length,
              itemBuilder: (context, index) {
                final message = useViewModel.chatMessages[index];
                return ListTile(
                  title: Text(
                    message.text,
                    style: TextStyle(
                      fontWeight: message.isUserMessage
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: ()=>useViewModel.handleUserQuery('hi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
