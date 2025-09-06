import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonType { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget buttonChild = _buildButtonContent();
    
    if (isFullWidth) {
      buttonChild = SizedBox(
        width: double.infinity,
        child: buttonChild,
      );
    }

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getPrimaryButtonStyle(theme),
          child: buttonChild,
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getSecondaryButtonStyle(theme),
          child: buttonChild,
        );
      case ButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getOutlineButtonStyle(theme),
          child: buttonChild,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _getTextButtonStyle(theme),
          child: buttonChild,
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? AppTheme.yemenWhite,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('جاري التحميل...'),
        ],
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getPrimaryButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppTheme.yemenRed,
      foregroundColor: textColor ?? AppTheme.yemenWhite,
      elevation: 2,
      shadowColor: AppTheme.yemenRed.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
      ),
      padding: _getPadding(),
      textStyle: _getTextStyle(),
      minimumSize: _getMinimumSize(),
    );
  }

  ButtonStyle _getSecondaryButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppTheme.gray100,
      foregroundColor: textColor ?? AppTheme.gray700,
      elevation: 1,
      shadowColor: AppTheme.gray400.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
        side: const BorderSide(color: AppTheme.gray300),
      ),
      padding: _getPadding(),
      textStyle: _getTextStyle(),
      minimumSize: _getMinimumSize(),
    );
  }

  ButtonStyle _getOutlineButtonStyle(ThemeData theme) {
    return OutlinedButton.styleFrom(
      foregroundColor: textColor ?? AppTheme.yemenRed,
      side: BorderSide(
        color: backgroundColor ?? AppTheme.yemenRed,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
      ),
      padding: _getPadding(),
      textStyle: _getTextStyle(),
      minimumSize: _getMinimumSize(),
    );
  }

  ButtonStyle _getTextButtonStyle(ThemeData theme) {
    return TextButton.styleFrom(
      foregroundColor: textColor ?? AppTheme.yemenRed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
      ),
      padding: _getPadding(),
      textStyle: _getTextStyle(),
      minimumSize: _getMinimumSize(),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return const TextStyle(
          fontFamily: 'NotoSansArabic',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.medium:
        return const TextStyle(
          fontFamily: 'NotoSansArabic',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.large:
        return const TextStyle(
          fontFamily: 'NotoSansArabic',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        );
    }
  }

  Size _getMinimumSize() {
    switch (size) {
      case ButtonSize.small:
        return const Size(64, 32);
      case ButtonSize.medium:
        return const Size(88, 40);
      case ButtonSize.large:
        return const Size(112, 48);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return 6;
      case ButtonSize.medium:
        return 8;
      case ButtonSize.large:
        return 10;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.large:
        return 20;
    }
  }
}