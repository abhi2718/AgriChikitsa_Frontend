import 'dart:async';

import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import '../../../widgets/button.widgets/elevated_button.dart';
import '../../../widgets/text.widgets/text.dart';
import 'signin_view_model.dart';

class OtpVerification extends HookWidget {
  const OtpVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<SignInViewModel>(context, listen: false));
    Timer? timer;
    useEffect(() {
      useViewModel.resetTimer();
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (useViewModel.countDown - 1 >= 0) {
          useViewModel.setCountDown();
        } else {
          timer!.cancel();
        }
      });

      return timer!.cancel;
    }, [Provider.of<SignInViewModel>(context, listen: true).showTimmer]);
    return (SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: AppColor.lightColor,
              width: double.infinity,
              alignment: Alignment.topLeft,
              height: 120,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Row(
                      children: [
                        SubHeadingText(
                          AppLocalizations.of(context)!.verifyDetailshi,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          ParagraphText(
                            AppLocalizations.of(context)!.otpsenttohi,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ParagraphText(
                            useViewModel.phoneNumber,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: dimension['width']! - 32,
              child: Column(
                children: [
                  Row(
                    children: [
                      ParagraphHeadingText(
                          AppLocalizations.of(context)!.enterOtphi)
                    ],
                  ),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: AppColor.darkColor,
                    focusedBorderColor: AppColor.darkColor,
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: !true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    },
                    //fieldWidth:((MediaQuery.of(context).size.width - 72) / 6),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      useViewModel.setOTP(verificationCode, context);
                    }, // end onSubmit
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Consumer<SignInViewModel>(
                          builder: (context, provider, child) {
                        return !provider.showResendOTPButton
                            ? ParagraphText(
                                '${AppLocalizations.of(context)!.didnottreceivetheOtphi} ${AppLocalizations.of(context)!.retryIn}${useViewModel.countDown}',
                              )
                            : ParagraphText(
                                AppLocalizations.of(context)!
                                    .didnottreceivetheOtphi,
                              );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<SignInViewModel>(
                      builder: (context, provider, child) {
                    return provider.showResendOTPButton
                        ? InkWell(
                            onTap: () => provider.reSendOTP(context),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/smsButton.png',
                                  width: 60,
                                  height: 40,
                                )
                              ],
                            ),
                          )
                        : const SizedBox();
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<SignInViewModel>(
                      builder: (context, provider, child) {
                    return CustomElevatedButton(
                      loading: provider.loading,
                      title: AppLocalizations.of(context)!.continueTexthi,
                      width: dimension["width"]! - 32,
                      onPress: () => provider.verifyOTPCode(
                          provider.verificationIdToken, provider.otp, context),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
