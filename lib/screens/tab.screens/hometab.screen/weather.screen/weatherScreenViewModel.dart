import 'package:agriChikitsa/repository/check_prices.repo/check_prices_repository.dart';
import 'package:agriChikitsa/repository/weather.repo/weather_repository.dart';
import 'package:flutter/material.dart';

class WeatherViewModel with ChangeNotifier {
  final _weatherRepository = WeatherRepository();

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
