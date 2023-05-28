import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class HistoryTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchTaskHistory() async {
    const url = '${AppUrl.taskHistoryEndPoint}/';
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
