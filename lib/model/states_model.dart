class StateData {
  List<Map<String, dynamic>> jsonData;

  StateData(this.jsonData);

  List<String> get stateList {
    return jsonData.map((stateData) => stateData['state'] as String).toList();
  }

  List<String> getDistrict(String stateName) {
    for (final stateData in jsonData) {
      final state = stateData['state'];
      if (state == stateName) {
        final districts = stateData['districts'];
        return List<String>.from(districts);
      }
    }
    return [];
  }
}
