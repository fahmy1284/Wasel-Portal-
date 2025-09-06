import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
  success,
  warning,
  error,
  info,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get button colors based on variant
    final colors = _getButtonColors(variant);
    
    // Get button size properties
    final sizeProps = _getButtonSizeProperties(size);
    
    // Create button style
    final buttonStyle = _createButtonStyle(
      colors: colors,
      sizeProps: sizeProps,
      theme: theme,
    );
    
    // Create button content
    Widget buttonContent = _buildButtonContent();
    
    // Wrap with SizedBox if full width
    if (isFullWidth) {
      buttonContent = SizedBox(
        width: double.infinity,
        child: buttonContent,
      );
    }
    
    return buttonContent;
  }
  
  Widget _buildButtonContent() {
    Widget content;
    
    if (isLoading) {
      content = _buildLoadingContent();
    } else if (icon != null) {
      content = _buildIconContent();
    } else {
      content = _buildTextContent();
    }
    
    // Build button based on variant
    switch (variant) {
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: _createButtonStyle(
            colors: _getButtonColors(variant),
            sizeProps: _getButtonSizeProperties(size),
            theme: Theme.of(context),
          ),
          child: content,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          style: _createButtonStyle(
            colors: _getButtonColors(variant),
            sizeProps: _getButtonSizeProperties(size),
            theme: Theme.of(context),
          ),
          child: content,
        );
      default:
        return ElevatedButton(
          onPressed: onPressed,
          style: _createButtonStyle(
            colors: _getButtonColors(variant),
            sizeProps: _getButtonSizeProperties(size),
            theme: Theme.of(context),
          ),
          child: content,
        );
    }
  }
  
  Widget _buildLoadingContent() {
    final sizeProps = _getButtonSizeProperties(size);
    
    return SizedBox(
      height: sizeProps.iconSize,
      width: sizeProps.iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          _getButtonColors(variant).foreground,
        ),
      ),
    );
  }
  
  Widget _buildIconContent() {
    final sizeProps = _getButtonSizeProperties(size);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: sizeProps.iconSize,
        ),
        SizedBox(width: sizeProps.spacing),
        Text(text),
      ],
    );
  }
  
  Widget _buildTextContent() {
    return Text(text);
  }
  
  ButtonStyle _createButtonStyle({
    required _ButtonColors colors,
    required _ButtonSizeProperties sizeProps,
    required ThemeData theme,
  }) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return colors.disabledBackground;
        }
        return colors.background;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return colors.disabledForeground;
        }
        return colors.foreground;
      }),
      overlayColor: MaterialStateProperty.all(colors.overlay),
      elevation: MaterialStateProperty.resolveWith((states) {
        if (variant == ButtonVariant.text || variant == ButtonVariant.outline) {
          return 0;
        }
        if (states.contains(MaterialState.pressed)) {
          return (elevation ?? 2) + 2;
        }
        return elevation ?? 2;
      }),
      padding: MaterialStateProperty.all(
        padding ?? sizeProps.padding,
      ),
      minimumSize: MaterialStateProperty.all(sizeProps.minimumSize),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          side: variant == ButtonVariant.outline
              ? BorderSide(color: colors.border ?? Colors.transparent)
              : BorderSide.none,
        ),
      ),
      textStyle: MaterialStateProperty.all(sizeProps.textStyle),
    );
  }
  
  _ButtonColors _getButtonColors(ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonColors(
          background: AppColors.buttonPrimary,
          foreground: AppColors.textOnPrimary,
          disabledBackground: AppColors.buttonDisabled,
          disabledForeground: AppColors.textDisabled,
          overlay: AppColors.textOnPrimary.withOpacity(0.12),
        );
      case ButtonVariant.secondary:
        return _ButtonColors(
          background: AppColors.buttonSecondary,
          foreground: AppColors.textOnSecondary,
          disabledBackground: AppColors.buttonDisabled,
          disabledForeground: AppColors.textDisabled,
          overlay: AppColors.textOnSecondary.withOpacity(0.12),
        );
      case ButtonVariant.outline:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.primary,
          disabledBackground: Colors.transparent,
          disabledForeground: AppColors.textDisabled,
          overlay: AppColors.primary.withOpacity(0.12),
          border: AppColors.border,
        );
      case ButtonVariant.text:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.primary,
          disabledBackground: Colors.transparent,
          disabledForeground: AppColors.textDisabled,
          overlay: AppColors.primary.withOpacity(0.12),
        );
      case ButtonVariant.success:
        return _ButtonColors(
          background: AppColors.buttonSuccess,
          foreground: AppColors.textOnPrimary,
          disabledBackground: AppColors.buttonDisabled,
          disabledForeground: AppColors.textDisabled,
          overlay: AppColors.textOnPrimary.withOpacity(0.12),
        );
      case ButtonVariant.warning:
        return _ButtonColors(
          background: AppColors.buttonWarning,
          foreground: AppColors.textOnPrimary,
          disabledBackground: AppColors.buttonDisabled,
          disabledForeground: AppColors.textDisabled,
          overlay: AppColors.textOnPrimary.withOpacity(0.12),
        );
      case ButtonVariant.error:
        return _ButtonColors(
          background: AppColors.buttonError,
          foreground: AppColors.textOnPrimary,
          disabledBackground: AppColors.buttonDisabled,
          disabledForeground: AppColors.textDisabled,
          overlay: AppColors.textOnPrimary.withOpacity(0.12),
        );
      case ButtonVariant.info:
        return _ButtonColors(
          background: AppColors.info,
          foreground: AppColors.textOnPrimary,
          disabledBackground: AppColors.buttonDisabled,
          disabledForeground: AppColors.textDisabled,
          overlay: AppColors.textOnPrimary.withOpacity(0.12),
        );
    }
  }
  
  _ButtonSizeProperties _getButtonSizeProperties(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return _ButtonSizeProperties(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(64, 32),
          textStyle: AppTextStyles.buttonSmall,
          iconSize: 16,
          spacing: 6,
        );
      case ButtonSize.medium:
        return _ButtonSizeProperties(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(64, 40),
          textStyle: AppTextStyles.buttonMedium,
          iconSize: 18,
          spacing: 8,
        );
      case ButtonSize.large:
        return _ButtonSizeProperties(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(64, 48),
          textStyle: AppTextStyles.buttonLarge,
          iconSize: 20,
          spacing: 10,
        );
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color overlay;
  final Color? border;

  _ButtonColors({
    required this.background,
    required this.foreground,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.overlay,
    this.border,
  });
}

class _ButtonSizeProperties {
  final EdgeInsetsGeometry padding;
  final Size minimumSize;
  final TextStyle textStyle;
  final double iconSize;
  final double spacing;

  _ButtonSizeProperties({
    required this.padding,
    required this.minimumSize,
    required this.textStyle,
    required this.iconSize,
    required this.spacing,
  });
}