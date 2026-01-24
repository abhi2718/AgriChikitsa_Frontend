import 'dart:developer';

import 'package:agriChikitsa/model/weather_model.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../model/plots.dart';
import '../../../../repository/AG+.repo/ag_plus_repository.dart';
import '../../../../utils/utils.dart';

class WeatherViewModel with ChangeNotifier {
  final _agPlusRepository = AGPlusRepository();
  dynamic latestWeatherData;
  late String date;
  late String time;
  bool getWeatherDataLoader = true;
  bool getPredictedDataLoader = false;
  bool isPdfDownloading = false;
  List<PredictedData> predictedDataList = [];
  List<PredictedHourlyData> predictedHourlyDataList = [];
  void setWeatherDataLoader(value) {
    getWeatherDataLoader = value;
  }

  void setPredictedDataLoader(value) {
    getPredictedDataLoader = value;
  }

  void getCurrentDistrictWeather(BuildContext context, String district) async {
    setWeatherDataLoader(true);
    try {
      final data = await _agPlusRepository.getCurrentDistrictWeather(
          district, AppLocalization.of(context).locale.toString());
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

  void getCurrentWeather(BuildContext context, Plots currentField, String lang) async {
    setWeatherDataLoader(true);
    try {
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
      predictedDataList.clear();
      predictedHourlyDataList.clear();
      final data = await _agPlusRepository.getPredictedWeather(
          currentField.latitude, currentField.longitude, lang);
      predictedDataList = (data["forecast"]['forecastday'] as List)
          .map((day) => PredictedData.fromJson(day))
          .toList();

      final now = DateTime.now();
      predictedHourlyDataList = (data['forecast']['forecastday'][0]['hour'] as List)
          .map((hour) => PredictedHourlyData.fromJson(hour))
          .where((hourData) {
        final parsedTime = DateFormat('hh:mm a').parse(hourData.time);
        final hourlyDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          parsedTime.hour,
          parsedTime.minute,
        );
        return hourlyDateTime.isAfter(now) || hourlyDateTime.hour == now.hour;
      }).toList();
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

  String encodeForImd(String value) {
    return Uri.encodeComponent(value).replaceAll('+', '%20');
  }

  void toastMessage(BuildContext context) {
    Utils.toastMessage(AppLocalization.of(context).getTranslatedValue("errorMessage").toString());
  }

  Future<void> downloadWeatherPdf({
    required BuildContext context,
    required String state,
    required String district,
  }) async {
    if (isPdfDownloading) return;

    isPdfDownloading = true;
    notifyListeners();

    try {
      final encodedState = encodeForImd(state);
      final encodedDistrict = encodeForImd(district);

      final url = 'https://imdagrimet.gov.in/Services/DistrictBulletin.php'
          '?state=$encodedState'
          '&district=$encodedDistrict'
          '&language=English';

      final response = await http.get(
        Uri.parse(url),
        headers: {"Accept": "application/pdf"},
      );

      if (response.statusCode != 200 && context.mounted) {
        toastMessage(context);
        return;
      }

      final contentType = response.headers['content-type']?.toLowerCase() ?? '';
      if (!contentType.contains('application/pdf') && context.mounted) {
        toastMessage(context);
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final safeDistrict = district.replaceAll(" ", "_");
      final filePath = '${dir.path}/Weather_Bulletin_$safeDistrict.pdf';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await OpenFile.open(filePath);
    } catch (e) {
      debugPrint("PDF error: $e");
      if (context.mounted) toastMessage(context);
    } finally {
      isPdfDownloading = false;
      notifyListeners();
    }
  }
}
