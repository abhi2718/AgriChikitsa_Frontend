import 'dart:developer';

import 'package:agriChikitsa/model/weather_model.dart';
import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
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
  void setWeatherDataLoader(bool value) {
    getWeatherDataLoader = value;
  }

  void setPredictedDataLoader(bool value) {
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
      final forecastdayData = data["forecast"] != null ? data["forecast"]['forecastday'] : null;
      predictedDataList = (forecastdayData as List<dynamic>?)
              ?.map((day) => PredictedData.fromJson(day))
              .toList() ??
          [];

      final now = DateTime.now();
      final hourData = (forecastdayData != null && (forecastdayData as List).isNotEmpty)
          ? forecastdayData[0]['hour']
          : null;
      predictedHourlyDataList = (hourData as List<dynamic>?)
              ?.map((hour) => PredictedHourlyData.fromJson(hour))
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
          }).toList() ??
          [];
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

  //Functions for KVI PDF in Jankari section
  void toastMessage(BuildContext context) {
    Utils.toastMessage(AppLocalization.of(context).getTranslatedValue("errorMessage").toString());
  }

  Future<http.Response?> _fetchWeatherPdf(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Accept": "application/pdf"},
      );

      final contentType = response.headers['content-type']?.toLowerCase() ?? '';

      if (response.statusCode == 200 && contentType.contains('application/pdf')) {
        return response;
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
    return null;
  }

  Future<bool?> _showLanguageFallbackDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(AppLocalization.of(context).getTranslatedValue("oopsTitle").toString()),
          content: const Text(
              "यह कृषि सलाह हिंदी में उपलब्ध नहीं है। क्या आप इसे अंग्रेज़ी में देखना चाहते हैं?"),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(foregroundColor: AppColor.errorColor),
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                AppLocalization.of(context).getTranslatedValue("no").toString(),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.extraDark, foregroundColor: AppColor.whiteColor),
              child: Text(AppLocalization.of(context).getTranslatedValue("yes").toString()),
            ),
          ],
        );
      },
    );
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

      final lang = AppLocalization.of(context).locale.toString();

      String baseUrl = 'https://imdagrimet.gov.in/Services/DistrictBulletin.php'
          '?state=$encodedState'
          '&district=$encodedDistrict';

      // 👉 Try Hindi first
      if (lang == "hi") {
        final hindiUrl = "$baseUrl&language=Local";

        final hindiResponse = await _fetchWeatherPdf(hindiUrl);

        if (hindiResponse != null) {
          await _saveAndOpenPdf(hindiResponse, district);
          return;
        }

        // ❗ Hindi not available → ask user
        if (context.mounted) {
          final shouldOpenEnglish = await _showLanguageFallbackDialog(context);

          if (shouldOpenEnglish != true) return;
        }

        // 👉 fallback to English
        final englishUrl = "$baseUrl&lanugage=English";
        final englishResponse = await _fetchWeatherPdf(englishUrl);

        if (englishResponse != null) {
          await _saveAndOpenPdf(englishResponse, district);
          return;
        }
      } else {
        // 👉 English directly
        final englishUrl = "$baseUrl&lanugage=English";
        final response = await _fetchWeatherPdf(englishUrl);

        if (response != null) {
          await _saveAndOpenPdf(response, district);
          return;
        }
      }

      // ❌ Both failed
      if (context.mounted) toastMessage(context);
    } catch (e) {
      debugPrint("PDF error: $e");
      if (context.mounted) toastMessage(context);
    } finally {
      isPdfDownloading = false;
      notifyListeners();
    }
  }

  Future<void> _saveAndOpenPdf(http.Response response, String district) async {
    final dir = await getApplicationDocumentsDirectory();
    final safeDistrict = district.replaceAll(" ", "_");
    final filePath = '${dir.path}/Weather_Bulletin_$safeDistrict.pdf';

    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    await OpenFile.open(filePath);
  }
}
