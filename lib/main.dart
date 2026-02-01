// ============================================================
// FILE: main.dart
// PURPOSE: This is the starting point of the Flutter app
// The app begins running from here when you click "Run"
// ============================================================

import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/auth/auth_wrapper.dart';

// This is where the app starts running
// Think of it like the "main()" function in C or Java
void main() {
  // Make sure Flutter is ready before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Start the app by calling ECommerceApp widget
  runApp(const ECommerceApp());
}

// This is the root widget of the entire app
// It sets up the theme and the first screen to show
class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App title shown in task switcher
      title: 'E-Commerce App',

      // Hide the "DEBUG" banner in top right corner
      debugShowCheckedModeBanner: false,

      // Apply our custom colors and styles
      theme: AppTheme.lightTheme,

      // First screen: AuthWrapper checks if user is logged in
      // If logged in -> Dashboard, otherwise -> Login screen
      home: const AuthWrapper(),
    );
  }
}
