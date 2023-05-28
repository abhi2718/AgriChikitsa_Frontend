class AppUrl {
  static const String baseUrl = "https://job-check-list-backedn.vercel.app/api/v1";
  static const String loginEndPoint = '$baseUrl/auth/login';
  static const String verifyUserEndPoint = '$baseUrl/auth/me/';
  static const String registerEndPoint = '$baseUrl/auth/update/';
  static const String assignedTaskEndPoint = '$baseUrl/assignedtasks/';
  static const String taskHistoryEndPoint = '$baseUrl/tasks/history';
  static const String uploadImageEndPoint = '$baseUrl/upload';
}
