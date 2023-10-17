class SelectCrop {
  String name;
  String backgroundImage;
  bool isSelected;

  SelectCrop({
    required this.name,
    required this.backgroundImage,
    this.isSelected = false,
  });

  factory SelectCrop.fromJson(Map<String, dynamic> json) {
    return SelectCrop(
      name: json['name'],
      backgroundImage: json['image'],
    );
  }
}
