class AppConstants {
  // App Information
  static const String appName = 'واصل';
  static const String appNameEn = 'Wasel';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'بوابة الخدمات الحكومية الإلكترونية - الجمهورية اليمنية';
  
  // Supabase Configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
  
  // API Configuration
  static const String baseUrl = 'https://api.wasel.gov.ye';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String biometricKey = 'biometric_enabled';
  static const String notificationsKey = 'notifications_enabled';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];
  
  // User Roles
  static const Map<String, String> userRoles = {
    'citizen': 'مواطن',
    'employee': 'موظف',
    'department_admin': 'مدير قسم',
    'ministry_admin': 'مدير وزارة',
    'admin': 'مدير',
    'super_admin': 'مدير عام',
  };
  
  // Transaction Status
  static const Map<String, String> transactionStatus = {
    'pending': 'قيد الانتظار',
    'in_progress': 'قيد المعالجة',
    'under_review': 'قيد المراجعة',
    'approved': 'موافق عليه',
    'rejected': 'مرفوض',
    'completed': 'مكتمل',
    'cancelled': 'ملغي',
  };
  
  // Payment Status
  static const Map<String, String> paymentStatus = {
    'pending': 'قيد الانتظار',
    'processing': 'قيد المعالجة',
    'completed': 'مكتمل',
    'failed': 'فاشل',
    'refunded': 'مسترد',
    'cancelled': 'ملغي',
  };
  
  // Notification Types
  static const Map<String, String> notificationTypes = {
    'transaction_update': 'تحديث المعاملة',
    'payment_reminder': 'تذكير دفع',
    'appointment_reminder': 'تذكير موعد',
    'document_ready': 'الوثيقة جاهزة',
    'system_maintenance': 'صيانة النظام',
    'security_alert': 'تنبيه أمني',
  };
  
  // Service Categories
  static const Map<String, String> serviceCategories = {
    'civil_status': 'الأحوال المدنية',
    'passport': 'الجوازات',
    'driving_license': 'رخص القيادة',
    'business_license': 'التراخيص التجارية',
    'health_services': 'الخدمات الصحية',
    'education': 'التعليم',
    'social_services': 'الخدمات الاجتماعية',
    'tax_services': 'الخدمات الضريبية',
    'customs': 'الجمارك',
    'labor': 'العمل',
  };
  
  // Priority Levels
  static const Map<String, String> priorityLevels = {
    'low': 'منخفض',
    'normal': 'عادي',
    'high': 'عالي',
    'urgent': 'عاجل',
    'critical': 'حرج',
  };
  
  // Time Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static const int nationalIdLength = 10;
  static const int phoneNumberLength = 9;
  
  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^[0-9]{9}$';
  static const String nationalIdRegex = r'^[0-9]{10}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]';
  
  // Error Messages
  static const Map<String, String> errorMessages = {
    'network_error': 'خطأ في الاتصال بالشبكة',
    'server_error': 'خطأ في الخادم',
    'unauthorized': 'غير مخول للوصول',
    'forbidden': 'ممنوع الوصول',
    'not_found': 'غير موجود',
    'validation_error': 'خطأ في التحقق من البيانات',
    'timeout_error': 'انتهت مهلة الاتصال',
    'unknown_error': 'خطأ غير معروف',
  };
  
  // Success Messages
  static const Map<String, String> successMessages = {
    'login_success': 'تم تسجيل الدخول بنجاح',
    'logout_success': 'تم تسجيل الخروج بنجاح',
    'register_success': 'تم إنشاء الحساب بنجاح',
    'update_success': 'تم التحديث بنجاح',
    'delete_success': 'تم الحذف بنجاح',
    'save_success': 'تم الحفظ بنجاح',
    'submit_success': 'تم الإرسال بنجاح',
  };
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Cache Durations
  static const Duration shortCache = Duration(minutes: 5);
  static const Duration mediumCache = Duration(hours: 1);
  static const Duration longCache = Duration(days: 1);
  
  // Retry Configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // Biometric Configuration
  static const String biometricReason = 'يرجى التحقق من هويتك للمتابعة';
  static const Duration biometricTimeout = Duration(seconds: 30);
  
  // Location Configuration
  static const double locationAccuracy = 100.0; // meters
  static const Duration locationTimeout = Duration(seconds: 30);
  
  // QR Code Configuration
  static const double qrCodeSize = 200.0;
  static const int qrCodeVersion = 4;
  
  // Notification Configuration
  static const String notificationChannelId = 'wasel_notifications';
  static const String notificationChannelName = 'واصل - الإشعارات';
  static const String notificationChannelDescription = 'إشعارات تطبيق واصل';
  
  // Deep Link Configuration
  static const String deepLinkScheme = 'wasel';
  static const String deepLinkHost = 'gov.ye';
  
  // Social Media Links
  static const Map<String, String> socialMediaLinks = {
    'website': 'https://www.gov.ye',
    'facebook': 'https://facebook.com/YemenGov',
    'twitter': 'https://twitter.com/YemenGov',
    'instagram': 'https://instagram.com/YemenGov',
    'youtube': 'https://youtube.com/YemenGov',
  };
  
  // Contact Information
  static const Map<String, String> contactInfo = {
    'phone': '+967-1-123456',
    'email': 'info@wasel.gov.ye',
    'address': 'صنعاء، الجمهورية اليمنية',
    'support_hours': 'الأحد - الخميس: 8:00 ص - 4:00 م',
  };
  
  // Feature Flags
  static const Map<String, bool> featureFlags = {
    'biometric_login': true,
    'push_notifications': true,
    'offline_mode': true,
    'dark_theme': true,
    'multi_language': false,
    'payment_gateway': true,
    'appointment_booking': true,
    'document_scanner': true,
    'location_services': true,
    'chat_support': false,
  };
}