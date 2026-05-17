class ApiConstants {
  // true  = Local Flask Backend
  // false = Production Vercel Proxy
  static const bool useLocalApi = false;

  // Used strictly for Android Emulators
  static const String localAndroid = 'http://10.0.2.2:5000';

  // Used for Flutter Web / iOS / Physical Devices
  static const String localPhysical = 'http://127.0.0.1:5000';

  // Production - Vercel-hf API
  static const String productionApi =
      'https://ankurt02-corporate-filter-phi35-mini-merged.hf.space';

  // Updated getter to ensure Web points to 127.0.0.1
  static String get baseUrl => useLocalApi ? localPhysical : productionApi;

  static String get rewriteUrl => '$baseUrl/rewrite';
  static String get healthUrl => '$baseUrl/health';
}
