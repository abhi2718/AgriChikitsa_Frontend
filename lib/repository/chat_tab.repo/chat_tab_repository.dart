import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class ChatTabRepository {
  final _apiServices = NetworkApiService();
  Future<dynamic> fetchBotQuestion(String id) async {
    try {
      final url = '${AppUrl.botQquestionsEndPoint}/$id';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
