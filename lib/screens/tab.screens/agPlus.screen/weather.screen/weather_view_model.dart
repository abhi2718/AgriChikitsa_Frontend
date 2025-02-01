import 'package:agriChikitsa/model/weather_model.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/plots.dart';
import '../../../../repository/AG+.repo/ag_plus_repository.dart';
import '../../../../utils/utils.dart';

class WeatherViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  dynamic latestWeatherData;
  late String date;
  late String time;
  bool getWeatherDataLoader = false;
  bool getPredictedDataLoader = false;
  List<PredictedData> predictedDataList = [];
  List<PredictedHourlyData> predictedHourlyDataList = [];
  setWeatherDataLoader(value) {
    getWeatherDataLoader = value;
  }

  setPredictedDataLoader(value) {
    getPredictedDataLoader = value;
  }

  void getCurrentWeather(BuildContext context, Plots currentField, String lang) async {
    setWeatherDataLoader(true);
    try {
      // Always fetch data from the API
      final data = await _agPlusRepository.getCurrentWeather(
          currentField.latitude, currentField.longitude, lang);
      latestWeatherData = WeatherData.fromJson(data);
      date = DateFormat('EEEE, d MMMM y', 'en_IN').format(DateTime.now());
      time = DateFormat('hh:mm a', 'en_US')
          .format(DateTime.parse(latestWeatherData.last_updated).toLocal());
      setWeatherDataLoader(false);
      notifyListeners();
    } catch (error) {
      setWeatherDataLoader(false);
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }

  void getPredictedData(BuildContext context, Plots currentField, String lang) async {
    setPredictedDataLoader(true);
    try {
      // Always fetch data from the API
      predictedDataList.clear();
      predictedHourlyDataList.clear();
      final data = await _agPlusRepository.getPredictedWeather(
          currentField.latitude, currentField.longitude, lang);
      predictedDataList = (data["forecast"]['forecastday'] as List)
          .map((day) => PredictedData.fromJson(day))
          .toList();
      predictedHourlyDataList = (data['forecast']['forecastday'][0]['hour'] as List)
          .map((hour) => PredictedHourlyData.fromJson(hour))
          .toList();
      setPredictedDataLoader(false);
      notifyListeners();
    } catch (error) {
      setPredictedDataLoader(false);
      if (kDebugMode) {
        if (context.mounted) {
          Utils.flushBarErrorMessage(
              AppLocalization.of(context).getTranslatedValue("alert").toString(),
              error.toString(),
              context);
        }
      }
    }
  }
}
