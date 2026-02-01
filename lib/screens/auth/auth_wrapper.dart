// ============================================================
// FILE: auth_wrapper.dart
// PURPOSE: Checks if user is already logged in when app starts
// If logged in -> go to Dashboard
// If not logged in -> go to Login screen
// ============================================================

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';
import '../dashboard/dashboard_screen.dart';

// AuthWrapper is the first screen that loads
// It decides which screen to show based on login status
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // Auth service to check login status
  final AuthService _authService = AuthService();

  // Show loading spinner while checking
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Check login status when screen loads
    _checkAuthStatus();
  }

  // ----------------------------------------------------------
  // CHECK IF USER IS ALREADY LOGGED IN
  // ----------------------------------------------------------
  Future<void> _checkAuthStatus() async {
    try {
      // Try to load user from saved session
      final user = await _authService.loadUserFromSession();

      if (mounted) {
        if (user != null) {
          // User is logged in - go to dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          // No saved session - show login screen
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      // Error occurred - show login screen
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // LOADING STATE - Show spinner while checking auth
    // ----------------------------------------------------------
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              // Loading spinner
              const CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // NOT LOGGED IN - Show login screen
    // ----------------------------------------------------------
    return const LoginScreen();
  }
}
