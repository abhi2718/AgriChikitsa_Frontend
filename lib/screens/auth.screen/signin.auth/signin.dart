import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/button.widgets/elevated_button.dart';
import '../../../widgets/text.widgets/text.dart';
import 'signin_view_model.dart';

class SignInScreen extends HookWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<SignInViewModel>(context, listen: false));
    return (SizedBox(
      height: dimension['height']! - 150,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: SubHeadingText(
                  AppLocalization.of(context).getTranslatedValue("login").toString()),
            ),
            SizedBox(
              width: double.infinity,
              child: ParagraphText(
                  AppLocalization.of(context).getTranslatedValue("enterPhoneNumber").toString()),
            ),
            const SizedBox(
              height: 26,
            ),
            Consumer<SignInViewModel>(builder: (context, provider, child) {
              return TextField(
                autofillHints: const [AutofillHints.telephoneNumber],
                controller: useViewModel.phoneNumberController,
                keyboardType: TextInputType.number,
                autofocus: true,
                maxLength: 10,
                onChanged: (value) => useViewModel.onPhoneNumberChanged(context, value),
                onSubmitted: (value) => useViewModel.verifyUserPhoneNumber(context),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)
                      .getTranslatedValue("mobileNumberCount")
                      .toString(),
                  errorText: useViewModel.errorMessage,
                  //   ),
                ),
              );
            }),
            const SizedBox(
              height: 16,
            ),
            Consumer<SignInViewModel>(builder: (context, provider, child) {
              return CustomElevatedButton(
                title: AppLocalization.of(context).getTranslatedValue("continue").toString(),
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
