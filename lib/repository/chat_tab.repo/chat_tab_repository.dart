import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class ChatTabRepository {
  final _apiServices = NetworkApiService();
  Future<dynamic> fetchBotQuestion(String id, [String? cropCategoryId]) async {
    try {
      String url;
      if (cropCategoryId != null) {
        url = '${AppUrl.botQquestionsEndPoint}/$id?categoryId=$cropCategoryId';
      } else {
        url = '${AppUrl.botQquestionsEndPoint}/$id';
      }
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postChatQuestion(dynamic payload) async {
    try {
      const url = AppUrl.chatHistoryEndPoint;
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> markChatAsOpened(dynamic payload, String chatId) async {
    try {
      final url = "${AppUrl.chatHistoryEndPoint}/$chatId";
      final response = await _apiServices.getPutFeedApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteChatHistory(String chatId) async {
    try {
      final url = '${AppUrl.chatEndPoint}/$chatId';
      final response = await _apiServices.getDeleteApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getChatHistory() async {
    try {
      const url = AppUrl.chatHistoryEndPoint;
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postchatRating(String id, dynamic payload) async {
    try {
      final url = "${AppUrl.chatHistoryEndPoint}/$id/feedback";
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
