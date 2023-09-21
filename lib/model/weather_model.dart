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

  WeatherData({
    required this.region,
    required this.countryName,
    required this.temp_c,
    required this.condition,
    required this.wind_kph,
    required this.humidity,
    required this.vis_km,
    required this.last_updated,
    required this.localtime,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
        region: json['location']['region'],
        countryName: json['location']['country'],
        temp_c: json['current']['temp_c'],
        condition: json['current']['condition']['text'],
        wind_kph: json['current']['wind_kph'],
        humidity: json['current']['humidity'],
        vis_km: json['current']['vis_km'],
        last_updated: json['current']['last_updated'],
        localtime: json['location']['localtime']);
  }
}
