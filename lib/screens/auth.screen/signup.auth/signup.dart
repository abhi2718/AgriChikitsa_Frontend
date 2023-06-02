import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import './signup_view_model.dart';
import './widgets/register.dart';

class SignUpScreen extends HookWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    var phoneNumber = arguments['phoneNumber']!;
    var uid = arguments['uid']!;
    return Consumer<SignUpViewModel>(
      builder: (context, provider, child) =>
           RegisterUser(phoneNumber: phoneNumber,uid: uid,),
    );
  }
}
