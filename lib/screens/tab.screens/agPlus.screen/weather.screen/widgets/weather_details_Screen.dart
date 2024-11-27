import 'dart:math';

import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/weather_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/weather_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../../../utils/utils.dart';

class WeatherScreenDetails extends StatefulWidget {
  const WeatherScreenDetails({super.key, required this.useViewModel});
  final WeatherViewModel useViewModel;

  @override
  State<WeatherScreenDetails> createState() => _WeatherScreenDetailsState();
}

class _WeatherScreenDetailsState extends State<WeatherScreenDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              width: double.infinity, // Fill width
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff201C1C),
                    Color(0xff31671E),
                  ],
                ),
              ),
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
                          '${widget.useViewModel.latestWeatherData.region}, ${widget.useViewModel.latestWeatherData.countryName}',
                          style: const TextStyle(color: AppColor.whiteColor),
                        ),
                        const SizedBox.shrink()
                      ],
                    ),
                  ),
                  Text(
                    widget.useViewModel.date,
                    style: const TextStyle(fontWeight: FontWeight.w400, color: AppColor.whiteColor),
                  ),
                  SvgPicture.asset(
                    'assets/svg/rainy.svg',
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Text(
                    '${widget.useViewModel.latestWeatherData.temp_c.toString()}º C',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: AppColor.whiteColor, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.useViewModel.latestWeatherData.condition,
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
                        "${AppLocalization.of(context).getTranslatedValue("lastUpdated").toString()} ${widget.useViewModel.time}",
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColor.extraDark,
                unselectedLabelColor: Colors.black,
                indicatorColor: AppColor.extraDark,
                tabs: [
                  Tab(
                      text: AppLocalization.of(context)
                          .getTranslatedValue("presentDetailsWeather")
                          .toString()),
                  Tab(
                      text: AppLocalization.of(context)
                          .getTranslatedValue("predictedDetailsWeather")
                          .toString()),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PresentDetails(useViewModel: widget.useViewModel),
                  const PredictedDetails()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PresentDetails extends StatefulHookWidget {
  const PresentDetails({super.key, required this.useViewModel});
  final WeatherViewModel useViewModel;

  @override
  State<PresentDetails> createState() => _PresentDetailsState();
}

class _PresentDetailsState extends State<PresentDetails> {
  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    useEffect(() {
      if (weatherViewModel.predictedDataList.isEmpty) {
        weatherViewModel.getPredictedData(context, useViewModel.selectedPlot);
      }
    }, [useViewModel.selectedPlot]);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Consumer<WeatherViewModel>(builder: (context, provider, child) {
              return provider.getPredictedDataLoader
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            AppLocalization.of(context).getTranslatedValue("today").toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${provider.predictedDataList[0].minTemp}\u2103/${provider.predictedDataList[0].maxTemp}\u2103',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (true)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                leading: const Icon(Icons.thermostat, color: AppColor.iconColor),
                                title: Text(
                                  AppLocalization.of(context)
                                      .getTranslatedValue("avgTemp")
                                      .toString(),
                                ),
                                trailing: Text(
                                  "${provider.predictedDataList[0].avgTemp.toString()}\u2103",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                leading: const Icon(Icons.circle, color: Colors.blue),
                                title: Text(AppLocalization.of(context)
                                    .getTranslatedValue("humidity")
                                    .toString()), // Replace with your actual titles
                                trailing: Text(
                                  "${provider.predictedDataList[0].avgHumidity.toString()}%",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                leading: const Icon(Icons.circle, color: Colors.blue),
                                title: Text(AppLocalization.of(context)
                                    .getTranslatedValue("chancesOfRain")
                                    .toString()),
                                trailing: Text(
                                  "${provider.predictedDataList[0].dailyChanceOfRain.toString()}%",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                leading: const Icon(Icons.circle, color: Colors.blue),
                                title: Text(AppLocalization.of(context)
                                    .getTranslatedValue("rain")
                                    .toString()),
                                trailing: Text(
                                  "${provider.predictedDataList[0].totalPrecipMm.toString()} mm",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                leading: const Icon(Icons.air, color: AppColor.iconColor),
                                title: Text(AppLocalization.of(context)
                                    .getTranslatedValue("maxWind")
                                    .toString()),
                                trailing: Text(
                                  "${provider.predictedDataList[0].maxWindKph.toString()} km/h",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                leading:
                                    const Icon(Icons.wb_sunny_outlined, color: AppColor.iconColor),
                                title: Text(AppLocalization.of(context)
                                    .getTranslatedValue("sunsriseSunset")
                                    .toString()),
                                trailing: Text(
                                  "${provider.predictedDataList[0].sunrise.toString()}/${provider.predictedDataList[0].sunset.toString()}",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                          ),
                      ],
                    );
            }),
          )
        ],
      ),
    );
  }
}

class PredictedDetails extends HookWidget {
  const PredictedDetails({super.key});
  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    useEffect(() {
      if (weatherViewModel.predictedDataList.isEmpty) {
        weatherViewModel.getPredictedData(context, useViewModel.selectedPlot);
      }
    }, [useViewModel.selectedPlot]);
    return SingleChildScrollView(
      child: Column(
        children: List.generate(weatherViewModel.predictedDataList.length, (index) {
          return PredictedWeatherTiles(
            predictedDetails: weatherViewModel.predictedDataList[index],
          );
        }),
      ),
    );
  }
}

