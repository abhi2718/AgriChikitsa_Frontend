import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class StatsTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> updateStats(String type, String id) async {
    try {
      final url = '${AppUrl.statsEndpoint}/$type/$id';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateTapCount(String cropId) async {
    try {
      final url = '${AppUrl.jankariEndPoint}/trackCropTapCount/$cropId';
      final response = await _apiServices.getPutApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
