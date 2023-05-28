abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getPostApiResponse(String url,dynamic payload);
  Future<dynamic> getPatchApiResponse(String url,dynamic payload);
  Future<dynamic> getDeleteApiResponse(String url);
}
