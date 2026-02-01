import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/constants.dart';

/// Custom Button Widget
/// Uber-style modern button with loading state support

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = AppConstants.buttonHeight,
    this.icon,
    this.borderRadius = AppConstants.defaultBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ??
        (isOutlined ? Colors.transparent : AppTheme.primaryColor);
    final fgColor =
        textColor ?? (isOutlined ? AppTheme.primaryColor : Colors.white);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: fgColor,
                side: BorderSide(
                  color: isLoading ? AppTheme.textHint : AppTheme.primaryColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: _buildButtonContent(fgColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: fgColor,
                disabledBackgroundColor: AppTheme.textHint,
                disabledForegroundColor: Colors.white70,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: _buildButtonContent(fgColor),
            ),
    );
  }

  Widget _buildButtonContent(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppTheme.primaryColor : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTheme.buttonText.copyWith(
              color: isOutlined ? AppTheme.primaryColor : Colors.white,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTheme.buttonText.copyWith(
        color: isOutlined ? AppTheme.primaryColor : Colors.white,
      ),
    );
  }
}

/// Secondary Button - Outlined style
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isOutlined: true,
    );
  }
}

/// Text Link Button
class LinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const LinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTheme.linkText.copyWith(
          color: color ?? AppTheme.secondaryColor,
        ),
      ),
    );
  }
}
