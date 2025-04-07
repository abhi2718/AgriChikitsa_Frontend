import 'dart:developer';

class Plots {
  String id;
  String fieldName;
  String cropName;
  String cropNameHi;
  String cropImage;
  String latitude;
  String longitude;
  String area;
  String soilType;
  dynamic sowingDate;
  bool isSelected;
  dynamic agristick;
  bool isMonitoringOpted;
  String? ndviId;

  Plots(
      {this.id = "1",
      required this.fieldName,
      required this.cropName,
      required this.cropNameHi,
      required this.latitude,
      required this.longitude,
      required this.cropImage,
      required this.area,
      required this.soilType,
      required this.sowingDate,
      this.isSelected = false,
      this.isMonitoringOpted = false,
      this.agristick,
      this.ndviId});

  factory Plots.fromJson(Map<String, dynamic> json) {
    return Plots(
        cropImage: json['cropImage'],
        cropName: json["crop"] != null ? json['crop']['name'] : "N/A",
        cropNameHi: json["crop"] != null ? json['crop']['name_hi'] : "N/A",
        area: json['area'],
        latitude: json['cordinates']['latitude'],
        longitude: json['cordinates']['longitude'],
        fieldName: json['feildName'],
        soilType: json['soilType'],
        sowingDate: json['sowingDate'],
        id: json['_id'],
        isMonitoringOpted: json["isMarkedForNdviMonitoring"],
        agristick: json['agristick'],
        ndviId: json["ndvi_ref"]);
  }
}
