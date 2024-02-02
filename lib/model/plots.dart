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

  Plots({
    this.id = "1",
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
    this.agristick = null,
  });

  factory Plots.fromJson(Map<String, dynamic> json) {
    return Plots(
        cropImage: json['cropImage'],
        cropName: json['crop']['name'],
        cropNameHi: json['crop']['name_hi'],
        area: json['area'],
        latitude: json['cordinates']['latitude'],
        longitude: json['cordinates']['longitude'],
        fieldName: json['feildName'],
        soilType: json['soilType'],
        sowingDate: json['sowingDate'],
        id: json['_id'],
        agristick: json['agristick']);
  }
}
