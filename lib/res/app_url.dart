class AppUrl {
  static const String baseUrl = "https://agrichikitsa.org/api/v1";
  static const String apiKey =
      "579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b";
  static const String checkPriceBaseUrl =
      "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$apiKey&format=json";
  static const String loginEndPoint = '$baseUrl/auth/checkuser';
  static const String registerEndPoint = '$baseUrl/auth/signup';
  static const String userEndPoint = '$baseUrl/users';
  static const String updateProfileEndPoint = '$baseUrl/auth/update';
  static const String uploadImageEndPoint = '$baseUrl/upload';
  static const String feedEndPoint = '$baseUrl/feed';
  static const String jankariEndPoint = '$baseUrl/jankari';
  static const String botQquestionsEndPoint = '$baseUrl/chat/script';
  static const String notificationsEndPoint = '$baseUrl/notification';
  static const String chatEndPoint = '$baseUrl/chat';
}