class PredictedWeatherTiles extends StatefulWidget {
  final PredictedData predictedDetails;

  const PredictedWeatherTiles({Key? key, required this.predictedDetails}) : super(key: key);

  @override
  _PredictedWeatherTilesState createState() => _PredictedWeatherTilesState();
}

class _PredictedWeatherTilesState extends State<PredictedWeatherTiles> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime predictedDate = DateTime.parse(widget.predictedDetails.date);
    String displayDate = (predictedDate.year == today.year &&
            predictedDate.month == today.month &&
            predictedDate.day == today.day)
        ? AppLocalization.of(context).getTranslatedValue("today").toString()
        : DateFormat("d MMM").format(predictedDate);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              displayDate,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.predictedDetails.minTemp}\u2103/${widget.predictedDetails.maxTemp}\u2103',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.remove : Icons.add,
                    color: AppColor.extraDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.thermostat, color: AppColor.iconColor),
                  title: Text(
                    AppLocalization.of(context).getTranslatedValue("avgTemp").toString(),
                  ),
                  trailing: Text(
                    "${widget.predictedDetails.avgTemp.toString()}\u2103",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.circle, color: Colors.blue),
                  title: Text(AppLocalization.of(context)
                      .getTranslatedValue("humidity")
                      .toString()), // Replace with your actual titles
                  trailing: Text(
                    "${widget.predictedDetails.avgHumidity.toString()}%",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.circle, color: Colors.blue),
                  title: Text(
                      AppLocalization.of(context).getTranslatedValue("chancesOfRain").toString()),
                  trailing: Text(
                    "${widget.predictedDetails.dailyChanceOfRain.toString()}%",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.circle, color: Colors.blue),
                  title: Text(AppLocalization.of(context).getTranslatedValue("rain").toString()),
                  trailing: Text(
                    "${widget.predictedDetails.totalPrecipMm.toString()} mm",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.air, color: AppColor.iconColor),
                  title: Text(AppLocalization.of(context).getTranslatedValue("maxWind").toString()),
                  trailing: Text(
                    "${widget.predictedDetails.maxWindKph.toString()} km/h",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.wb_sunny_outlined, color: AppColor.iconColor),
                  title: Text(
                      AppLocalization.of(context).getTranslatedValue("sunsriseSunset").toString()),
                  trailing: Text(
                    "${widget.predictedDetails.sunrise.toString()}/${widget.predictedDetails.sunset.toString()}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}
