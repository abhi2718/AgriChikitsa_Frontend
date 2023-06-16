import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class ChatTabRepository {
  final _apiServices = NetworkApiService();
  Future<dynamic> fetchBotMessage(String id) async {
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
}
