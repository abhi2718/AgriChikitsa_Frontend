class StateData {
  List<Map<String, dynamic>> jsonData;

  StateData(this.jsonData);

  List<String> get stateList {
    return jsonData.map((stateData) => stateData['stateHi'] as String).toList();
  }

  dynamic getDistrict(String stateName) {
    for (final stateData in jsonData) {
      final state = stateData['stateHi'];
      if (state == stateName) {
        final districts = stateData['districts'] as dynamic;
        return districts;
      }
    }
    return [];
  }
}
