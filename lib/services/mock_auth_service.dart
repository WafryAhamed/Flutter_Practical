import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';

/// Mock Authentication Service
/// Provides fake authentication for testing without a backend
/// Set AppConstants.useMockData = true to enable

class MockAuthService {
  // Singleton pattern
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  UserModel? _currentUser;

  // Mock database of users
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 1,
      'name': 'Kasun Perera',
      'email': 'kasun@example.com',
      'password': 'password123',
      'created_at': '2026-01-15T10:30:00Z',
    },
    {
      'id': 2,
      'name': 'Fathima Rizwan',
      'email': 'fathima@example.com',
      'password': 'password123',
      'created_at': '2026-01-20T14:45:00Z',
    },
    {
      'id': 3,
      'name': 'Anthony Silva',
      'email': 'anthony@example.com',
      'password': 'demo123',
      'created_at': '2026-01-25T09:00:00Z',
    },
  ];

  // Auto-increment ID for new users
  static int _nextId = 4;

  /// Get current logged-in user
  UserModel? get currentUser => _currentUser;

  /// Check if user is currently logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  /// Mock signup - simulates network delay and user creation
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final normalizedEmail = email.trim().toLowerCase();

    // Check if email already exists
    final existingUser = _mockUsers.firstWhere(
      (user) => user['email'] == normalizedEmail,
      orElse: () => {},
    );

    if (existingUser.isNotEmpty) {
      throw ApiException(
        message: 'Email already registered. Please use a different email.',
        statusCode: 409,
      );
    }

    // Create new user
    final newUser = {
      'id': _nextId++,
      'name': name.trim(),
      'email': normalizedEmail,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
    };

    _mockUsers.add(newUser);

    final user = UserModel.fromJson(newUser);
    await _saveUserSession(user);

    return user;
  }

  /// Mock login - validates against mock database
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final normalizedEmail = email.trim().toLowerCase();

    // Find user by email
    final userData = _mockUsers.firstWhere(
      (user) => user['email'] == normalizedEmail,
      orElse: () => {},
    );

    if (userData.isEmpty) {
      throw ApiException(
        message: 'No account found with this email.',
        statusCode: 404,
      );
    }

    // Validate password
    if (userData['password'] != password) {
      throw ApiException(
        message: 'Incorrect password. Please try again.',
        statusCode: 401,
      );
    }

    final user = UserModel.fromJson(userData);
    await _saveUserSession(user);

    return user;
  }

  /// Logout current user and clear session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
  }

  /// Save user session to SharedPreferences
  Future<void> _saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.userIdKey, user.id);
    await prefs.setString(AppConstants.userNameKey, user.name);
    await prefs.setString(AppConstants.userEmailKey, user.email);
    await prefs.setBool(AppConstants.isLoggedInKey, true);
    _currentUser = user;
  }

  /// Load user from saved session
  Future<UserModel?> loadUserFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;

    if (!isLoggedIn) return null;

    final userId = prefs.getInt(AppConstants.userIdKey);
    final userName = prefs.getString(AppConstants.userNameKey);
    final userEmail = prefs.getString(AppConstants.userEmailKey);

    if (userId != null && userName != null && userEmail != null) {
      _currentUser = UserModel(id: userId, name: userName, email: userEmail);
      return _currentUser;
    }

    return null;
  }

  /// Get stored user name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userNameKey);
  }

  /// Get stored user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userEmailKey);
  }

  /// Get all mock users (for testing/debugging)
  List<Map<String, dynamic>> getMockUsers() {
    return List.from(_mockUsers.map((u) => {...u, 'password': '***'}));
  }
}
