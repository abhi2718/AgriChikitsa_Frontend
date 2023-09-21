class AppUrl {
  // static const String baseUrl = "https://agrichikitsa.org/api/v1";
  // static const String baseUrl = "https://staging.agrichikitsa.org/api/v1";
  static const String baseUrl = "http://192.168.1.106:9090/api/v1";
  static const String statsEndpoint = '$baseUrl/stats';
  static const String shareLinkEndpoint = 'https://agrichikitsa.org/post';
  static const String loginEndPoint = '$baseUrl/auth/checkuser';
  static const String registerEndPoint = '$baseUrl/auth/signup';
  static const String userEndPoint = '$baseUrl/users';
  static const String updateProfileEndPoint = '$baseUrl/auth/update';
  static const String uploadImageEndPoint = '$baseUrl/upload';
  static const String feedEndPoint = '$baseUrl/feed';
  static const String jankariEndPoint = '$baseUrl/jankari';
  static const String mandiStatesEndPoint = '$baseUrl/mandi/states';
  static const String registerStatesEndPoint = '$baseUrl/auth/states';
  static const String registerDistrictEndPoint = '$baseUrl/auth/districts';
  static const String mandiDistrictEndPoint = '$baseUrl/mandi/districts';
  static const String mandiMarketEndPoint = '$baseUrl/mandi/markets';
  static const String mandiCommoditiesEndPoint = '$baseUrl/mandi/commodities';
  static const String mandiPricesEndPoint = '$baseUrl/mandi';
  static const String botQquestionsEndPoint = '$baseUrl/chat/script';
  static const String notificationsEndPoint = '$baseUrl/notification';
  static const String chatEndPoint = '$baseUrl/chat';
  static const String jankariPostToggleLike = '$baseUrl/jankari/likes/post';
  static const String getFieldsEndPoint = '$baseUrl/agristick/feilds';
  static const String createPlotEndPoint = '$baseUrl/agristick/addFeild';
  static const String activateAgriStickEndPoint =
      '$baseUrl/agristick/activateAgristick';
  static const String weatherAPIEndPoint =
      'http://api.weatherapi.com/v1/current.json?key=94488ccb442e4337ad735838231309';
}
