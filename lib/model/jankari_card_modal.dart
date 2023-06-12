class JankariCategoryModal {
  final String id;
  final String name;
  final String description;
  final String backgroundImage;
  final String icon;
  final String createdAt;
  final String updatedAt;
  bool isActive;

  JankariCategoryModal({
    required this.id,
    required this.name,
    required this.description,
    required this.backgroundImage,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = false,
  });

  factory JankariCategoryModal.fromJson(Map<String, dynamic> json) {
    return JankariCategoryModal(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      backgroundImage: json['backgroundImage'],
      icon: json['icon'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isActive: false,
    );
  }
}
