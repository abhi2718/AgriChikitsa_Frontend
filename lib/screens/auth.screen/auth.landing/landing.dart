import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/button.widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        return Utils.flushBarErrorMessage(AppLocalizations.of(context)!.alerthi,
            AppLocalizations.of(context)!.pleasecheckhi, context);
      }
      Utils.model(context, const SignInScreen());
    }

    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        height: dimension["height"],
        child: Stack(
          children: [
            Container(
              height: dimension["height"]! * 0.75,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/loginGif.gif"),
                      fit: BoxFit.cover)),
            ),
            Positioned(
              top: dimension["height"]! * 0.70,
              child: Container(
                height: dimension["height"]! * 0.30,
                width: dimension["width"],
                decoration: const BoxDecoration(
                    color: AppColor.lightColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18))),
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
                              child: HeadingText(
                                  AppLocalizations.of(context)!.accounthi),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ParagraphText(AppLocalizations.of(context)!
                                  .loginCreateAccounthi),
                            ),
                          ],
                        ),
                        CustomElevatedButton(
                          width: dimension["width"]! - 32,
                          title: AppLocalizations.of(context)!.loginhi,
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
                            ParagraphText(
                                AppLocalizations.of(context)!.iagreewithi),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                try {
                                  final Uri toLaunch = Uri(
                                      scheme: 'https',
                                      host: 'agrichikitsa.org',
                                      path: '/termsAndCondition');
                                  Utils.launchInWebViewWithoutJavaScript(
                                      toLaunch);
                                } catch (error) {
                                  Utils.flushBarErrorMessage(
                                      AppLocalizations.of(context)!.alerthi,
                                      error.toString(),
                                      context);
                                }
                              },
                              child: ParagraphHeadingText(
                                  AppLocalizations.of(context)!
                                      .termsandConditionhi),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

// Container(
//           height: dimension["height"],
//           // width: dimension["width"],
//           color: Colors.red,
//           child: Stack(
//             children: [
//               Image.asset(
//                 "assets/images/loginGif.gif",
//                 height: (dimension["height"]! * 0.75),
//                 width: dimension["width"]!,
//                 fit: BoxFit.cover,
//               ),
//               Positioned(
//                 // top: 400,
//                 child: Container(
                  // width: double.infinity,
                  // decoration: const BoxDecoration(
                  //     color: AppColor.lightColor,
                  //     borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(18),
                  //         topRight: Radius.circular(18))),
                  // height: dimension["height"]! * 0.30,
                  // child: Padding(
                  //   padding: const EdgeInsets.all(16),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     height: (dimension["height"]! * 0.3) - 40,
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Column(
                  //           children: [
                  //             SizedBox(
                  //               width: double.infinity,
                  //               child: HeadingText(
                  //                   AppLocalizations.of(context)!.accounthi),
                  //             ),
                  //             SizedBox(
                  //               width: double.infinity,
                  //               child: ParagraphText(
                  //                   AppLocalizations.of(context)!
                  //                       .loginCreateAccounthi),
                  //             ),
                  //           ],
                  //         ),
                  //         CustomElevatedButton(
                  //           width: dimension["width"]! - 32,
                  //           title: AppLocalizations.of(context)!.loginhi,
                  //           onPress: handleLogin,
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Checkbox(
                  //               value: isTermsAndConditions.value,
                  //               onChanged: handleToggle,
                  //             ),
                  //             ParagraphText(
                  //                 AppLocalizations.of(context)!.iagreewithi),
                  //             const SizedBox(
                  //               width: 5,
                  //             ),
                  //             InkWell(
                  //               onTap: () {
                  //                 try {
                  //                   final Uri toLaunch = Uri(
                  //                       scheme: 'https',
                  //                       host: 'agrichikitsa.org',
                  //                       path: '/termsAndCondition');
                  //                   Utils.launchInWebViewWithoutJavaScript(
                  //                       toLaunch);
                  //                 } catch (error) {
                  //                   Utils.flushBarErrorMessage(
                  //                       AppLocalizations.of(context)!.alerthi,
                  //                       error.toString(),
                  //                       context);
                  //                 }
                  //               },
                  //               child: ParagraphHeadingText(
                  //                   AppLocalizations.of(context)!
                  //                       .termsandConditionhi),
                  //             ),
                  //           ],
                  //         )
                  //       ],
                  //     ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
