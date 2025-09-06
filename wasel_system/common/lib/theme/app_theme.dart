import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Yemen Flag Colors
  static const Color yemenRed = Color(0xFFCE1126);
  static const Color yemenWhite = Color(0xFFFFFFFF);
  static const Color yemenBlack = Color(0xFF000000);
  
  // Additional Colors
  static const Color techBlue = Color(0xFF1E40AF);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color warningYellow = Color(0xFFD97706);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color purplePrimary = Color(0xFF7C3AED);
  static const Color indigoPrimary = Color(0xFF4F46E5);
  
  // Neutral Colors
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  
  // Gradients
  static const LinearGradient yemenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [yemenRed, techBlue],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gray50, gray200],
  );
  
  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: gray900,
    height: 1.2,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: gray900,
    height: 1.3,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: gray900,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: gray700,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: gray600,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: gray500,
    height: 1.4,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: gray700,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: gray600,
    height: 1.3,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: gray500,
    height: 1.2,
  );
  
  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: yemenRed,
    foregroundColor: yemenWhite,
    elevation: 2,
    shadowColor: yemenRed.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: const TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: gray100,
    foregroundColor: gray700,
    elevation: 1,
    shadowColor: gray400.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: gray300),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: const TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
  
  static ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: yemenRed,
    side: const BorderSide(color: yemenRed, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: const TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  
  // Input Decoration
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: yemenWhite,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: gray300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: gray300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: yemenRed, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: errorRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: errorRed, width: 2),
    ),
    labelStyle: const TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 14,
      color: gray600,
    ),
    hintStyle: const TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 14,
      color: gray400,
    ),
    errorStyle: const TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 12,
      color: errorRed,
    ),
  );
  
  // Card Theme
  static CardTheme cardTheme = CardTheme(
    elevation: 2,
    shadowColor: gray400.withOpacity(0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: yemenWhite,
    margin: const EdgeInsets.all(8),
  );
  
  // App Bar Theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: yemenWhite,
    foregroundColor: gray900,
    elevation: 1,
    shadowColor: gray200,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: gray900,
    ),
    iconTheme: IconThemeData(
      color: gray700,
      size: 24,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData bottomNavigationBarTheme = 
      const BottomNavigationBarThemeData(
    backgroundColor: yemenWhite,
    selectedItemColor: yemenRed,
    unselectedItemColor: gray400,
    selectedLabelStyle: TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );
  
  // Floating Action Button Theme
  static FloatingActionButtonThemeData floatingActionButtonTheme = 
      const FloatingActionButtonThemeData(
    backgroundColor: yemenRed,
    foregroundColor: yemenWhite,
    elevation: 4,
    shape: CircleBorder(),
  );
  
  // Chip Theme
  static ChipThemeData chipTheme = ChipThemeData(
    backgroundColor: gray100,
    selectedColor: yemenRed.withOpacity(0.1),
    disabledColor: gray200,
    labelStyle: const TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 12,
      color: gray700,
    ),
    secondaryLabelStyle: const TextStyle(
      fontFamily: 'NotoSansArabic',
      fontSize: 12,
      color: yemenRed,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
  
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: yemenRed,
    scaffoldBackgroundColor: gray50,
    colorScheme: const ColorScheme.light(
      primary: yemenRed,
      secondary: techBlue,
      surface: yemenWhite,
      background: gray50,
      error: errorRed,
      onPrimary: yemenWhite,
      onSecondary: yemenWhite,
      onSurface: gray900,
      onBackground: gray900,
      onError: yemenWhite,
    ),
    fontFamily: 'NotoSansArabic',
    textTheme: const TextTheme(
      headlineLarge: headingLarge,
      headlineMedium: headingMedium,
      headlineSmall: headingSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
    inputDecorationTheme: inputDecorationTheme,
    cardTheme: cardTheme,
    appBarTheme: appBarTheme,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    floatingActionButtonTheme: floatingActionButtonTheme,
    chipTheme: chipTheme,
    dividerColor: gray200,
    iconTheme: const IconThemeData(
      color: gray600,
      size: 24,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: yemenRed,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return yemenRed;
        }
        return gray400;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return yemenRed.withOpacity(0.3);
        }
        return gray200;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return yemenRed;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(yemenWhite),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return yemenRed;
        }
        return gray400;
      }),
    ),
  );
  
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: yemenRed,
    scaffoldBackgroundColor: gray900,
    colorScheme: const ColorScheme.dark(
      primary: yemenRed,
      secondary: techBlue,
      surface: gray800,
      background: gray900,
      error: errorRed,
      onPrimary: yemenWhite,
      onSecondary: yemenWhite,
      onSurface: gray100,
      onBackground: gray100,
      onError: yemenWhite,
    ),
    fontFamily: 'NotoSansArabic',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: gray100,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: gray100,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: gray100,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: gray300,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: gray400,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: gray500,
        height: 1.4,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: gray800,
      margin: const EdgeInsets.all(8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: gray800,
      foregroundColor: gray100,
      elevation: 1,
      shadowColor: Colors.black26,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: gray100,
      ),
      iconTheme: IconThemeData(
        color: gray300,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: gray800,
      selectedItemColor: yemenRed,
      unselectedItemColor: gray500,
      selectedLabelStyle: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'NotoSansArabic',
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
  
  // Animation Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve fastCurve = Curves.easeOut;
  static const Curve slowCurve = Curves.easeInOutCubic;
  
  // Border Radius
  static const BorderRadius smallRadius = BorderRadius.all(Radius.circular(4));
  static const BorderRadius mediumRadius = BorderRadius.all(Radius.circular(8));
  static const BorderRadius largeRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius extraLargeRadius = BorderRadius.all(Radius.circular(16));
  
  // Shadows
  static List<BoxShadow> smallShadow = [
    BoxShadow(
      color: gray400.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: gray400.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> largeShadow = [
    BoxShadow(
      color: gray400.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}