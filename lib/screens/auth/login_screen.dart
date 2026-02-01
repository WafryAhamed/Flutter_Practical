// ============================================================
// FILE: login_screen.dart
// PURPOSE: User login screen
// User enters email and password to sign in
// On success, navigates to Dashboard
// ============================================================

import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../services/auth_service.dart';
import '../../services/mock_auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/validators.dart';
import 'signup_screen.dart';
import '../dashboard/dashboard_screen.dart';

// LoginScreen is a StatefulWidget because it has changing state
// (loading state, form input, etc.)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ----------------------------------------------------------
  // FORM AND CONTROLLERS
  // ----------------------------------------------------------

  // Form key to validate all form fields at once
  final _formKey = GlobalKey<FormState>();

  // Controllers to get text from input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Focus nodes to control keyboard focus
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // ----------------------------------------------------------
  // STATE VARIABLES
  // ----------------------------------------------------------

  // Shows loading spinner on button when true
  bool _isLoading = false;

  // ----------------------------------------------------------
  // SERVICES
  // ----------------------------------------------------------

  // Real service connects to PHP backend
  final _authService = AuthService();
  // Mock service for testing without backend
  final _mockAuthService = MockAuthService();

  // Clean up controllers when screen is closed
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // LOGIN HANDLER
  // ----------------------------------------------------------
  // Called when user taps "Sign In" button
  Future<void> _handleLogin() async {
    // Step 1: Validate form (check email format, password length)
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

    // Step 2: Show loading spinner
    setState(() => _isLoading = true);

    try {
      // Step 3: Call login API (mock or real based on config)
      final user = AppConstants.useMockData
          ? await _mockAuthService.login(
              email: _emailController.text,
              password: _passwordController.text,
            )
          : await _authService.login(
              email: _emailController.text,
              password: _passwordController.text,
            );

      // Step 4: Login successful - navigate to dashboard
      if (mounted) {
        _showSnackBar('Welcome back, ${user.name}!', isError: false);

        // Replace current screen with dashboard (can't go back)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      // Step 5: Login failed - show error message
      if (mounted) {
        _showSnackBar(e.toString(), isError: true);
      }
    } finally {
      // Step 6: Hide loading spinner
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Navigate to signup screen
  void _navigateToSignup() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  // Show a popup message at bottom of screen
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorColor : AppTheme.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(AppConstants.defaultPadding),
      ),
    );
  }

  // ----------------------------------------------------------
  // BUILD UI
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
            // Form widget validates all child TextFields
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Welcome header with logo
                  _buildHeader(),

                  const SizedBox(height: 48),

                  // Email input field
                  EmailTextField(
                    controller: _emailController,
                    validator: Validators.email,
                    focusNode: _emailFocusNode,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 24),

                  // Password input field
                  PasswordTextField(
                    controller: _passwordController,
                    validator: Validators.password,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                  ),

                  const SizedBox(height: 16),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _showSnackBar('Password recovery coming soon!');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTheme.linkText.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sign In button
                  CustomButton(
                    text: 'Sign In',
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 24),

                  // "or" divider
                  _buildDivider(),

                  const SizedBox(height: 24),

                  // Link to sign up page
                  _buildSignUpLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Header with logo and welcome text
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App logo icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 32,
          ),
        ),

        const SizedBox(height: 32),

        // Welcome title
        const Text('Ayubowan!', style: AppTheme.headingLarge),

        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Sign in to explore the best deals in Sri Lanka',
          style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  // Divider with "or" text in middle
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textHint),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  // Link to sign up page
  Widget _buildSignUpLink() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("Don't have an account?", style: AppTheme.bodyMedium),
        TextButton(
          onPressed: _navigateToSignup,
          child: const Text('Sign Up', style: AppTheme.linkText),
        ),
      ],
    );
  }
}
