import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class CheckPricesRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchPrices(String filter) async {
    try {
      final url = "${AppUrl.checkPriceBaseUrl}$filter";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchTimeLine() async {
    try {
      const url = '${AppUrl.feedEndPoint}/timeLine';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
