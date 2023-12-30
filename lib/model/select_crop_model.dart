class SelectCrop {
  String name;
  String name_hi;
  String backgroundImage;
  bool isSelected;

  SelectCrop({
    required this.name,
    required this.name_hi,
    required this.backgroundImage,
    this.isSelected = false,
  });

  factory SelectCrop.fromJson(Map<String, dynamic> json) {
    return SelectCrop(
      name: json['name'],
      name_hi: json['name_hi'],
      backgroundImage: json['image'],
    );
  }
}
