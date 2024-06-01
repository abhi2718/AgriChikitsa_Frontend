import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/weather_model.dart';
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
  setWeatherDataLoader(value) {
    getWeatherDataLoader = value;
  }

  void getCurrentWeather(BuildContext context, Plots currentField) async {
    setWeatherDataLoader(true);
    try {
      final data =
          await _agPlusRepository.getCurrentWeather(currentField.latitude, currentField.longitude);
      latestWeatherData = WeatherData.fromJson(data);
      date = DateFormat('EEEE, d MMMM y', 'en_IN').format(DateTime.now());
      time = DateFormat('hh:mm a', 'en_US')
          .format(DateTime.parse(latestWeatherData.last_updated).toLocal());
      setWeatherDataLoader(false);
      notifyListeners();
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
}
