import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api_endpoints.dart';
import '../core/constants.dart';

/// API Service
/// Handles all HTTP requests to the backend
/// Provides centralized error handling and response parsing

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// POST request handler
  /// Returns parsed JSON response or throws exception
  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers ?? ApiEndpoints.headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } on TimeoutException {
      throw ApiException(
        message: 'Request timed out. Please try again.',
        statusCode: 408,
      );
    } on FormatException {
      throw ApiException(
        message: 'Invalid response format from server.',
        statusCode: 500,
      );
    } catch (e) {
      throw ApiException(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// GET request handler
  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers ?? ApiEndpoints.headers)
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } on TimeoutException {
      throw ApiException(
        message: 'Request timed out. Please try again.',
        statusCode: 408,
      );
    } catch (e) {
      throw ApiException(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Handle HTTP response and parse JSON
  Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> responseBody;

    try {
      responseBody = jsonDecode(response.body);
    } catch (e) {
      throw ApiException(
        message: 'Invalid JSON response from server',
        statusCode: response.statusCode,
      );
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseBody;
      case 400:
        throw ApiException(
          message: responseBody['message'] ?? 'Bad request',
          statusCode: 400,
        );
      case 401:
        throw ApiException(
          message: responseBody['message'] ?? 'Unauthorized',
          statusCode: 401,
        );
      case 404:
        throw ApiException(
          message: responseBody['message'] ?? 'Not found',
          statusCode: 404,
        );
      case 409:
        throw ApiException(
          message:
              responseBody['message'] ?? 'Conflict - Resource already exists',
          statusCode: 409,
        );
      case 422:
        throw ApiException(
          message: responseBody['message'] ?? 'Validation failed',
          statusCode: 422,
        );
      case 500:
      default:
        throw ApiException(
          message:
              responseBody['message'] ??
              'Server error. Please try again later.',
          statusCode: response.statusCode,
        );
    }
  }
}

/// Custom API Exception class
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}
