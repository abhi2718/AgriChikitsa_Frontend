import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/Input.widgets/input.dart';
import '../../../widgets/button.widgets/elevated_button.dart';
import '../../../widgets/text.widgets/text.dart';
import '../../../widgets/tools.widgets/tools.dart';
import 'signin_view_model.dart';

class SignInScreen extends HookWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<SignInViewModel>(context, listen: false));
    return (SizedBox(
      height: dimension['height']! - 150,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: SubHeadingText("LOGIN"),
            ),
            const SizedBox(
              width: double.infinity,
              child: ParagraphText("Enter your phone number to proceed"),
            ),
            const SizedBox(
              height: 26,
            ),
            Consumer<SignInViewModel>(builder: (context, provider, child) {
              return TextField(
                controller: useViewModel.phoneNumberController,
                keyboardType: TextInputType.number,
                autofocus: true,
                maxLength: 10,
                onChanged: useViewModel.onPhoneNumberChanged,
                decoration: InputDecoration(
                  labelText: '10 digit mobile number',
                  errorText: useViewModel.errorMessage,
                ),
              );
            }),
            const SizedBox(
              height: 16,
            ),
            CustomElevatedButton(
              title: "Continue",
              onPress: () => useViewModel.verifyUserPhoneNumber(context),
              width: (dimension["width"]! - 32),
            )
          ],
        ),
      ),
    ));
  }
}

