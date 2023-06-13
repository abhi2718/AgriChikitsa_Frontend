class JankariSubCategoryPostModel {
  String id;
  String subCategoryId;
  String title;
  String description;
  String imageUrl;
  String youtubeUrl;
  DateTime createdAt;
  DateTime updatedAt;

  JankariSubCategoryPostModel({
    required this.id,
    required this.subCategoryId,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.youtubeUrl = "",
    required this.createdAt,
    required this.updatedAt,
  });

  factory JankariSubCategoryPostModel.fromJson(Map<String, dynamic> json) {
    return JankariSubCategoryPostModel(
      id: json['_id'],
      subCategoryId: json['subCategoryId'],
      title: json['title'],
      imageUrl: json['imgUrl'],
      description: json['description'],
      youtubeUrl: json.containsKey('youtubeUrl') ? json['youtubeUrl'] : "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
