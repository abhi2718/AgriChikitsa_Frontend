class Plots {
  String fieldName;
  String cropName;
  String cropImage;
  String area;
  bool isSelected;

  Plots({
    required this.fieldName,
    required this.cropName,
    required this.cropImage,
    required this.area,
    this.isSelected = false,
  });

  factory Plots.fromJson(Map<String, dynamic> json) {
    return Plots(
      cropImage: json['cropImage'],
      cropName: json['cropName'],
      area: json['area'],
      fieldName: json['feildName'],
    );
  }
}
