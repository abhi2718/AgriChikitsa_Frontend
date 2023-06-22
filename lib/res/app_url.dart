class AppUrl {
  static const String baseUrl = "http://192.168.145.167:1010/api/v1";
  // "https://agrichikitsa-backend-abhiwebdev2718-gmailcom.vercel.app/api/v1";
  // "https://agrichikitsa-backend-abhiwebdev2718-gmailcom.vercel.app/api/v1":
  static const String loginEndPoint = '$baseUrl/auth/checkuser';
  static const String registerEndPoint = '$baseUrl/auth/signup';
  static const String updateProfileEndPoint = '$baseUrl/auth/update';
  static const String uploadImageEndPoint = '$baseUrl/upload';
  static const String feedEndPoint = '$baseUrl/feed';
  static const String jankariEndPoint = '$baseUrl/jankari';
  static const String botQquestionsEndPoint = '$baseUrl/botquestion';
  static const String notificationEndPoint = '$baseUrl/notification';
}
