import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class MandiPricesTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchStates() async {
    try {
      const url = AppUrl.mandiStatesEndPoint;
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchDistricts(String state) async {
    try {
      final url = '${AppUrl.mandiDistrictEndPoint}/$state';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchMarkets(String district) async {
    try {
      final url = '${AppUrl.mandiMarketEndPoint}/$district';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchCommodities(String market) async {
    try {
      final url = '${AppUrl.mandiCommoditiesEndPoint}/$market';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchPrices(
      String state, String district, String market, String commodity) async {
    try {
      final url =
          '${AppUrl.mandiPricesEndPoint}/$state/$district/$market/$commodity';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
