class Plots {
  String id;
  String fieldNo;
  String fieldName;
  String? cropId;
  String cropName;
  String cropNameHi;
  String plotImage;
  String? cropImage;
  String latitude;
  String longitude;
  String area;
  String soilType;
  dynamic sowingDate;
  dynamic sowingSeason;
  bool isSelected;
  dynamic agristick;
  bool isMonitoringOpted;
  String? ndviId;
  String? currentStageId;
  bool isHarvesting;
  bool kharchaKamaiRecord;
  String? cropHistoryId;

  Plots(
      {this.id = "1",
      required this.fieldNo,
      required this.fieldName,
      this.cropId,
      this.cropName = "N/A",
      this.cropNameHi = "N/A",
      required this.latitude,
      required this.longitude,
      required this.plotImage,
      this.cropImage,
      this.area = "N/A",
      required this.soilType,
      this.sowingDate,
      this.sowingSeason,
      this.isSelected = false,
      this.isMonitoringOpted = false,
      this.agristick,
      this.ndviId,
      this.currentStageId,
      this.isHarvesting = false,
      this.kharchaKamaiRecord = false,
      this.cropHistoryId});

  factory Plots.fromJson(Map<String, dynamic> json) {
    return Plots(
        plotImage: json['cropImage'],
        cropImage: json['crop']?['image'],
        cropId: json['crop']?['_id'],
        cropName: json["crop"] != null ? json['crop']['name'] : "N/A",
        cropNameHi: json["crop"] != null ? json['crop']['name_hi'] : "N/A",
        area: json['area'] ?? "N/A",
        latitude: json['cordinates']?['latitude'],
        longitude: json['cordinates']?['longitude'],
        fieldName: json['feildName'] ?? '',
        fieldNo: json['feildNo']?.toString() ?? "1",
        soilType: json['soilType'] ?? '',
        sowingDate: json['sowingDate'],
        sowingSeason: json['sowingSeason'] ?? '',
        id: json['_id'],
        isMonitoringOpted: json["isMarkedForNdviMonitoring"],
        agristick: json['agristick'],
        currentStageId: json["currentCropStage"]?["_id"] ?? "",
        ndviId: json["ndvi_ref"],
        isHarvesting: json["isHarvesting"] ?? false,
        kharchaKamaiRecord: json["kharchaKamaiRecord"] ?? false,
        cropHistoryId: json["activeCropHistoryId"] ?? "");
  }
}
