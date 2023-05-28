import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import './signup_view_model.dart';
import './widgets/verify_user.dart';
import './widgets/register.dart';

class SignUpScreen extends HookWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (context, provider, child) =>
          provider.isVerified ?const RegisterUser(): const VerifyUser() ,
    );
  }
}
