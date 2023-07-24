class AppUrl {
  static const String baseUrl = "https://agrichikitsa.org/api/v1";
  static const String baseUrl1 = "http://192.168.1.105:9090/api/v1";
  static const String statsEndpoint = '$baseUrl1/stats';
  static const String loginEndPoint = '$baseUrl/auth/checkuser';
  static const String registerEndPoint = '$baseUrl1/auth/signup';
  static const String userEndPoint = '$baseUrl/users';
  static const String updateProfileEndPoint = '$baseUrl/auth/update';
  static const String uploadImageEndPoint = '$baseUrl/upload';
  static const String feedEndPoint = '$baseUrl/feed';
  static const String jankariEndPoint = '$baseUrl/jankari';
  static const String botQquestionsEndPoint = '$baseUrl/chat/script';
  static const String notificationsEndPoint = '$baseUrl/notification';
  static const String chatEndPoint = '$baseUrl/chat';
}
