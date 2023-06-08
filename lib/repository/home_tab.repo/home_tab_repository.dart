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

  Future<dynamic> fetchFeedsCatogory() async {
    try {
      const url = '${AppUrl.feedEndPoint}/category';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchComments() async {
    try {
      const url = '${AppUrl.feedEndPoint}/getComments/64799a0879ce2c1993efbc4e';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
