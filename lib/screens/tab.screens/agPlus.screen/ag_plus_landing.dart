import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/all_plots_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import 'ag_plus_view_model.dart';

class AGPlusLanding extends HookWidget {
  const AGPlusLanding({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Consumer<AGPlusViewModel>(
      builder: (context, provider, child) {
        return provider.getFieldLoader
            ? const CircularProgressIndicator(
                color: AppColor.extraDark,
              )
            : Scaffold(
                backgroundColor: AppColor.lightColor,
                appBar: AppBar(
                  backgroundColor: AppColor.whiteColor,
                  foregroundColor: AppColor.darkBlackColor,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    AppLocalization.of(context).getTranslatedValue("agPlusAppBar").toString(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: dimension['width']!,
                            child: Image.asset(
                              'assets/images/agriplus.png',
                              fit: BoxFit.fill,
                              width: dimension['width']!,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            width: dimension['width']!,
                            decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("agPlusPoinstHeader")
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600, fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      const Divider(
                                        color: AppColor.notificationBgColor,
                                        thickness: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Image.asset('assets/images/location.png'),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("agPlusPoint1")
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w500, height: 1.3),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Image.asset('assets/images/hut.png'),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("agPlusPoint2")
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w500, height: 1.3),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Image.asset('assets/images/cloud.png'),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("agPlusPoint3")
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w500, height: 1.3),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Image.asset('assets/images/plant.png'),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("agPlusPoint4")
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w500, height: 1.3),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Image.asset('assets/images/drone.png'),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValue("agPlusPoint5")
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w500, height: 1.3),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () => Utils.model(context, const AllPlotsScreen()),
                          child: GradientButton(
                              height: dimension['height']! * 0.10,
                              width: dimension['width']!,
                              title: AppLocalization.of(context)
                                  .getTranslatedValue("agPlusContinue")
                                  .toString())),
                      SizedBox(
                        height: 40,
                      )
                      // title: AppLocalization.of(context)
                      //     .getTranslatedValue("comingSoon")
                      //     .toString())),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
