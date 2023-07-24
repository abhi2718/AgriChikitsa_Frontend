class StateData {
  List<Map<String, dynamic>> jsonData;

  StateData(this.jsonData);

  List<String> get stateList {
    return jsonData.map((stateData) => stateData['stateHi'] as String).toList();
  }

  List<String> getDistrict(String stateName) {
    for (final stateData in jsonData) {
      final state = stateData['stateHi'];
      if (state == stateName) {
        final districts = stateData['districtsHi'];
        return List<String>.from(districts);
      }
    }
    return [];
  }
}
