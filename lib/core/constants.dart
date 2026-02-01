/// Application-wide constants
/// Contains static configuration values used throughout the app
library;

class AppConstants {
  // App Info
  static const String appName = 'Sri Lanka Mart';
  static const String appVersion = '1.0.0';

  // ============================================
  // MOCK MODE TOGGLE
  // Set to true for testing without a backend
  // Set to false when connecting to real API
  // ============================================
  static const bool useMockData = false;

  // Storage Keys for SharedPreferences
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String isLoggedInKey = 'is_logged_in';
  static const String authTokenKey = 'auth_token';

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;

  // API Timeout
  static const int apiTimeoutSeconds = 30;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
}
