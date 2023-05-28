import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:agriChikitsa/res/color.dart';
import '../../../utils/utils.dart';
import '../../../widgets/Input.widgets/input.dart';
import '../../../widgets/button.widgets/elevated_button.dart';
import '../../../widgets/text.widgets/text.dart';
import '../../../widgets/tools.widgets/tools.dart';
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
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Row(
                      children: [SubHeadingText("VERIFY DETAILS")],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          ParagraphText(
                            'OTP sent to ${useViewModel.phoneNumber}',
                          )
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
                  const Row(
                    children: [ParagraphHeadingText("Enter OTP")],
                  ),
                  OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    outlineBorderRadius: 20,
                    fieldWidth: ((MediaQuery.of(context).size.width - 72) / 6),
                    style: const TextStyle(fontSize: 17),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      useViewModel.setOTP(pin,context);
                    },
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
                                "Didn't receive the OTP? Retry in 00:"
                                '${useViewModel.countDown}',
                              )
                            : const ParagraphText(
                                "Didn't receive the OTP? Retry via:");
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
                                  'assets/images/SMS.png',
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
                      title: "VERIFY & PROCEED",
                      width: dimension["width"]! - 32,
                      onPress: () => provider.verifyOTPCode(provider.verificationIdToken,provider.otp,context),
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
