// =====================================================
// Government Services Mock APIs
// Yemen Government Services Portal
// =====================================================

import 'dart:convert';
import 'dart:math';

/// Mock API responses for Yemen Government Services
class GovernmentServicesAPI {
  static final Random _random = Random();
  
  // =====================================================
  // CIVIL STATUS SERVICES (خدمات الأحوال المدنية)
  // =====================================================
  
  /// Birth Certificate Service
  static Future<Map<String, dynamic>> requestBirthCertificate({
    required String nationalId,
    required String fullName,
    required DateTime dateOfBirth,
    required String placeOfBirth,
    required String fatherName,
    required String motherName,
    String? reason,
  }) async {
    await Future.delayed(Duration(seconds: 2 + _random.nextInt(3)));
    
    final requestId = 'BC-${DateTime.now().year}-${_generateRandomNumber(6)}';
    final processingTime = 3 + _random.nextInt(5); // 3-7 days
    
    return {
      'success': true,
      'request_id': requestId,
      'service_code': 'SRV-001',
      'service_name': 'استخراج شهادة ميلاد',
      'status': 'submitted',
      'estimated_completion_days': processingTime,
      'fee_amount': 500.0,
      'currency': 'YER',
      'required_documents': [
        'صورة من الهوية الوطنية',
        'شهادة ميلاد قديمة (إن وجدت)',
        'إفادة من المختار',
      ],
      'processing_steps': [
        'تقديم الطلب',
        'مراجعة البيانات',
        'التحقق من السجلات',
        'إصدار الشهادة',
        'الاستلام',
      ],
      'current_step': 1,
      'message': 'تم تقديم طلبكم بنجاح. سيتم مراجعته خلال $processingTime أيام عمل.',
      'tracking_url': 'https://wasel.gov.ye/track/$requestId',
      'payment_required': true,
      'payment_methods': ['بطاقة ائتمان', 'تحويل بنكي', 'دفع نقدي'],
    };
  }
  
  /// Passport Issuance Service
  static Future<Map<String, dynamic>> requestPassport({
    required String nationalId,
    required String fullName,
    required DateTime dateOfBirth,
    required String placeOfBirth,
    required String address,
    required String phone,
    String passportType = 'ordinary',
    bool isRenewal = false,
    String? oldPassportNumber,
  }) async {
    await Future.delayed(Duration(seconds: 3 + _random.nextInt(4)));
    
    final requestId = 'PP-${DateTime.now().year}-${_generateRandomNumber(6)}';
    final processingTime = 7 + _random.nextInt(7); // 7-14 days
    
    return {
      'success': true,
      'request_id': requestId,
      'service_code': 'SRV-002',
      'service_name': isRenewal ? 'تجديد جواز سفر' : 'استخراج جواز سفر',
      'status': 'submitted',
      'estimated_completion_days': processingTime,
      'fee_amount': isRenewal ? 12000.0 : 15000.0,
      'currency': 'YER',
      'passport_type': passportType,
      'required_documents': [
        'صورة من الهوية الوطنية',
        'صورة شخصية حديثة',
        'شهادة الميلاد',
        if (isRenewal) 'الجواز القديم',
        'إيصال دفع الرسوم',
      ],
      'processing_steps': [
        'تقديم الطلب',
        'مراجعة المستندات',
        'التحقق الأمني',
        'طباعة الجواز',
        'الاستلام',
      ],
      'current_step': 1,
      'appointment_required': true,
      'available_appointments': _generateAppointments(),
      'message': 'تم تقديم طلب الجواز بنجاح. يرجى حجز موعد لاستكمال الإجراءات.',
    };
  }
  
  /// Track Service Request
  static Future<Map<String, dynamic>> trackRequest(String requestId) async {
    await Future.delayed(Duration(seconds: 1 + _random.nextInt(2)));
    
    // Simulate different request statuses
    List<String> statuses = ['submitted', 'under_review', 'approved', 'completed'];
    String currentStatus = statuses[_random.nextInt(statuses.length)];
    
    return {
      'success': true,
      'request_id': requestId,
      'status': currentStatus,
      'status_arabic': _getStatusInArabic(currentStatus),
      'progress_percentage': _getProgressPercentage(currentStatus),
      'last_updated': DateTime.now().toIso8601String(),
      'timeline': _generateTimeline(currentStatus),
      'estimated_completion': DateTime.now().add(Duration(days: 2)).toIso8601String(),
      'notes': _getStatusNotes(currentStatus),
      'next_action': _getNextAction(currentStatus),
    };
  }
  
  // Utility functions
  static String _generateRandomNumber(int length) {
    String result = '';
    for (int i = 0; i < length; i++) {
      result += _random.nextInt(10).toString();
    }
    return result;
  }
  
  static List<Map<String, dynamic>> _generateAppointments() {
    List<Map<String, dynamic>> appointments = [];
    DateTime now = DateTime.now();
    
    for (int i = 1; i <= 14; i++) {
      DateTime date = now.add(Duration(days: i));
      if (date.weekday != DateTime.friday) {
        appointments.add({
          'date': date.toIso8601String().split('T')[0],
          'time_slots': [
            '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
            '13:00', '13:30', '14:00', '14:30', '15:00', '15:30'
          ],
          'available_slots': 8 + _random.nextInt(5),
        });
      }
    }
    
    return appointments;
  }
  
  static String _getStatusInArabic(String status) {
    switch (status) {
      case 'submitted': return 'مقدم';
      case 'under_review': return 'قيد المراجعة';
      case 'approved': return 'موافق عليه';
      case 'completed': return 'مكتمل';
      case 'rejected': return 'مرفوض';
      default: return 'غير محدد';
    }
  }
  
  static double _getProgressPercentage(String status) {
    switch (status) {
      case 'submitted': return 25.0;
      case 'under_review': return 50.0;
      case 'approved': return 75.0;
      case 'completed': return 100.0;
      default: return 0.0;
    }
  }
  
  static List<Map<String, dynamic>> _generateTimeline(String currentStatus) {
    return [
      {
        'step': 'تقديم الطلب',
        'status': 'completed',
        'date': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        'description': 'تم تقديم الطلب بنجاح',
      },
    ];
  }
  
  static String _getStatusNotes(String status) {
    switch (status) {
      case 'submitted': return 'تم استلام طلبكم وهو قيد المراجعة الأولية';
      case 'under_review': return 'يتم مراجعة طلبكم من قبل الجهة المختصة';
      case 'approved': return 'تم الموافقة على طلبكم وهو قيد الإنجاز';
      case 'completed': return 'تم إنجاز طلبكم بنجاح ويمكنكم الاستلام';
      default: return 'لا توجد ملاحظات إضافية';
    }
  }
  
  static String _getNextAction(String status) {
    switch (status) {
      case 'submitted': return 'انتظار المراجعة';
      case 'under_review': return 'انتظار الموافقة';
      case 'approved': return 'انتظار الإنجاز';
      case 'completed': return 'جاهز للاستلام';
      default: return 'لا يوجد إجراء مطلوب';
    }
  }
}