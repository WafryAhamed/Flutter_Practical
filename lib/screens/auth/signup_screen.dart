import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../services/auth_service.dart';
import '../../services/mock_auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/validators.dart';
import '../dashboard/dashboard_screen.dart';

/// Sign Up Screen
/// Handles new user registration
/// Modern Uber-style UI with form validation

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus nodes
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  // State
  bool _isLoading = false;
  bool _acceptedTerms = false;

  // Services - use mock or real based on config
  final _authService = AuthService();
  final _mockAuthService = MockAuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  /// Handle signup submission
  Future<void> _handleSignup() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check terms acceptance
    if (!_acceptedTerms) {
      _showSnackBar(
        'Please accept the Terms of Service to continue',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Attempt registration (uses mock service if enabled)
      final user = AppConstants.useMockData
          ? await _mockAuthService.signUp(
              name: _nameController.text,
              email: _emailController.text,
              password: _passwordController.text,
            )
          : await _authService.signUp(
              name: _nameController.text,
              email: _emailController.text,
              password: _passwordController.text,
            );

      if (mounted) {
        // Show success message
        _showSnackBar(
          'Welcome, ${user.name}! Account created successfully.',
          isError: false,
        );

        // Navigate to dashboard
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Navigate back to login
  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  /// Show snackbar message
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: _navigateToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding * 1.5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 40),

                  // Name Field
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'e.g. Kasun Perera',
                    controller: _nameController,
                    validator: Validators.name,
                    focusNode: _nameFocusNode,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20),

                  // Email Field
                  EmailTextField(
                    controller: _emailController,
                    validator: Validators.email,
                    focusNode: _emailFocusNode,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  PasswordTextField(
                    controller: _passwordController,
                    validator: Validators.password,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    hint: 'Minimum 6 characters',
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password Field
                  PasswordTextField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    validator: Validators.confirmPassword(
                      _passwordController.text,
                    ),
                    focusNode: _confirmPasswordFocusNode,
                    textInputAction: TextInputAction.done,
                  ),

                  const SizedBox(height: 24),

                  // Terms & Conditions Checkbox
                  _buildTermsCheckbox(),

                  const SizedBox(height: 32),

                  // Sign Up Button
                  CustomButton(
                    text: 'Create Account',
                    onPressed: _handleSignup,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 24),

                  // Sign In Link
                  _buildSignInLink(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Create Account', style: AppTheme.headingLarge),

        const SizedBox(height: 8),

        Text(
          'Join thousands of Sri Lankan shoppers today',
          style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  /// Build terms checkbox
  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
              });
            },
            activeColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptedTerms = !_acceptedTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                style: AppTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: AppTheme.linkText.copyWith(fontSize: 14),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: AppTheme.linkText.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build sign in link
  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account?', style: AppTheme.bodyMedium),
        TextButton(
          onPressed: _navigateToLogin,
          child: const Text('Sign In', style: AppTheme.linkText),
        ),
      ],
    );
  }
}
