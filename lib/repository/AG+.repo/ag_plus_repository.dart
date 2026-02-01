import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class AGPlusRepository {
  final _apiServices = NetworkApiService();
  Future<dynamic> getFields() async {
    try {
      const url = AppUrl.getFieldsEndPoint;
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCropDuration(String cropId) async {
    try {
      final url = "${AppUrl.getCropsListEndPoint}/$cropId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> checkCropAvailablity(String cropId, dynamic payload) async {
    try {
      final url = "${AppUrl.checkCropEndPoint}/$cropId";
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchCropsCategoryList() async {
    try {
      const url = AppUrl.getCropsCategoryListEndPoint;
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCropsList(String selectedCropCategory) async {
    try {
      final url = selectedCropCategory == "All"
          ? AppUrl.getCropsListEndPoint
          : "${AppUrl.getCropsListEndPoint}/?category=$selectedCropCategory";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createPlot(dynamic payload) async {
    const url = AppUrl.createPlotEndPoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> deleteField(String fieldId) async {
    final url = '${AppUrl.deleteFieldEndPoint}/$fieldId';
    try {
      final response = await _apiServices.getPutApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> activateAgristick(String id, String fieldId) async {
    final url = '${AppUrl.activateAgriStickEndPoint}/$id/$fieldId';
    try {
      final response = await _apiServices.getPutApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getCurrentDistrictWeather(String district, String lang) async {
    try {
      final url = lang == "en"
          ? '${AppUrl.weatherAPIEndPoint}&q=$district&aqi=no'
          : '${AppUrl.weatherAPIEndPoint}&q=$district&aqi=no&lang=hi';
      final response = await _apiServices.getWeatherApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCurrentWeather(String latitude, String longitude, String lang) async {
    try {
      final url = lang == "en"
          ? '${AppUrl.weatherAPIEndPoint}&q=$latitude,$longitude&aqi=no'
          : '${AppUrl.weatherAPIEndPoint}&q=$latitude,$longitude&aqi=no&lang=hi';
      final response = await _apiServices.getWeatherApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPredictedWeather(String latitude, String longitude, String lang) async {
    try {
      final url = '${AppUrl.forecastAPIEndPoint}&q=$latitude,$longitude&aqi=no&days=3&lang=$lang';
      final response = await _apiServices.getWeatherApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPredictedDistrictWeather(String district, String lang) async {
    try {
      final url = '${AppUrl.weatherAPIEndPoint}&q=$district&aqi=no&days=3&lang=$lang';
      final response = await _apiServices.getWeatherApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Old Implementation
  // Future<dynamic> getGraphData(String agriStickId, String selectedDate) async {
  //   final url = '${AppUrl.graphDataEndPoint}/$agriStickId?startDate=$selectedDate';
  //   try {
  //     final response = await _apiServices.getGetApiResponse(url);
  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<dynamic> getGraphData(String selectedDate) async {
    const url = "https://api.thingspeak.com/channels/1548738/feeds.json";
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> raiseSoilTestingRequest(dynamic payload) async {
    const url = AppUrl.raiseTestingRequestEndPoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getReportsList(String fieldId, int pageNo) async {
    final url = "${AppUrl.raiseTestingRequestEndPoint}$fieldId?page=$pageNo";
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> raiseInfoRequest(dynamic payload) async {
    const url = AppUrl.infoRequestEndpoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> changeCrop(dynamic payload) async {
    const url = AppUrl.changeCropEndPoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> checkPremium() async {
    const url = "${AppUrl.fieldEndpoint}/is-premium";
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> fetchPlotHistory(String fieldId) async {
    try {
      final url = "${AppUrl.cropHistoryEndpoint}/$fieldId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addFieldForMonitoring(String fieldId) async {
    final url = "${AppUrl.ndviEndpoint}/$fieldId";
    try {
      final response = await _apiServices.getPostApiResponse(url, {});
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getNDVIData(String ndviId, String pageNo) async {
    final url = "${AppUrl.ndviEndpoint}/cropHealth/$ndviId/$pageNo";
    try {
      final response = await _apiServices.getNDVIApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getWeedProtectionData(String cropId) async {
    try {
      final url = "${AppUrl.advisoryEnpoint}/kharpatvar/getByCrop/$cropId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPestAndDiseaseList(String cropId, String stageId, String currentSeason,
      String userState, String selectedType) async {
    try {
      final url =
          "${AppUrl.pestDiseaseEnpoint}/crop-problem?cropId=$cropId&stageId=$stageId&season=$currentSeason&state=$userState&type=$selectedType";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPestAndDiseaseData(String id) async {
    try {
      final url = "${AppUrl.pestDiseaseEnpoint}/crop-problem-detail/$id";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //To get chemical details inside pest/disease selected medicine
  Future<dynamic> getSolutionsData(String solutionId) async {
    try {
      final url = "${AppUrl.pestDiseaseEnpoint}/problem-solution-detail/$solutionId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateField(String fieldId, dynamic payload) async {
    try {
      final url = "${AppUrl.fieldEndpoint}/updateField/$fieldId";
      final response = await _apiServices.getPutFeedApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getWeedManageData(String weedId) async {
    try {
      final url = "${AppUrl.advisoryEnpoint}/kharpatvar/manage/$weedId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getChemicalsData(String methodId) async {
    try {
      final url = "${AppUrl.advisoryEnpoint}/kharpatvar/manage/chemical/$methodId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> toggleMedicineLike(String chemicalId) async {
    try {
      final url = "${AppUrl.advisoryEnpoint}/kharpatvar/manage/chemical/toggleLike/$chemicalId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> toggleMedicineDislike(String chemicalId) async {
    try {
      final url = "${AppUrl.advisoryEnpoint}/kharpatvar/manage/chemical/toggledisLike/$chemicalId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> calculateDosage(String chemicalId, dynamic payload) async {
    try {
      final url = "${AppUrl.advisoryEnpoint}/kharpatvar/manage/calculateDosage/$chemicalId";
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> calculatePestDosage(String pestMedicineId, dynamic payload) async {
    try {
      final url = "${AppUrl.pestDiseaseEnpoint}/calculate-dosage/$pestMedicineId";
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Get Mandi Details for field
  Future<dynamic> getFieldMandiData() async {
    try {
      final url = "${AppUrl.mandiPricesEndPoint}/nearby";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Post yield data from popup when crop harvest stage
  Future<dynamic> postYieldDataFromPopup(String plotId, dynamic payload) async {
    try {
      final url = "${AppUrl.fieldEndpoint}/yield/$plotId";
      final response = await _apiServices.getPatchApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
