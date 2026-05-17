class ApiConstants {
  static const bool useLocalApi = false; 

  static const String localAndroid = 'http://10.0.2.2:1234/v1';
  static const String localPhysical = 'http://127.0.0.1:1234/v1';
  
  static const String productionApi = 'https://ankurt02-corporate-filter-phi35-mini-merged.hf.space';

<<<<<<< HEAD
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
=======
  static String get baseUrl => useLocalApi ? localPhysical : productionApi;

  // Dynamically switch the endpoint path
  static String get rewriteUrl => useLocalApi 
      ? '$baseUrl/chat/completions' // Local LM Studio
      : '$baseUrl/rewrite';         // Production Hugging Face
}
>>>>>>> eb8fe58 (updated UI and fixed hf-api)
