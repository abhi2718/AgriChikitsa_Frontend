class AppUrl {
  static const String baseUrl = "http://192.168.1.106:1010/api/v1";
  static const String loginEndPoint = '$baseUrl/auth/checkuser';
  static const String registerEndPoint = '$baseUrl/auth/signup';
  static const String updateProfileEndPoint = '$baseUrl/auth/update';
  static const String uploadImageEndPoint = '$baseUrl/upload';
  static const String feedEndPoint = '$baseUrl/feed';
  static const String jankariEndPoint = '$baseUrl/jankari';
  static const String botEndPoint = '$baseUrl/chat';
}
