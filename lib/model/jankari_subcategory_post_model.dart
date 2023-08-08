class JankariSubCategoryPostModel {
  String id;
  String subCategoryId;
  String title;
  String hindiTitle;
  String description;
  String hindiDescription;
  String imageUrl;
  String youtubeUrl;
  DateTime createdAt;
  DateTime updatedAt;
  bool isLiked;
  bool isDisLiked;

  JankariSubCategoryPostModel(
      {required this.id,
      required this.subCategoryId,
      required this.title,
      required this.hindiTitle,
      required this.description,
      required this.hindiDescription,
      required this.imageUrl,
      this.youtubeUrl = "",
      required this.createdAt,
      required this.updatedAt,
      this.isLiked = false,
      this.isDisLiked = false});

  factory JankariSubCategoryPostModel.fromJson(Map<String, dynamic> json) {
    return JankariSubCategoryPostModel(
        id: json['_id'],
        subCategoryId: json['subCategoryId'],
        title: json['title'],
        hindiTitle: json['hindiTitle'],
        imageUrl: json['imgUrl'],
        description: json['description'],
        hindiDescription: json['hindiDescription'],
        youtubeUrl: json.containsKey('youtubeUrl') ? json['youtubeUrl'] : "",
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        isLiked: json['isLike'],
        isDisLiked: json['isDisLike']);
  }
}
