import 'dart:developer';

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

  Future<dynamic> getJankariSubCategoryTagsPost(String id) async {
    try {
      final url = '${AppUrl.jankariEndPoint}/postsByTags/$id';
      log(url);
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

  Future<dynamic> fetchTrendingPosts() async {
    try {
      const url = '${AppUrl.jankariEndPoint}/trendingPosts';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchComments(String id) async {
    try {
      final url = '${AppUrl.jankariEndPoint}/commentOnPost/$id';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addComments(String id, dynamic payload) async {
    try {
      const url = '${AppUrl.jankariEndPoint}/commentOnPost';
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
