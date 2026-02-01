// ============================================================
// FILE: auth_service.dart
// PURPOSE: Handles all authentication (login, signup, logout)
// This service talks to the PHP backend API
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_endpoints.dart';
import '../core/constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';

// AuthService handles user authentication
// It uses Singleton pattern - only one instance exists
class AuthService {
  // ----------------------------------------------------------
  // SINGLETON PATTERN
  // ----------------------------------------------------------
  // This ensures we have only ONE AuthService in the whole app
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // API service for making HTTP requests
  final ApiService _apiService = ApiService();

  // Store current logged-in user in memory
  UserModel? _currentUser;

  // Get the current user (if logged in)
  UserModel? get currentUser => _currentUser;

  // ----------------------------------------------------------
  // CHECK LOGIN STATUS
  // ----------------------------------------------------------
  // Check if user is already logged in (from saved session)
  Future<bool> isLoggedIn() async {
    // Get saved data from device storage
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  // ----------------------------------------------------------
  // SIGN UP (REGISTER NEW USER)
  // ----------------------------------------------------------
  // Send user details to server to create new account
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // Call the signup API endpoint
    final response = await _apiService.post(
      url: ApiEndpoints.signup,
      body: {
        'name': name.trim(), // Remove extra spaces
        'email': email.trim().toLowerCase(), // Make email lowercase
        'password': password,
      },
    );

    // Check if signup was successful
    if (response['success'] == true && response['user'] != null) {
      // Convert JSON response to UserModel
      final user = UserModel.fromJson(response['user']);
      // Save user session locally
      await _saveUserSession(user);
      return user;
    } else {
      // Signup failed - throw error with message from server
      throw ApiException(
        message: response['message'] ?? 'Registration failed',
        statusCode: 400,
      );
    }
  }

  // ----------------------------------------------------------
  // LOGIN (EXISTING USER)
  // ----------------------------------------------------------
  // Send email and password to server to login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Call the login API endpoint
    final response = await _apiService.post(
      url: ApiEndpoints.login,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );

    // Check if login was successful
    if (response['success'] == true && response['user'] != null) {
      // Convert JSON to UserModel and save session
      final user = UserModel.fromJson(response['user']);
      await _saveUserSession(user);
      return user;
    } else {
      // Login failed
      throw ApiException(
        message: response['message'] ?? 'Login failed',
        statusCode: 401,
      );
    }
  }

  // ----------------------------------------------------------
  // LOGOUT
  // ----------------------------------------------------------
  // Clear all saved user data from device
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Delete all saved data
    _currentUser = null; // Clear user from memory
  }

  // ----------------------------------------------------------
  // SAVE USER SESSION (PRIVATE METHOD)
  // ----------------------------------------------------------
  // Save user data to device storage so they stay logged in
  Future<void> _saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // Save each piece of user data with a key
    await prefs.setInt(AppConstants.userIdKey, user.id);
    await prefs.setString(AppConstants.userNameKey, user.name);
    await prefs.setString(AppConstants.userEmailKey, user.email);
    await prefs.setBool(AppConstants.isLoggedInKey, true);
    _currentUser = user;
  }

  // ----------------------------------------------------------
  // LOAD USER FROM SAVED SESSION
  // ----------------------------------------------------------
  // When app opens, load user data if they were logged in before
  Future<UserModel?> loadUserFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;

    // If not logged in, return null
    if (!isLoggedIn) return null;

    // Get saved user data
    final userId = prefs.getInt(AppConstants.userIdKey);
    final userName = prefs.getString(AppConstants.userNameKey);
    final userEmail = prefs.getString(AppConstants.userEmailKey);

    // If all data exists, create UserModel
    if (userId != null && userName != null && userEmail != null) {
      _currentUser = UserModel(id: userId, name: userName, email: userEmail);
      return _currentUser;
    }

    return null;
  }

  // Get just the user's name from storage
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userNameKey);
  }

  // Get just the user's email from storage
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userEmailKey);
  }
}
