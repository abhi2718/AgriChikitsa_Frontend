import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class MyProfileTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchFeeds() async {
    try {
      const url = '${AppUrl.feedEndPoint}/userFeeds/1';
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

  Future<dynamic> deletePost(String feedId) async {
    try {
      final url = '${AppUrl.feedEndPoint}/$feedId';
      final response = await _apiServices.getDeleteApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
