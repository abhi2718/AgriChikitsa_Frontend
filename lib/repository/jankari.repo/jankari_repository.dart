import 'package:agriChikitsa/res/app_url.dart';

import '../../data/network/network_api_service.dart';

class JankariRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> getJankariCategory() async {
    try {
      const url = '${AppUrl.jankariEndPoint}/category/1';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
