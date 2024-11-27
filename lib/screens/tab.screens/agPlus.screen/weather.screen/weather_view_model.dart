import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
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
  setWeatherDataLoader(value) {
    getWeatherDataLoader = value;
  }

  setPredictedDataLoader(value) {
    getPredictedDataLoader = value;
  }

  void getCurrentWeather(BuildContext context, Plots currentField) async {
    setWeatherDataLoader(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // Check if the data exists in local storage and the date is the same as today
      final storedDate = prefs.getString('weatherDate');
      final storedData = prefs.getString('weatherData');
      if (storedDate != null && storedDate == currentDate && storedData != null) {
        // Return the data from local storage if it's the same day
        latestWeatherData = WeatherData.fromJson(jsonDecode(storedData));
        date = DateFormat('EEEE, d MMMM y', 'en_IN').format(DateTime.now());
        time = DateFormat('hh:mm a', 'en_US')
            .format(DateTime.parse(latestWeatherData.last_updated).toLocal());
        setWeatherDataLoader(false);
        notifyListeners();
      } else {
        // Fetch data from the API if no data or data is from another day
        final lang = "en";
        final data = await _agPlusRepository.getCurrentWeather(
            currentField.latitude, currentField.longitude, lang);
        latestWeatherData = WeatherData.fromJson(data);
        date = DateFormat('EEEE, d MMMM y', 'en_IN').format(DateTime.now());
        time = DateFormat('hh:mm a', 'en_US')
            .format(DateTime.parse(latestWeatherData.last_updated).toLocal());

        // Save the data and the current date in local storage
        await prefs.setString('weatherDate', currentDate);
        await prefs.setString('weatherData', jsonEncode(data));

        setWeatherDataLoader(false);
        notifyListeners();
      }
    } catch (error) {
      setWeatherDataLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }

  void getPredictedData(BuildContext context, Plots currentField) async {
    setPredictedDataLoader(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Check if the data exists in local storage and the date is the same as today
      final storedDate = prefs.getString('predictedWeatherDate');
      final storedData = prefs.getString('predictedWeatherData');

      if (storedDate != null && storedDate == currentDate && storedData != null) {
        // Use the locally stored data if the date matches today's date
        final decodedData = jsonDecode(storedData);
        predictedDataList =
            (decodedData as List).map((day) => PredictedData.fromJson(day)).toList();
        setPredictedDataLoader(false);
        notifyListeners();
      } else {
        // Fetch new data from the API if no data or data is outdated
        predictedDataList.clear();
        final data = await _agPlusRepository.getPredictedWeather(
            currentField.latitude, currentField.longitude);
        predictedDataList = (data["forecast"]['forecastday'] as List)
            .map((day) => PredictedData.fromJson(day))
            .toList();

        // Save the new data and the current date in local storage
        await prefs.setString('predictedWeatherDate', currentDate);
        await prefs.setString('predictedWeatherData', jsonEncode(data["forecast"]['forecastday']));

        setPredictedDataLoader(false);
        notifyListeners();
      }
    } catch (error) {
      setPredictedDataLoader(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(
            AppLocalization.of(context).getTranslatedValue("alert").toString(),
            error.toString(),
            context);
      }
    }
  }
}
