import 'package:flutter/material.dart';

class AppColors {
  // Yemen Flag Colors - Primary Palette
  static const Color yemenRed = Color(0xFFCE1126);
  static const Color yemenWhite = Color(0xFFFFFFFF);
  static const Color yemenBlack = Color(0xFF000000);
  
  // Primary Colors
  static const Color primary = yemenRed;
  static const Color primaryLight = Color(0xFFE85A6B);
  static const Color primaryDark = Color(0xFF9A0D1E);
  static const Color primaryVariant = Color(0xFFB30E20);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF2196F3);
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF1976D2);
  static const Color secondaryVariant = Color(0xFF1E88E5);
  
  // Accent Colors
  static const Color accent = Color(0xFFFF9800);
  static const Color accentLight = Color(0xFFFFB74D);
  static const Color accentDark = Color(0xFFF57C00);
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = yemenWhite;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = yemenWhite;
  static const Color textOnSecondary = yemenWhite;
  static const Color textOnBackground = textPrimary;
  static const Color textOnSurface = textPrimary;
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);
  
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  
  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // Border Colors
  static const Color border = grey300;
  static const Color borderLight = grey200;
  static const Color borderDark = grey400;
  static const Color borderFocus = primary;
  static const Color borderError = error;
  static const Color borderSuccess = success;
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x33000000);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xB3000000);
  
  // Divider Colors
  static const Color divider = grey300;
  static const Color dividerLight = grey200;
  static const Color dividerDark = grey400;
  
  // Card Colors
  static const Color card = yemenWhite;
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color cardElevated = yemenWhite;
  
  // Input Colors
  static const Color inputFill = grey50;
  static const Color inputFillDark = Color(0xFF2C2C2C);
  static const Color inputBorder = grey300;
  static const Color inputBorderFocus = primary;
  static const Color inputBorderError = error;
  
  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonSuccess = success;
  static const Color buttonWarning = warning;
  static const Color buttonError = error;
  static const Color buttonDisabled = grey400;
  
  // Navigation Colors
  static const Color navigationBar = yemenWhite;
  static const Color navigationBarDark = Color(0xFF1E1E1E);
  static const Color navigationIcon = grey600;
  static const Color navigationIconActive = primary;
  
  // App Bar Colors
  static const Color appBar = primary;
  static const Color appBarDark = Color(0xFF1E1E1E);
  static const Color appBarText = yemenWhite;
  static const Color appBarIcon = yemenWhite;
  
  // Floating Action Button Colors
  static const Color fab = primary;
  static const Color fabDark = secondary;
  
  // Chip Colors
  static const Color chip = grey100;
  static const Color chipSelected = primary;
  static const Color chipText = textPrimary;
  static const Color chipTextSelected = yemenWhite;
  
  // Progress Colors
  static const Color progress = primary;
  static const Color progressBackground = grey200;
  
  // Slider Colors
  static const Color sliderActive = primary;
  static const Color sliderInactive = grey300;
  static const Color sliderThumb = primary;
  
  // Switch Colors
  static const Color switchActive = primary;
  static const Color switchInactive = grey400;
  static const Color switchThumb = yemenWhite;
  
  // Checkbox Colors
  static const Color checkboxActive = primary;
  static const Color checkboxInactive = grey400;
  static const Color checkboxCheck = yemenWhite;
  
  // Radio Colors
  static const Color radioActive = primary;
  static const Color radioInactive = grey400;
  
  // Tab Colors
  static const Color tabSelected = primary;
  static const Color tabUnselected = grey600;
  static const Color tabIndicator = primary;
  
  // Snackbar Colors
  static const Color snackbarBackground = grey800;
  static const Color snackbarText = yemenWhite;
  static const Color snackbarAction = secondary;
  
  // Dialog Colors
  static const Color dialogBackground = yemenWhite;
  static const Color dialogBackgroundDark = Color(0xFF2C2C2C);
  
  // Tooltip Colors
  static const Color tooltip = grey700;
  static const Color tooltipText = yemenWhite;
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    primary,
    primaryDark,
  ];
  
  static const List<Color> secondaryGradient = [
    secondary,
    secondaryDark,
  ];
  
  static const List<Color> yemenFlagGradient = [
    yemenRed,
    yemenWhite,
    yemenBlack,
  ];
  
  static const List<Color> backgroundGradient = [
    Color(0xFFF8F9FA),
    Color(0xFFE9ECEF),
  ];
  
  // Service Category Colors
  static const Map<String, Color> serviceCategoryColors = {
    'civil_status': Color(0xFF4CAF50),
    'passport': Color(0xFF2196F3),
    'driving_license': Color(0xFFFF9800),
    'business_license': Color(0xFF9C27B0),
    'health_services': Color(0xFFF44336),
    'education': Color(0xFF3F51B5),
    'social_services': Color(0xFF009688),
    'tax_services': Color(0xFF795548),
    'customs': Color(0xFF607D8B),
    'labor': Color(0xFF8BC34A),
  };
  
  // Status Colors Map
  static const Map<String, Color> statusColors = {
    'pending': warning,
    'in_progress': info,
    'under_review': Color(0xFF9C27B0),
    'approved': success,
    'rejected': error,
    'completed': success,
    'cancelled': grey500,
  };
  
  // Priority Colors
  static const Map<String, Color> priorityColors = {
    'low': success,
    'normal': info,
    'high': warning,
    'urgent': error,
    'critical': Color(0xFF8E24AA),
  };
  
  // Chart Colors
  static const List<Color> chartColors = [
    primary,
    secondary,
    success,
    warning,
    error,
    info,
    Color(0xFF9C27B0),
    Color(0xFF009688),
    Color(0xFF795548),
    Color(0xFF607D8B),
  ];
  
  // Semantic Colors
  static const Color online = success;
  static const Color offline = grey500;
  static const Color busy = warning;
  static const Color away = Color(0xFFFF9800);
  static const Color doNotDisturb = error;
  
  // Rating Colors
  static const Color ratingFilled = Color(0xFFFFD700);
  static const Color ratingEmpty = grey300;
  
  // Badge Colors
  static const Color badgeRed = error;
  static const Color badgeGreen = success;
  static const Color badgeBlue = info;
  static const Color badgeOrange = warning;
  static const Color badgePurple = Color(0xFF9C27B0);
  
  // Accessibility Colors
  static const Color focusIndicator = Color(0xFF2196F3);
  static const Color highContrast = yemenBlack;
  
  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFFE85A6B);
  static const Color darkSecondary = Color(0xFF64B5F6);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = yemenBlack;
  static const Color darkOnSecondary = yemenBlack;
  static const Color darkOnBackground = yemenWhite;
  static const Color darkOnSurface = yemenWhite;
  static const Color darkOnError = yemenBlack;
}