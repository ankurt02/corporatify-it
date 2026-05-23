class ApiConstants {
  static const bool useLocalApi =
      bool.fromEnvironment('USE_LOCAL_API', defaultValue: false);

  static const String localAndroid = 'http://10.0.2.2:1234/v1';
  static const String localPhysical = 'http://127.0.0.1:1234/v1';

  static const String productionApi =
      'https://ankurt02-corporate-filter-phi35-mini-merged.hf.space';

  static String get baseUrl =>
      useLocalApi ? localPhysical : productionApi;

  static String get rewriteUrl => useLocalApi
      ? '$baseUrl/chat/completions'
      : '$baseUrl/rewrite';
}