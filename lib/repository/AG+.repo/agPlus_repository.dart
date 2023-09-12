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

  Future<dynamic> createPlot(dynamic payload) async {
    const url = AppUrl.createPlotEndPoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
