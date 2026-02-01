// ============================================================
// FILE: api_endpoints.dart
// PURPOSE: Stores all API URLs in one place
// When you need to change the server URL, change it here only
// ============================================================

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

// This class holds all the API URLs used in the app
// We keep URLs here so we don't have to write them everywhere
class ApiEndpoints {
  // ----------------------------------------------------------
  // BASE URL SETTINGS
  // ----------------------------------------------------------
  // Android Emulator uses 10.0.2.2 to reach your computer's localhost
  // Web browser uses localhost directly
  // For real phone, use your computer's IP like 192.168.1.100

  // URL for Android emulator (10.0.2.2 = your computer)
  static const String _baseUrlAndroid = 'http://10.0.2.2:80/ecommerce_api';

  // URL for web browser testing
  static const String _baseUrlWeb = 'http://localhost:80/ecommerce_api';

  // This getter picks the right URL based on where app is running
  static String get baseUrl {
    // Check if running in web browser
    if (kIsWeb) {
      return _baseUrlWeb;
    }
    // Check if running on Android
    try {
      if (Platform.isAndroid) {
        return _baseUrlAndroid;
      }
    } catch (e) {
      // If platform check fails, use web URL
    }
    return _baseUrlWeb;
  }

  // ----------------------------------------------------------
  // API ENDPOINTS (URLs for each feature)
  // ----------------------------------------------------------

  // URL for user registration
  static String get signup => '$baseUrl/auth/signup.php';

  // URL for user login
  static String get login => '$baseUrl/auth/login.php';

  // URLs for future features
  static String get userProfile => '$baseUrl/user/profile.php';
  static String get updateProfile => '$baseUrl/user/update.php';

  // ----------------------------------------------------------
  // HTTP HEADERS
  // ----------------------------------------------------------
  // Headers tell the server what type of data we're sending

  // Basic headers for all requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json', // We're sending JSON data
    'Accept': 'application/json', // We want JSON response
  };

  // Headers with login token (for protected routes)
  static Map<String, String> authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token', // Send the login token
  };
}
