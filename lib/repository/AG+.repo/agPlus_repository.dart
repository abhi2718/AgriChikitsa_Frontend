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

  Future<dynamic> getCropsList() async {
    try {
      const url = AppUrl.getCropsListEndPoint;
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

  Future<dynamic> getCurrentWeather(String latitude, String longitude) async {
    try {
      final url = '${AppUrl.weatherAPIEndPoint}&q=$latitude,$longitude&aqi=no';
      final response = await _apiServices.getWeatherApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getGraphData(String agriStickId, String selectedDate) async {
    final url =
        '${AppUrl.graphDataEndPoint}/$agriStickId?startDate=$selectedDate';
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
