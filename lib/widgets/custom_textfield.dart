// ============================================================
// FILE: custom_textfield.dart
// PURPOSE: Reusable text input widgets for forms
// Includes base CustomTextField, EmailTextField, PasswordTextField
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';

// CustomTextField is a reusable input field widget
// It handles validation, focus states, and password visibility
class CustomTextField extends StatefulWidget {
  // ----------------------------------------------------------
  // PROPERTIES
  // ----------------------------------------------------------

  final String label; // Label above the field
  final String? hint; // Placeholder text inside field
  final TextEditingController controller; // Stores input value
  final String? Function(String?)? validator; // Validation function
  final TextInputType keyboardType; // Number, email, text, etc.
  final TextInputAction textInputAction; // Next, done, etc.
  final bool obscureText; // Hide text (for passwords)
  final bool enabled; // Can user interact?
  final int maxLines; // Multi-line input
  final int? maxLength; // Character limit
  final IconData? prefixIcon; // Icon on left side
  final Widget? suffix; // Widget on right side
  final List<TextInputFormatter>? inputFormatters; // Input filters
  final void Function(String)? onChanged; // Called on each keystroke
  final void Function(String)? onSubmitted; // Called on Enter/Done
  final FocusNode? focusNode; // Manage focus programmatically
  final bool autofocus; // Focus on screen load

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffix,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: _isFocused ? AppTheme.primaryColor : AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        // Text Field
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.obscureText && !_isPasswordVisible,
          enabled: widget.enabled,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: AppTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            counterText: '',
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? AppTheme.primaryColor
                        : AppTheme.textHint,
                    size: 22,
                  )
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textHint,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : widget.suffix,
            filled: true,
            fillColor: widget.enabled
                ? AppTheme.inputFillColor
                : AppTheme.dividerColor,
          ),
        ),
      ],
    );
  }
}

/// Email TextField with pre-configured settings
class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;

  const EmailTextField({
    super.key,
    required this.controller,
    this.validator,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Email',
      hint: 'Enter your email',
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      prefixIcon: Icons.email_outlined,
      focusNode: focusNode,
    );
  }
}

/// Password TextField with pre-configured settings
class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final String hint;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.validator,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.focusNode,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      obscureText: true,
      textInputAction: textInputAction,
      prefixIcon: Icons.lock_outlined,
      focusNode: focusNode,
    );
  }
}
