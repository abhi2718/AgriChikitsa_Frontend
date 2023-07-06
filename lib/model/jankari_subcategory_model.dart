class JankariSubCategoryModel {
  String id;
  String categoryId;
  String name;
  String hindiName;
  String description;
  String backgroundImage;
  String icon;
  DateTime createdAt;
  DateTime updatedAt;

  JankariSubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.hindiName,
    required this.description,
    required this.backgroundImage,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JankariSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return JankariSubCategoryModel(
      id: json['_id'],
      categoryId: json['categoryId'],
      name: json['name'],
      hindiName: json['hindiName'],
      description: json['description'],
      backgroundImage: json['backgroundImage'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
