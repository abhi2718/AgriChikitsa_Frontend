import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import '../../../widgets/button.widgets/elevated_button.dart';
import '../../../widgets/text.widgets/text.dart';
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
            SizedBox(
              width: double.infinity,
              child: SubHeadingText(AppLocalizationsHi().login),
            ),
            SizedBox(
              width: double.infinity,
              child: ParagraphText(
                  AppLocalizationsHi().enterYourPhoneNumberToProceed),
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
                  labelText: AppLocalizationsHi().digitmobilenumber,
                  errorText: useViewModel.errorMessage,
                ),
              );
            }),
            const SizedBox(
              height: 16,
            ),
            CustomElevatedButton(
              title: AppLocalizationsHi().continueText,
              onPress: () => useViewModel.verifyUserPhoneNumber(context),
              width: (dimension["width"]! - 32),
            )
          ],
        ),
      ),
    ));
  }
}
