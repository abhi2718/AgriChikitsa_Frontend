import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class ChatTabRepository {
  final _apiServices = NetworkApiService();
  Future<dynamic> fetchBotMessage() async {
    try {
      const url = '${AppUrl.botEndPoint}/script';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addQuestion(dynamic payload) async {
    try {
      const url = '${AppUrl.botEndPoint}/chat';
      final response = await _apiServices.getPostApiResponse(url, payload);
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
