import 'dart:developer';

class Plots {
  String id;
  String fieldNo;
  String fieldName;
  String cropId;
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
  String? currentStageId;

  Plots(
      {this.id = "1",
      required this.fieldNo,
      required this.fieldName,
      required this.cropId,
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
      this.ndviId,
      this.currentStageId});

  factory Plots.fromJson(Map<String, dynamic> json) {
    return Plots(
        cropImage: json['cropImage'],
        cropId: json["crop"] != null ? json['crop']['_id'] : "N/A",
        cropName: json["crop"] != null ? json['crop']['name'] : "N/A",
        cropNameHi: json["crop"] != null ? json['crop']['name_hi'] : "N/A",
        area: json['area'],
        latitude: json['cordinates']?['latitude'],
        longitude: json['cordinates']?['longitude'],
        fieldName: json['feildName'] ?? '',
        fieldNo: json['feildNo']?.toString() ?? "1",
        soilType: json['soilType'] ?? '',
        sowingDate: json['sowingDate'],
        id: json['_id'],
        isMonitoringOpted: json["isMarkedForNdviMonitoring"],
        agristick: json['agristick'],
        currentStageId: json["currentCropStage"]?["_id"] ?? "",
        ndviId: json["ndvi_ref"]);
  }
}
