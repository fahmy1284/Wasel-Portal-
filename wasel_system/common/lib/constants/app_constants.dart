class AppConstants {
  // App Information
  static const String appName = 'تطبيق واصل';
  static const String appNameEn = 'Wasel Portal';
  static const String appVersion = '1.0.0';
  static const String countryName = 'الجمهورية اليمنية';
  static const String countryNameEn = 'Republic of Yemen';

  // API Configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  static const String baseApiUrl = 'https://api.wasel.gov.ye';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String notificationsEnabledKey = 'notifications_enabled';
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = [
    'pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'
  ];
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int otpLength = 6;
  static const int otpExpiryMinutes = 5;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Session
  static const int sessionTimeoutMinutes = 30;
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 15;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  
  // Biometric
  static const String biometricReason = 'يرجى التحقق من هويتك للمتابعة';
  static const String biometricReasonEn = 'Please verify your identity to continue';
  
  // Error Messages
  static const String networkErrorMessage = 'خطأ في الاتصال بالشبكة';
  static const String serverErrorMessage = 'خطأ في الخادم';
  static const String unknownErrorMessage = 'حدث خطأ غير متوقع';
  
  // Success Messages
  static const String loginSuccessMessage = 'تم تسجيل الدخول بنجاح';
  static const String logoutSuccessMessage = 'تم تسجيل الخروج بنجاح';
  static const String updateSuccessMessage = 'تم التحديث بنجاح';
  
  // Regex Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^(\+967|967|0)?[1-9][0-9]{7,8}$';
  static const String nationalIdPattern = r'^[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{7}$';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String displayDateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Government Service Categories
  static const List<String> serviceCategories = [
    'الأحوال المدنية',
    'الجوازات والهجرة',
    'التوثيق والعدل',
    'الصحة',
    'التعليم',
    'المالية والضرائب',
    'العمل والتوظيف',
    'النقل والمواصلات',
    'الإسكان والعقارات',
    'التجارة والصناعة',
  ];
  
  // Request Status
  static const Map<String, String> requestStatusLabels = {
    'draft': 'مسودة',
    'submitted': 'مقدم',
    'under_review': 'قيد المراجعة',
    'approved': 'موافق عليه',
    'rejected': 'مرفوض',
    'completed': 'مكتمل',
    'cancelled': 'ملغي',
  };
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'بطاقة ائتمان',
    'بطاقة خصم',
    'محفظة إلكترونية',
    'تحويل بنكي',
    'دفع نقدي',
  ];
  
  // Notification Types
  static const Map<String, String> notificationTypeLabels = {
    'info': 'معلومات',
    'warning': 'تحذير',
    'error': 'خطأ',
    'success': 'نجح',
    'reminder': 'تذكير',
  };
  
  // Document Types
  static const Map<String, String> documentTypeLabels = {
    'national_id': 'الهوية الوطنية',
    'passport': 'جواز السفر',
    'birth_certificate': 'شهادة الميلاد',
    'marriage_certificate': 'شهادة الزواج',
    'divorce_certificate': 'شهادة الطلاق',
    'death_certificate': 'شهادة الوفاة',
    'business_license': 'رخصة تجارية',
    'tax_certificate': 'شهادة ضريبية',
    'property_deed': 'صك الملكية',
    'driving_license': 'رخصة القيادة',
    'vehicle_registration': 'تسجيل المركبة',
    'medical_certificate': 'شهادة طبية',
    'education_certificate': 'شهادة تعليمية',
    'employment_certificate': 'شهادة عمل',
    'other': 'أخرى',
  };
  
  // User Roles
  static const Map<String, String> userRoleLabels = {
    'super_admin': 'مدير عام',
    'admin': 'مدير',
    'ministry_admin': 'مدير وزارة',
    'department_admin': 'مدير إدارة',
    'employee': 'موظف',
    'citizen': 'مواطن',
  };
  
  // Governorates of Yemen
  static const List<String> yemenGovernorates = [
    'صنعاء',
    'عدن',
    'تعز',
    'الحديدة',
    'إب',
    'ذمار',
    'حضرموت',
    'المحويت',
    'حجة',
    'صعدة',
    'عمران',
    'البيضاء',
    'لحج',
    'أبين',
    'شبوة',
    'المهرة',
    'الجوف',
    'ريمة',
    'الضالع',
    'أرخبيل سقطرى',
  ];
  
  // Contact Information
  static const String supportEmail = 'support@wasel.gov.ye';
  static const String supportPhone = '+967-1-123456';
  static const String websiteUrl = 'https://wasel.gov.ye';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/wasel.gov.ye';
  static const String twitterUrl = 'https://twitter.com/wasel_gov_ye';
  static const String instagramUrl = 'https://instagram.com/wasel.gov.ye';
  
  // Privacy and Terms
  static const String privacyPolicyUrl = 'https://wasel.gov.ye/privacy';
  static const String termsOfServiceUrl = 'https://wasel.gov.ye/terms';
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  
  // Development
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool enableMockData = false;
}