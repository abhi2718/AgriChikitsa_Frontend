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

class YieldUnit {
  final String value;
  final String labelEn;
  final String labelHi;

  YieldUnit({
    required this.value,
    required this.labelEn,
    required this.labelHi,
  });

  String getLabel(String locale) {
    return locale.startsWith('hi') ? labelHi : labelEn;
  }
}
