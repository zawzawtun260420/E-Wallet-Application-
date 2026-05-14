class AppConfig {
  static const String appName = 'GPC Digital App';
  static const String baseUrl = 'http://20.188.112.117:3030';
  static const String apiPrefix = '/api';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const bool isProduction = false;

  static String get apiUrl => '$baseUrl$apiPrefix';
}
