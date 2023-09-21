import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/weather.screen/weather_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/weather.screen/widgets/weather_details_Screen.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../model/plots.dart';
import '../../../../../utils/utils.dart';

class WeatherScreen extends HookWidget {
  WeatherScreen({super.key, required this.currentSelectedPlot});
  Plots currentSelectedPlot;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.getCurrentWeather(context, currentSelectedPlot);
    }, [currentSelectedPlot]);
    return Consumer<WeatherViewModel>(builder: (context, provider, child) {
      return provider.getWeatherDataLoader
          ? Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Skeleton(
                        height: dimension["height"]! * 0.03,
                        width: dimension["width"]! * 0.30),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    clipBehavior: Clip.antiAlias,
                    child: Skeleton(
                        height: dimension["height"]! * 0.30,
                        width: dimension["width"]!),
                  ),
                ],
              ),
            )
          : InkWell(
              onTap: () {
                Utils.model(
                    context,
                    WeatherScreenDeatils(
                      useViewModel: provider,
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.place,
                            color: AppColor.extraDark,
                          ),
                          Text(
                            '${provider.latestWeatherData.region}, ${provider.latestWeatherData.countryName}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        clipBehavior: Clip.antiAlias,
                        elevation: 10.0,
                        child: Container(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 24, bottom: 18),
                            height: dimension["height"]! * 0.30,
                            width: dimension["width"]!,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xff201C1C),
                                      Color(0xff31671E)
                                    ])),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      provider.date,
                                      style: TextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/rainy.svg',
                                        height: dimension['height']! * 0.15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${provider.latestWeatherData.temp_c.toString()}º C',
                                            style: TextStyle(
                                                color: AppColor.whiteColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            provider
                                                .latestWeatherData.condition,
                                            style: TextStyle(
                                                color: AppColor.whiteColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Last update ${provider.time}",
                                      style: TextStyle(
                                          color: AppColor.whiteColor,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        provider.getCurrentWeather(
                                            context, currentSelectedPlot);
                                      },
                                      child: Icon(
                                        Icons.refresh,
                                        color: AppColor.whiteColor,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
