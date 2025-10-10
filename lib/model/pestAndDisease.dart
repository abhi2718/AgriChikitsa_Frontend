class PestDiseaseData {
  final List<PestDiseaseObj> pests;
  final List<PestDiseaseObj> diseases;

  PestDiseaseData({
    required this.pests,
    required this.diseases,
  });

  factory PestDiseaseData.fromJson(Map<String, dynamic> json) {
    return PestDiseaseData(
      pests:
          (json['pests'] as List<dynamic>?)?.map((e) => PestDiseaseObj.fromJson(e)).toList() ?? [],
      diseases:
          (json['diseases'] as List<dynamic>?)?.map((e) => PestDiseaseObj.fromJson(e)).toList() ??
              [],
    );
  }
}

class PestDiseaseObj {
  final String id;
  final List<String> images;
  final String nameEn;
  final String nameHi;
  final String contentEn;
  final String contentHi;
  final String audioEn;
  final String audioHi;
  final String nameSciEn;
  final String nameSciHi;

  PestDiseaseObj({
    required this.id,
    required this.images,
    required this.nameEn,
    required this.nameHi,
    required this.contentEn,
    required this.contentHi,
    required this.audioEn,
    required this.audioHi,
    required this.nameSciEn,
    required this.nameSciHi,
  });

  factory PestDiseaseObj.fromJson(Map<String, dynamic> json) {
    final sciName = json['name_sci'] ?? '';
    return PestDiseaseObj(
      id: json["_id"] ?? '',
      images: List<String>.from(json['images'] ?? []),
      nameEn: json['name_en'] ?? '',
      nameHi: json['name_hi'] ?? '',
      contentEn: json['content_en'] ?? '',
      contentHi: json['content_hi'] ?? '',
      audioEn: json['audio_en'] ?? '',
      audioHi: json['audio_hi'] ?? '',
      nameSciEn: sciName,
      nameSciHi: sciName,
    );
  }
}
