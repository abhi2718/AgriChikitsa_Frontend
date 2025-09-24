import 'dart:developer';

import 'package:intl/intl.dart';

class WeatherData {
  String region;
  String countryName;
  double temp_c;
  String condition;
  double wind_kph;
  int humidity;
  double vis_km;
  String last_updated;
  String localtime;
  String pressure_mb;
  String icon;

  WeatherData(
      {required this.region,
      required this.countryName,
      required this.temp_c,
      required this.condition,
      required this.wind_kph,
      required this.humidity,
      required this.vis_km,
      required this.last_updated,
      required this.localtime,
      required this.icon,
      required this.pressure_mb});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
        region: json['location']['region'],
        countryName: json['location']['country'],
        temp_c: json['current']['temp_c'],
        condition: json['current']['condition']['text'],
        icon: json['current']['condition']['icon'],
        wind_kph: json['current']['wind_kph'],
        humidity: json['current']['humidity'],
        vis_km: json['current']['vis_km'],
        last_updated: json['current']['last_updated'],
        localtime: json['location']['localtime'],
        pressure_mb: json['current']['pressure_mb'].toString());
  }
}

class PredictedData {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String sunrise;
  final String sunset;
  final int avgHumidity;
  final int dailyChanceOfRain;
  final double totalPrecipMm;
  final double maxWindKph;
  final double avgTemp;

  PredictedData({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.sunrise,
    required this.sunset,
    required this.avgHumidity,
    required this.dailyChanceOfRain,
    required this.totalPrecipMm,
    required this.maxWindKph,
    required this.avgTemp,
  });

  factory PredictedData.fromJson(Map<String, dynamic> json) {
    return PredictedData(
      date: json['date'],
      maxTemp: json['day']['maxtemp_c'],
      minTemp: json['day']['mintemp_c'],
      sunrise: json['astro']['sunrise'],
      sunset: json['astro']['sunset'],
      avgHumidity: json['day']['avghumidity'],
      dailyChanceOfRain: json['day']['daily_chance_of_rain'],
      totalPrecipMm: json['day']['totalprecip_mm'],
      maxWindKph: json['day']['maxwind_kph'],
      avgTemp: json['day']['avgtemp_c'],
    );
  }
}

class PredictedHourlyData {
  final String time;
  final double tempC;
  final String conditionText;
  final String conditionIcon;
  final double windSpeedKph;
  final int humidity;
  final int willItRain;
  final int chanceOfRain;

  PredictedHourlyData({
    required this.time,
    required this.tempC,
    required this.conditionText,
    required this.conditionIcon,
    required this.windSpeedKph,
    required this.humidity,
    required this.willItRain,
    required this.chanceOfRain,
  });

  factory PredictedHourlyData.fromJson(Map<String, dynamic> json) {
    // Parsing time to 12-hour format
    final DateTime parsedTime = DateTime.parse(json['time']);
    final String formattedTime = DateFormat('hh:mm a').format(parsedTime);

    return PredictedHourlyData(
      time: formattedTime,
      tempC: json['temp_c'],
      conditionText: json['condition']['text'],
      conditionIcon: 'https:${json['condition']['icon']}',
      windSpeedKph: json['wind_kph'],
      humidity: json['humidity'],
      willItRain: json['will_it_rain'],
      chanceOfRain: json['chance_of_rain'],
    );
  }
}
