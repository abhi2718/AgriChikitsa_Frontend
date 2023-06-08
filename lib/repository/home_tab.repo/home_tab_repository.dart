import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class HomeTabRepository {
  final _apiServices = NetworkApiService(); 

  Future<dynamic> fetchCategory(String phoneNumber) async {
    try {
      final url = '${AppUrl.loginEndPoint}/$phoneNumber';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
