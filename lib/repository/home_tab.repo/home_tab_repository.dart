import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class HomeTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchFeeds() async {
    try {
      const url = '${AppUrl.feedEndPoint}/*/1/*/approved';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
