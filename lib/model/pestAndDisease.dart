class PestDiseaseData {
  final List<PestDiseaseObj> pests;
  final List<PestDiseaseObj> diseases;

  PestDiseaseData({
    required this.pests,
    required this.diseases,
  });

  factory PestDiseaseData.fromApiResponse(Map<String, dynamic> json) {
    final List<PestDiseaseObj> pests = [];
    final List<PestDiseaseObj> diseases = [];

    final list = json['data'] as List<dynamic>? ?? [];
    for (final item in list) {
      final obj = PestDiseaseObj.fromJson(item);

      if (obj.problemType == 'pest') {
        pests.add(obj);
      } else if (obj.problemType == 'disease') {
        diseases.add(obj);
      }
    }

    return PestDiseaseData(
      pests: pests,
      diseases: diseases,
    );
  }
}

class PestDiseaseObj {
  final String id;
  final String problemType;
  final List<PestDiseaseCarousel> carousel;
  final String nameEn;
  final String nameHi;
  final String nameSciEn;
  final String nameSciHi;
  final String? audioEn;
  final String? audioHi;
  final List<PestDiseaseDetail>? details;

  PestDiseaseObj({
    required this.id,
    required this.problemType,
    required this.carousel,
    required this.nameEn,
    required this.nameHi,
    required this.nameSciEn,
    required this.nameSciHi,
    this.audioEn,
    this.audioHi,
    this.details,
  });

  factory PestDiseaseObj.fromJson(Map<String, dynamic> json) {
    return PestDiseaseObj(
      id: json['_id'] ?? '',
      problemType: json['problemType'] ?? '',
      carousel: (json['images'] as List<dynamic>?)
              ?.map((e) => PestDiseaseCarousel.fromJson(e))
              .toList() ??
          [],
      nameEn: json['nameEn'] ?? '',
      nameHi: json['nameHi'] ?? '',
      nameSciEn: json['nameSciEn'] ?? '',
      nameSciHi: json['nameSciHi'] ?? '',
      audioEn: null,
      audioHi: null,
      details: null,
    );
  }

  PestDiseaseObj copyWith({String? audioEn, String? audioHi, List<PestDiseaseDetail>? details}) {
    return PestDiseaseObj(
      id: id,
      problemType: problemType,
      carousel: carousel,
      nameEn: nameEn,
      nameHi: nameHi,
      nameSciEn: nameSciEn,
      nameSciHi: nameSciHi,
      audioEn: audioEn ?? this.audioEn,
      audioHi: audioHi ?? this.audioHi,
      details: details ?? this.details,
    );
  }
}

class PestDiseaseDetail {
  final String id;
  final String contentEn;
  final String contentHi;
  final String titleEn;
  final String titleHi;
  final List<SolutionRef> solutions;

  PestDiseaseDetail({
    required this.id,
    required this.contentEn,
    required this.contentHi,
    required this.titleEn,
    required this.titleHi,
    required this.solutions,
  });

  factory PestDiseaseDetail.fromJson(Map<String, dynamic> json) {
    return PestDiseaseDetail(
      id: json['_id'] ?? '',
      contentEn: json['contentEn'] ?? '',
      contentHi: json['contentHi'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleHi: json['titleHi'] ?? '',
      solutions:
          (json['solutions'] as List<dynamic>?)?.map((e) => SolutionRef.fromJson(e)).toList() ?? [],
    );
  }
}

class SolutionRef {
  final String id;
  final String nameEn;
  final String nameHi;

  SolutionRef({
    required this.id,
    required this.nameEn,
    required this.nameHi,
  });

  factory SolutionRef.fromJson(Map<String, dynamic> json) {
    return SolutionRef(
      id: json['_id'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameHi: json['nameHi'] ?? '',
    );
  }
}

class PestDiseaseCarousel {
  final String id;
  final String image;
  final String nameEn;
  final String nameHi;

  PestDiseaseCarousel({
    required this.id,
    required this.image,
    required this.nameEn,
    required this.nameHi,
  });

  factory PestDiseaseCarousel.fromJson(Map<String, dynamic> json) {
    return PestDiseaseCarousel(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameHi: json['nameHi'] ?? '',
    );
  }
}

//To temporary parse data
class PestDiseaseDetailResponse {
  final String id;
  final String audioEn;
  final String audioHi;
  final List<PestDiseaseDetail> details;

  PestDiseaseDetailResponse({
    required this.id,
    required this.audioEn,
    required this.audioHi,
    required this.details,
  });

  factory PestDiseaseDetailResponse.fromJson(Map<String, dynamic> json) {
    return PestDiseaseDetailResponse(
      id: json['_id'] ?? '',
      audioEn: json['audioEn'] ?? '',
      audioHi: json['audioHi'] ?? '',
      details: (json['sections'] as List<dynamic>?)
              ?.map((e) => PestDiseaseDetail.fromJson(e))
              .toList() ??
          [],
    );
  }
}
