import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

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
              child: SubHeadingText(AppLocalizations.of(context)!.loginhi),
            ),
            SizedBox(
              width: double.infinity,
              child: ParagraphText(AppLocalizations.of(context)!
                  .enterYourPhoneNumberToProceedhi),
            ),
            const SizedBox(
              height: 26,
            ),
            Consumer<SignInViewModel>(builder: (context, provider, child) {
              return PhoneFieldHint(
                  controller: useViewModel.phoneNumberController,
                  child: TextField(
                    controller: useViewModel.phoneNumberController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    maxLength: 10,
                    onChanged: (value) =>
                        useViewModel.onPhoneNumberChanged(context, value),
                    onSubmitted: (value) =>
                        useViewModel.verifyUserPhoneNumber(context),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.digitmobilenumberhi,
                      errorText: useViewModel.errorMessage,
                      //   ),
                    ),
                  ));
              // return TextFieldPinAutoFill(
              //   currentCode: useViewModel.phoneNumberController.text,
              //   onCodeChanged: (value) =>
              //       useViewModel.onPhoneNumberChanged(context, value),
              //   onCodeSubmitted: (value) =>
              //       useViewModel.verifyUserPhoneNumber(context),
              //   decoration: InputDecoration(
              //     labelText: AppLocalizations.of(context)!.digitmobilenumberhi,
              //     errorText: useViewModel.errorMessage,
              //   ),
              // );
            }),
            const SizedBox(
              height: 16,
            ),
            Consumer<SignInViewModel>(builder: (context, provider, child) {
              return CustomElevatedButton(
                title: AppLocalizations.of(context)!.continueTexthi,
                loading: provider.loading,
                onPress: () => useViewModel.verifyUserPhoneNumber(context),
                width: (dimension["width"]! - 32),
              );
            })
          ],
        ),
      ),
    ));
  }
}
