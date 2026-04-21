class ChemicalSolution {
  final String id;
  final String nameEn;
  final String nameHi;
  final String contentEn;
  final String contentHi;
  final bool showCalculator;
  final List<ChemicalSolutionCarousel> chemicalSolutionCarousel;

  ChemicalSolution({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.contentEn,
    required this.contentHi,
    required this.showCalculator,
    required this.chemicalSolutionCarousel,
  });

  factory ChemicalSolution.fromJson(Map<String, dynamic> json) {
    return ChemicalSolution(
      id: json['_id'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameHi: json['nameHi'] ?? '',
      contentEn: json['contentEn'] ?? '',
      contentHi: json['contentHi'] ?? '',
      showCalculator: json['showCalculator'] ?? false,
      chemicalSolutionCarousel: (json['solutionChemicals'] as List<dynamic>?)
              ?.map((e) => ChemicalSolutionCarousel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ChemicalSolutionCarousel {
  final String id;
  final String brandNameEn;
  final String brandNameHi;
  final String companyNameEn;
  final String companyNameHi;
  final String image;
  int likesCount;
  int dislikesCount;
  bool isLiked;
  bool isDisliked;

  ChemicalSolutionCarousel({
    required this.id,
    required this.brandNameEn,
    required this.brandNameHi,
    required this.companyNameEn,
    required this.companyNameHi,
    required this.image,
    required this.likesCount,
    required this.dislikesCount,
    required this.isLiked,
    required this.isDisliked,
  });

  factory ChemicalSolutionCarousel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>?;

    return ChemicalSolutionCarousel(
      id: json['_id'] ?? '',
      brandNameEn: json['brandNameEn'] ?? '',
      brandNameHi: json['brandNameHi'] ?? '',
      companyNameEn: json['companyNameEn'] ?? '',
      companyNameHi: json['companyNameHi'] ?? '',
      image: images != null && images.isNotEmpty ? images.first['image'] ?? '' : '',
      likesCount: json['likesCount'] ?? 0,
      dislikesCount: json['dislikesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isDisliked: json['isDisliked'] ?? false,
    );
  }
}
