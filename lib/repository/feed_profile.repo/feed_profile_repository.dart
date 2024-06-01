import 'package:agriChikitsa/data/network/network_api_service.dart';
import 'package:agriChikitsa/res/app_url.dart';

class FeedProfileRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchPosts(String userId) async {
    try {
      final url = "${AppUrl.profileDetailsEndPoint}/$userId";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> followUser(dynamic payload) async {
    try {
      const url = "${AppUrl.connectionsEndPoint}/follow";
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
