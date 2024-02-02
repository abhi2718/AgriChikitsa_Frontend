import 'package:agriChikitsa/res/app_url.dart';

import '../../data/network/network_api_service.dart';

class JankariRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> getJankariCategory() async {
    try {
      const url = '${AppUrl.jankariEndPoint}/category/1';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getJankariSubCategory(String id) async {
    try {
      final url = '${AppUrl.jankariEndPoint}/subCategory/$id/1';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getJankariSubCategoryPost(String id) async {
    try {
      final url = '${AppUrl.jankariEndPoint}/post/$id/1';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> toggleJankariPostLike(String postId, String type) async {
    try {
      final url = '${AppUrl.jankariPostToggleLike}/$postId/$type';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchTrendingCrops() async {
    try {
      const url = '${AppUrl.jankariEndPoint}/getTrendingCrops';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
