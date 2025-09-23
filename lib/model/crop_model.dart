class CropRef {
  final String id;
  final String name;
  final String nameHi;

  CropRef({
    required this.id,
    required this.name,
    required this.nameHi,
  });

  factory CropRef.fromJson(Map<String, dynamic> json) {
    return CropRef(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      nameHi: json['name_hi'] ?? '',
    );
  }
}
