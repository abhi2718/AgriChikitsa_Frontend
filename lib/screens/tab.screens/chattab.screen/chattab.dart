import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../services/auth.dart';
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
        body: SafeArea(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  useViewModel.reinitilize();
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 30.0,
                ),
              ),
              SizedBox(
                height: dimension['height'],
                width: double.infinity,
                child: ChatScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
