abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getPostApiResponse(String url, dynamic payload);
  Future<dynamic> getPatchApiResponse(String url, dynamic payload);
  Future<dynamic> getPutApiResponse(String url);
  Future<dynamic> getDeleteApiResponse(String url);
}
