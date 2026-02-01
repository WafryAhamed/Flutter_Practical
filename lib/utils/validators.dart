// ============================================================
// FILE: validators.dart
// PURPOSE: Form validation functions
// Each function returns null if valid, or error message if invalid
// Used by TextFormField widgets to validate user input
// ============================================================

import '../core/constants.dart';

// Validators class contains static validation methods
// Static means you call them directly: Validators.email(value)
class Validators {
  // ----------------------------------------------------------
  // EMAIL VALIDATOR
  // ----------------------------------------------------------
  // Checks if email is empty and if it matches email format
  static String? email(String? value) {
    // Check if empty
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedValue = value.trim();

    // Regex pattern for email validation
    // Matches: user@domain.com, user.name@domain.co.lk, etc.
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    return null; // null means valid
  }

  // ----------------------------------------------------------
  // PASSWORD VALIDATOR
  // ----------------------------------------------------------
  // Checks password length (min 6, max 128 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Check minimum length
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    // Check maximum length
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }

    return null; // null means valid
  }

  // ----------------------------------------------------------
  // STRONG PASSWORD VALIDATOR
  // ----------------------------------------------------------
  // Requires uppercase, lowercase, and number
  static String? strongPassword(String? value) {
    // First do basic validation
    final basicValidation = password(value);
    if (basicValidation != null) return basicValidation;

    // Check for uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value!)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // ----------------------------------------------------------
  // CONFIRM PASSWORD VALIDATOR
  // ----------------------------------------------------------
  // Returns a function that checks if passwords match
  // This is a "factory" pattern - creates a validator with the original password
  static String? Function(String?) confirmPassword(String originalPassword) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }

      if (value != originalPassword) {
        return 'Passwords do not match';
      }

      return null;
    };
  }

  // ----------------------------------------------------------
  // NAME VALIDATOR
  // ----------------------------------------------------------
  // Checks length and allowed characters
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < AppConstants.minNameLength) {
      return 'Name must be at least ${AppConstants.minNameLength} characters';
    }

    if (trimmedValue.length > AppConstants.maxNameLength) {
      return 'Name must be less than ${AppConstants.maxNameLength} characters';
    }

    // Regex: Only letters, spaces, hyphens, apostrophes
    // Examples: "Kasun Perera", "O'Brien", "Anne-Marie"
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(trimmedValue)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  /// Generic required field validator
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate phone number (basic)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Optional phone validator (only validates if not empty)
  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return phone(value);
  }
}
