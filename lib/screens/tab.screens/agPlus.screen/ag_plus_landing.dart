import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/all_plots_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import 'agPlus_view_model.dart';

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
                      Container(
                        alignment: AlignmentDirectional.bottomCenter,
                        height: dimension['height']! * 0.32,
                        width: dimension['width']!,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/ag_plus_background.png'),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              AppLocalization.of(context)
                                  .getTranslatedValue("agPlusHeader")
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.whiteColor),
                            ),
                            Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("agPlusSubtitle")
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColor.whiteColor)),
                            const SizedBox(
                              height: 4,
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        height: dimension['height']! * 0.56,
                        width: dimension['width']!,
                        decoration: BoxDecoration(
                            color: AppColor.whiteColor, borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValue("agPlusPoinstHeader")
                                        .toString(),
                                    style:
                                        const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                  ),
                                  const Divider(
                                    color: AppColor.notificationBgColor,
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset('assets/images/location.png'),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("agPlusPoint1")
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset('assets/images/hut.png'),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("agPlusPoint2")
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset('assets/images/cloud.png'),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("agPlusPoint3")
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset('assets/images/plant.png'),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("agPlusPoint4")
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset('assets/images/drone.png'),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValue("agPlusPoint5")
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: InkWell(
                            onTap: () => Utils.model(context, const AllPlotsScreen()),
                            child: GradientButton(
                                height: dimension['height']! * 0.10,
                                width: dimension['width']!,
                                title: AppLocalization.of(context)
                                    .getTranslatedValue("agPlusContinue")
                                    .toString())),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
