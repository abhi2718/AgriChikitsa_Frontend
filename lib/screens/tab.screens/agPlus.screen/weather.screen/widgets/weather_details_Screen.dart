import 'dart:math';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/weather_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remixicon/remixicon.dart';

import '../../../../../utils/utils.dart';

class WeatherScreenDetails extends StatelessWidget {
  const WeatherScreenDetails({super.key, required this.useViewModel});
  final WeatherViewModel useViewModel;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              width: dimension["width"],
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xff201C1C), Color(0xff31671E)])),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColor.whiteColor,
                          ),
                        ),
                        Text(
                          '${useViewModel.latestWeatherData.region}, ${useViewModel.latestWeatherData.countryName}',
                          style: const TextStyle(color: AppColor.whiteColor),
                        ),
                        const Icon(
                          Icons.more_horiz,
                          color: AppColor.whiteColor,
                        )
                      ],
                    ),
                  ),
                  Text(
                    useViewModel.date,
                    style: const TextStyle(fontWeight: FontWeight.w400, color: AppColor.whiteColor),
                  ),
                  SvgPicture.asset(
                    'assets/svg/rainy.svg',
                    height: dimension['height']! * 0.15,
                  ),
                  Text(
                    '${useViewModel.latestWeatherData.temp_c.toString()}º C',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: AppColor.whiteColor, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    useViewModel.latestWeatherData.condition,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AppColor.whiteColor, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${AppLocalization.of(context).getTranslatedValue("lastUpdated").toString()} ${useViewModel.time}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: AppColor.whiteColor, fontSize: 15),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.refresh,
                        color: AppColor.whiteColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: dimension['height']! * 0.12,
                    width: dimension['width']! * 0.40,
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Transform.rotate(
                          angle: pi / 2,
                          child: const Icon(
                            Remix.blaze_line,
                            size: 34,
                            color: Color(0xff3C6EEF),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                useViewModel.latestWeatherData.vis_km.toString(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranslatedValue("visibility")
                                    .toString(),
                                style: const TextStyle(fontSize: 17, color: Color(0xff494343)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  WeatherCard(
                      title: AppLocalization.of(context).getTranslatedValue("pressure").toString(),
                      value: "${useViewModel.latestWeatherData.pressure_mb.toString()} mb",
                      imagePath: Remix.haze_2_line)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WeatherCard(
                      title: AppLocalization.of(context).getTranslatedValue("windSpeed").toString(),
                      value: "${useViewModel.latestWeatherData.wind_kph} km/h",
                      imagePath: Remix.windy_line),
                  WeatherCard(
                      title: AppLocalization.of(context).getTranslatedValue("humidity").toString(),
                      value: "${useViewModel.latestWeatherData.humidity.toString()}%",
                      imagePath: Remix.mist_line)
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
