import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class NotificationTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchNotifications({int page = 1, int limit = 20}) async {
    try {
      final url = '${AppUrl.notificationsEndPoint}?page=$page&limit=$limit';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchChatScript(String id) async {
    try {
      final url = "${AppUrl.chatHistoryEndPoint}/$id";
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> toggleNotifications(String id, dynamic payload) async {
    try {
      final url = '${AppUrl.notificationsEndPoint}/$id';
      final response = await _apiServices.getPatchApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
