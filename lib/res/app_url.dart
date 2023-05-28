class AppUrl {
  static const String baseUrl = "http://192.168.1.3:1010/api/v1";
  static const String loginEndPoint = '$baseUrl/auth/checkuser';
  static const String verifyUserEndPoint = '$baseUrl/auth/me/';
  static const String registerEndPoint = '$baseUrl/auth/signup';
  static const String assignedTaskEndPoint = '$baseUrl/assignedtasks/';
  static const String taskHistoryEndPoint = '$baseUrl/tasks/history';
  static const String uploadImageEndPoint = '$baseUrl/upload';
}
