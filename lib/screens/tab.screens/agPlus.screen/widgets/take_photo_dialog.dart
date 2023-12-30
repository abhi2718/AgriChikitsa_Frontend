import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agPlus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';

void takeAPhotoDialog(BuildContext context, dynamic dimension, AGPlusViewModel provider) {
  showDialog(
      context: context,
      barrierDismissible: provider.fieldImageLoader ? false : true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Consumer<AGPlusViewModel>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                height: dimension["height"]! * 0.50,
                child: provider.fieldImageLoader
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: AppColor.extraDark,
                      ))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/enable_camera.png',
                              fit: BoxFit.fill,
                              height: (dimension['height']! * 0.4) * 0.6,
                              width: dimension['width'],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("clickPlotImage")
                                .toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              takeLocationDialog(context, provider);
                            },
                            child: GradientButton(
                                height: (dimension['height']! * 0.4) * 0.2,
                                width: dimension['width']!,
                                title: AppLocalization.of(context)
                                    .getTranslatedValue("clickImageButton")
                                    .toString()),
                          )
                        ],
                      ),
              );
            },
          ),
        );
      });
}

void takeLocationDialog(BuildContext context, AGPlusViewModel provider) {
  final dimension = Utils.getDimensions(context, true);
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Consumer<AGPlusViewModel>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                height: dimension["height"]! * 0.50,
                child: provider.fieldImageLoader
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: AppColor.extraDark,
                      ))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/enable_location.png',
                              fit: BoxFit.fill,
                              height: (dimension['height']! * 0.4) * 0.6,
                              width: dimension['width'],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslatedValue("enableLocation")
                                .toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () => provider.mapCurrentLocation(context),
                            child: GradientButton(
                              height: (dimension['height']! * 0.4) * 0.2,
                              width: dimension['width']!,
                              title: AppLocalization.of(context)
                                  .getTranslatedValue("enableLocationButton")
                                  .toString(),
                              icon: Icons.place,
                            ),
                          )
                        ],
                      ),
              );
            },
          ),
        );
      });
}
