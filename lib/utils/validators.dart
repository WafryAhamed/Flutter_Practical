import '../core/constants.dart';

/// Input Validators
/// Provides validation functions for form fields
/// Returns error message string if invalid, null if valid

class Validators {
  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedValue = value.trim();

    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password
  /// Requirements: minimum 6 characters
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }

    return null;
  }

  /// Validate password with strength requirements
  /// Requirements: uppercase, lowercase, number
  static String? strongPassword(String? value) {
    final basicValidation = password(value);
    if (basicValidation != null) return basicValidation;

    if (!RegExp(r'[A-Z]').hasMatch(value!)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validate confirm password matches original
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

  /// Validate name field
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

    // Only allow letters, spaces, hyphens, and apostrophes
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
