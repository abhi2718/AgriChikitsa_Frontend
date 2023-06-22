import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class HomeTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchFeeds(String id) async {
    try {
      final url = id == "All"
          ? '${AppUrl.feedEndPoint}/*/1/*/approved'
          : '${AppUrl.feedEndPoint}/$id/1/*/approved';
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

  Future<dynamic> toggleLike(String id) async {
    try {
      final url = '${AppUrl.feedEndPoint}/togglelike/$id';
      final response = await _apiServices.getPatchApiResponse(url, {});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> toggleTimeline(String id) async {
    try {
      final url = '${AppUrl.feedEndPoint}/toggleInTimeLine/$id';
      final response = await _apiServices.getPatchApiResponse(url, {});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchComments(String id) async {
    try {
      final url = '${AppUrl.feedEndPoint}/getComments/$id';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createPost(dynamic payload) async {
    try {
      const url = '${AppUrl.feedEndPoint}/';
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addComments(String id, dynamic payload) async {
    try {
      final url = '${AppUrl.feedEndPoint}/comment/$id';
      final response = await _apiServices.getPatchApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
