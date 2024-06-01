import '../../data/network/network_api_service.dart';
import '../../res/app_url.dart';

class AuthRepository {
  final _apiServices = NetworkApiService();

  Future<dynamic> login(String phoneNumber) async {
    try {
      final url = '${AppUrl.loginEndPoint}/$phoneNumber';
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> register(dynamic payload) async {
    const url = AppUrl.registerEndPoint;
    try {
      final response = await _apiServices.getPostApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> updateProfile(String id, dynamic payload) async {
    final url = '${AppUrl.updateProfileEndPoint}/$id';
    try {
      final response = await _apiServices.getPatchApiResponse(url, payload);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> deleteUser(String reason) async {
    final url = '${AppUrl.userEndPoint}/?reason=$reason';
    try {
      final response = await _apiServices.getDeleteApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> fetchStates() async {
    const url = AppUrl.registerStatesEndPoint;
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> fetchDistricts(String state) async {
    final url = '${AppUrl.registerDistrictEndPoint}/$state';
    try {
      final response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
