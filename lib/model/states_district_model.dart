class StateModel {
  final String state;
  final String stateHi;

  StateModel({required this.state, required this.stateHi});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      state: json['state'],
      stateHi: json['stateHi'],
    );
  }
}

class DistrictModel {
  final String name;
  final String nameHi;

  DistrictModel({required this.name, required this.nameHi});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      name: json['name'],
      nameHi: json['nameHi'],
    );
  }
}

class BlockModel {
  final String name;
  final String nameHi;

  BlockModel({required this.name, required this.nameHi});

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      name: json['name'],
      nameHi: json['nameHi'],
    );
  }
}
