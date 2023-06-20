import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class MyProfileTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchFeeds() async {
    try {
      final url = '${AppUrl.feedEndPoint}/userFeeds/1';
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
