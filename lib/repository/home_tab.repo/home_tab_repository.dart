import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class HomeTabRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> fetchAssignedTask(String id) async {
    final url = '${AppUrl.assignedTaskEndPoint}worker/$id';
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
   Future<dynamic> changeAssignedTaskStatus(String id, dynamic payload) async {
    final url = '${AppUrl.assignedTaskEndPoint}/$id';
    try {
      final response = await _apiServices.getPatchApiResponse(url, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
