import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class AuthRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> login(dynamic payload) async {
    try {
      final response = await _apiServices.getPostApiResponse(
          AppUrl.loginEndPoint, payload);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> verifyUser(String enployeeId) async {
    const userRole = "Worker";
    final url = '${AppUrl.verifyUserEndPoint}$enployeeId/roles/$userRole';
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> register(dynamic payload) async {
    final url = '${AppUrl.registerEndPoint}${payload["companyId"]}';
    try {
      final response = await _apiServices.getPatchApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
