import 'package:agriChikitsa/model/crop_model.dart';

class WeedProtection {
  final List<WeedAdvisory> organic;
  final List<WeedAdvisory> chemical;

  WeedProtection({
    required this.organic,
    required this.chemical,
  });

  factory WeedProtection.fromJson(Map<String, dynamic> json) {
    return WeedProtection(
      organic: (json['organic'] as List<dynamic>?)
              ?.map((item) => WeedAdvisory.fromJson(item))
              .toList() ??
          [],
      chemical: (json['chemical'] as List<dynamic>?)
              ?.map((item) => WeedAdvisory.fromJson(item))
              .toList() ??
          [],
    );
  }

  List<WeedAdvisory> getByType(String type) {
    switch (type.toLowerCase()) {
      case "organic":
        return organic;
      case "chemical":
        return chemical;
      default:
        return [];
    }
  }
}

class WeedAdvisory {
  final String id;
  final CropRef cropRef;
  final String cropState;
  final String advisoryType;
  final List<AdvisoryImage> imagesBefore;
  final List<AdvisoryImage> imagesAfter;
  final String advisoryBeforeEn;
  final String advisoryBeforeHi;
  final String advisoryAfterEn;
  final String advisoryAfterHi;
  final String audioBeforeEn;
  final String audioBeforeHi;
  final String audioAfterEn;
  final String audioAfterHi;

  WeedAdvisory({
    required this.id,
    required this.cropRef,
    required this.cropState,
    required this.advisoryType,
    required this.imagesBefore,
    required this.imagesAfter,
    required this.advisoryBeforeEn,
    required this.advisoryBeforeHi,
    required this.advisoryAfterEn,
    required this.advisoryAfterHi,
    required this.audioBeforeEn,
    required this.audioBeforeHi,
    required this.audioAfterEn,
    required this.audioAfterHi,
  });

  factory WeedAdvisory.fromJson(Map<String, dynamic> json) {
    return WeedAdvisory(
      id: json['_id'] as String,
      cropRef: CropRef.fromJson(json['crop_ref'] ?? {}),
      cropState: json['crop_state'] as String,
      advisoryType: json['advisory_type'] as String,
      imagesBefore: (json['images_before'] as List<dynamic>?)
              ?.map((item) => AdvisoryImage.fromJson(item))
              .toList() ??
          [],
      imagesAfter: (json['images_after'] as List<dynamic>?)
              ?.map((item) => AdvisoryImage.fromJson(item))
              .toList() ??
          [],
      advisoryBeforeEn: json['advisory_before_en'] ?? '',
      advisoryBeforeHi: json['advisory_before_hi'] ?? '',
      advisoryAfterEn: json['advisory_after_en'] ?? '',
      advisoryAfterHi: json['advisory_after_hi'] ?? '',
      audioBeforeEn: json['audio_before_en'] ?? '',
      audioBeforeHi: json['audio_before_hi'] ?? '',
      audioAfterEn: json['audio_after_en'] ?? '',
      audioAfterHi: json['audio_after_hi'] ?? '',
    );
  }
}

class AdvisoryImage {
  final String id;
  final String nameEn;
  final String nameHi;
  final String imageUrl;

  AdvisoryImage({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.imageUrl,
  });

  factory AdvisoryImage.fromJson(Map<String, dynamic> json) {
    return AdvisoryImage(
      id: json['_id'] ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameHi: json['name_hi']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
    );
  }
}
