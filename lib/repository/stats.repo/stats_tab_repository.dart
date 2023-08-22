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
}
