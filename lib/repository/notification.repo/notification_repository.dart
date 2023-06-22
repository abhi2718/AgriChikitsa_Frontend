import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class NotificationTabRepo {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchNotification() async {
    try {
      const url = '${AppUrl.feedEndPoint}/notification';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
