// ============================================================
// FILE: user_model.dart
// PURPOSE: Defines what a "User" looks like in our app
// This is like a blueprint/template for user data
// ============================================================

// "library" is a Dart keyword - ignore it for now
library;

// UserModel class represents a user in our app
// It holds user information like id, name, email
class UserModel {
  // ----------------------------------------------------------
  // USER PROPERTIES (the data each user has)
  // ----------------------------------------------------------
  final int id; // Unique ID from database
  final String name; // User's full name
  final String email; // User's email address
  final DateTime? createdAt; // When account was created (optional)

  // Constructor - creates a new UserModel object
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });

  // ----------------------------------------------------------
  // CONVERT JSON TO USER OBJECT
  // ----------------------------------------------------------
  // When we get data from API, it comes as JSON (Map)
  // This factory converts that JSON into a UserModel object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Handle id whether it's string or int from server
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '', // Use empty string if null
      email: json['email'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  // ----------------------------------------------------------
  // CONVERT USER OBJECT TO JSON
  // ----------------------------------------------------------
  // When we send data to API, we convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Create a copy of this user with some fields changed
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // How to print this object (useful for debugging)
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email)';
  }

  // Compare two users - they're equal if same id and email
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
