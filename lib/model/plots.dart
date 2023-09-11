class Plots {
  String id;
  String fieldName;
  String cropName;
  String cropImage;
  String area;
  String createdAt;
  String updatedAt;
  bool isSelected;

  Plots({
    required this.id,
    required this.fieldName,
    required this.cropName,
    required this.cropImage,
    required this.area,
    required this.createdAt,
    required this.updatedAt,
    this.isSelected = false,
  });

  factory Plots.fromJson(Map<String, dynamic> json) {
    return Plots(
      cropImage: json['cropImage'],
      cropName: json['cropName'],
      area: json['area'],
      fieldName: json['feildName'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
