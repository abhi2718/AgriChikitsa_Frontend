import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../model/plots.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';

void showDeleteFieldDialog(BuildContext context, AGPlusViewModel useViewModel) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: BaseText(
            title: AppLocalization.of(context).getTranslatedValue("deleteField").toString(),
            style: const TextStyle()),
        content: BaseText(
            title: AppLocalization.of(context).getTranslatedValue("confirmDeleteField").toString(),
            style: const TextStyle()),
        actions: <Widget>[
          TextButton(
            child: BaseText(
                title: AppLocalization.of(context).getTranslatedValue("yes").toString(),
                style: const TextStyle(fontSize: 16, color: AppColor.extraDark)),
            onPressed: () {
              useViewModel.deleteField(context);
            },
          ),
          TextButton(
            child: BaseText(
                title: AppLocalization.of(context).getTranslatedValue("no").toString(),
                style: const TextStyle(fontSize: 16, color: AppColor.extraDark)),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.provider, required this.currentSelectedPlot});
  final dynamic provider;
  final Plots currentSelectedPlot;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 24, right: 24, top: 14, bottom: 14),
        width: dimension["width"]!,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff201C1C), Color(0xff31671E)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider.date,
                  style: const TextStyle(
                      color: AppColor.whiteColor, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/rainy.svg',
                    height: dimension['height']! * 0.15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${provider.latestWeatherData.temp_c.toString()}º C',
                          style: const TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          provider.latestWeatherData.condition,
                          style: const TextStyle(
                              color: AppColor.whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${AppLocalization.of(context).getTranslatedValue("lastUpdated").toString()} ${provider.time}",
                  style: const TextStyle(color: AppColor.whiteColor, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    provider.getCurrentWeather(context, currentSelectedPlot);
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: AppColor.whiteColor,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
