import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/weather_model.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/ag_plus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/weather.screen/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Image.network("https:${widget.useViewModel.latestWeatherData.icon}")),
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
                  Text(
                    "${AppLocalization.of(context).getTranslatedValue("lastUpdated").toString()} ${widget.useViewModel.time}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: AppColor.whiteColor, fontSize: 15),
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
    final lang = AppLocalization.of(context).locale.toString();
    useEffect(() {
      weatherViewModel.getPredictedData(context, useViewModel.selectedPlot, lang);
    }, [useViewModel.selectedPlot]);
    return SingleChildScrollView(
      child: Consumer<WeatherViewModel>(builder: (context, provider, child) {
        return provider.getPredictedDataLoader
            ? SizedBox(
                height: 300,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.extraDark,
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.predictedHourlyDataList.length,
                      itemBuilder: (context, index) {
                        final data = provider.predictedHourlyDataList[index];
                        return GestureDetector(
                            onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColor.whiteColor,
                                    title: Text(data.time),
                                    titleTextStyle: const TextStyle(
                                        fontSize: 18,
                                        color: AppColor.darkBlackColor,
                                        fontWeight: FontWeight.w500),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.network(data.conditionIcon),
                                            const SizedBox(
                                              width: 34,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${data.tempC}°C',
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      color: AppColor.darkBlackColor,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                                Text(
                                                  data.conditionText,
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      color: AppColor.darkBlackColor,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalization.of(context)
                                                  .getTranslatedValue("maxWind")
                                                  .toString(),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              "${data.windSpeedKph} km/h",
                                              style: const TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalization.of(context)
                                                  .getTranslatedValue("humidity")
                                                  .toString(),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              "${data.humidity}%",
                                              style: const TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalization.of(context)
                                                  .getTranslatedValue("willItRain")
                                                  .toString(),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              data.willItRain == 1
                                                  ? AppLocalization.of(context)
                                                      .getTranslatedValue("yes")
                                                      .toString()
                                                  : AppLocalization.of(context)
                                                      .getTranslatedValue("no")
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalization.of(context)
                                                  .getTranslatedValue("chancesOfRain")
                                                  .toString(),
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              "${data.chanceOfRain}%",
                                              style: const TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            child: Card(
                              color: AppColor.whiteColor,
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColor.whiteColor,
                                ),
                                width: 150,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data.time, // Display time in 12-hour format
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Image.network(data.conditionIcon, height: 50, width: 50),
                                    const SizedBox(height: 8),
                                    Text('${data.tempC}°C',
                                        style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text('${data.windSpeedKph} kph',
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
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
                      child: Column(
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
                                    style:
                                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                    style:
                                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                    style:
                                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                    style:
                                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                    style:
                                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  leading: const Icon(Icons.wb_sunny_outlined,
                                      color: AppColor.iconColor),
                                  title: Text(AppLocalization.of(context)
                                      .getTranslatedValue("sunsriseSunset")
                                      .toString()),
                                  trailing: Text(
                                    "${provider.predictedDataList[0].sunrise.toString()}/${provider.predictedDataList[0].sunset.toString()}",
                                    style:
                                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                            ),
                        ],
                      )),
                ],
              );
      }),
    );
  }
}

class PredictedDetails extends HookWidget {
  const PredictedDetails({super.key});
  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    final lang = AppLocalization.of(context).locale.toString();
    useEffect(() {
      if (weatherViewModel.predictedDataList.isEmpty) {
        weatherViewModel.getPredictedData(context, useViewModel.selectedPlot, lang);
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
