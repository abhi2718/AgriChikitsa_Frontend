import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_hi.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../widgets/text.widgets/text.dart';
import '../signin.auth/signin.dart';

class LandingAuthScreen extends HookWidget {
  const LandingAuthScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    final isTermsAndConditions = useState(true);
    void handleToggle(value) {
      isTermsAndConditions.value = value;
    }

    void handleLogin() {
      if (!isTermsAndConditions.value) {
        return Utils.flushBarErrorMessage(
            "Alert!", "Please check the terms and conditions box.", context);
      }
      Utils.model(context, const SignInScreen());
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: dimension["height"]! * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/landing.png",
                      height: (dimension["height"]! * 0.7) - 100,
                      width: dimension["width"]! - 32,
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: AppColor.lightColor,
                height: dimension["height"]! * 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: (dimension["height"]! * 0.3) - 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: HeadingText(AppLocalizationsHi().account),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ParagraphText(
                                AppLocalizationsHi().loginCreateAccount,
                              ),
                            ),
                          ],
                        ),
                        CustomElevatedButton(
                          width: dimension["width"]! - 32,
                          title: AppLocalizationsHi().login,
                          onPress: handleLogin,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: isTermsAndConditions.value,
                              onChanged: handleToggle,
                            ),
                            InkWell(
                              child: ParagraphHeadingText(
                                AppLocalizationsHi().termsConditions,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
