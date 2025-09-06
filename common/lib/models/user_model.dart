import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'national_id')
  final String? nationalId;
  final String? phone;
  final String? address;
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
  final String? gender;
  final String role;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  // Additional profile information
  final String? occupation;
  @JsonKey(name: 'marital_status')
  final String? maritalStatus;
  final String? nationality;
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  
  // Preferences
  final String? language;
  @JsonKey(name: 'notification_preferences')
  final Map<String, dynamic>? notificationPreferences;
  @JsonKey(name: 'privacy_settings')
  final Map<String, dynamic>? privacySettings;
  
  // Security
  @JsonKey(name: 'two_factor_enabled')
  final bool twoFactorEnabled;
  @JsonKey(name: 'biometric_enabled')
  final bool biometricEnabled;
  @JsonKey(name: 'password_changed_at')
  final DateTime? passwordChangedAt;
  @JsonKey(name: 'failed_login_attempts')
  final int failedLoginAttempts;
  @JsonKey(name: 'locked_until')
  final DateTime? lockedUntil;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.nationalId,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.gender,
    required this.role,
    required this.isActive,
    required this.isVerified,
    this.profileImageUrl,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.occupation,
    this.maritalStatus,
    this.nationality,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.language,
    this.notificationPreferences,
    this.privacySettings,
    required this.twoFactorEnabled,
    required this.biometricEnabled,
    this.passwordChangedAt,
    required this.failedLoginAttempts,
    this.lockedUntil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        nationalId,
        phone,
        address,
        dateOfBirth,
        gender,
        role,
        isActive,
        isVerified,
        profileImageUrl,
        lastLoginAt,
        createdAt,
        updatedAt,
        occupation,
        maritalStatus,
        nationality,
        emergencyContactName,
        emergencyContactPhone,
        language,
        notificationPreferences,
        privacySettings,
        twoFactorEnabled,
        biometricEnabled,
        passwordChangedAt,
        failedLoginAttempts,
        lockedUntil,
      ];

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? nationalId,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
    String? role,
    bool? isActive,
    bool? isVerified,
    String? profileImageUrl,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? occupation,
    String? maritalStatus,
    String? nationality,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? language,
    Map<String, dynamic>? notificationPreferences,
    Map<String, dynamic>? privacySettings,
    bool? twoFactorEnabled,
    bool? biometricEnabled,
    DateTime? passwordChangedAt,
    int? failedLoginAttempts,
    DateTime? lockedUntil,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      nationalId: nationalId ?? this.nationalId,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      occupation: occupation ?? this.occupation,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      nationality: nationality ?? this.nationality,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      language: language ?? this.language,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      privacySettings: privacySettings ?? this.privacySettings,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      passwordChangedAt: passwordChangedAt ?? this.passwordChangedAt,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
    );
  }

  // Helper methods
  bool get isLocked => lockedUntil != null && lockedUntil!.isAfter(DateTime.now());
  
  bool get isAdmin => ['admin', 'super_admin', 'ministry_admin', 'department_admin'].contains(role);
  
  bool get isEmployee => ['employee', 'department_admin', 'ministry_admin', 'admin', 'super_admin'].contains(role);
  
  bool get isCitizen => role == 'citizen';
  
  String get displayName => fullName.isNotEmpty ? fullName : email;
  
  String get initials {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return email[0].toUpperCase();
  }
  
  int get age {
    if (dateOfBirth == null) return 0;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month || 
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
  
  bool get hasCompleteProfile {
    return nationalId != null &&
           phone != null &&
           address != null &&
           dateOfBirth != null &&
           gender != null;
  }
  
  bool get canLogin => isActive && !isLocked;
  
  String get roleDisplayName {
    switch (role) {
      case 'citizen':
        return 'مواطن';
      case 'employee':
        return 'موظف';
      case 'department_admin':
        return 'مدير قسم';
      case 'ministry_admin':
        return 'مدير وزارة';
      case 'admin':
        return 'مدير';
      case 'super_admin':
        return 'مدير عام';
      default:
        return role;
    }
  }
  
  String get genderDisplayName {
    switch (gender) {
      case 'male':
        return 'ذكر';
      case 'female':
        return 'أنثى';
      default:
        return gender ?? 'غير محدد';
    }
  }
  
  String get maritalStatusDisplayName {
    switch (maritalStatus) {
      case 'single':
        return 'أعزب';
      case 'married':
        return 'متزوج';
      case 'divorced':
        return 'مطلق';
      case 'widowed':
        return 'أرمل';
      default:
        return maritalStatus ?? 'غير محدد';
    }
  }

  // Factory constructors for different user types
  factory UserModel.citizen({
    required String id,
    required String email,
    required String fullName,
    String? nationalId,
    String? phone,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      email: email,
      fullName: fullName,
      nationalId: nationalId,
      phone: phone,
      role: 'citizen',
      isActive: true,
      isVerified: false,
      createdAt: now,
      updatedAt: now,
      twoFactorEnabled: false,
      biometricEnabled: false,
      failedLoginAttempts: 0,
    );
  }

  factory UserModel.employee({
    required String id,
    required String email,
    required String fullName,
    required String nationalId,
    String? phone,
    String? role,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      email: email,
      fullName: fullName,
      nationalId: nationalId,
      phone: phone,
      role: role ?? 'employee',
      isActive: true,
      isVerified: true,
      createdAt: now,
      updatedAt: now,
      twoFactorEnabled: false,
      biometricEnabled: false,
      failedLoginAttempts: 0,
    );
  }

  // Empty/default constructor
  factory UserModel.empty() {
    final now = DateTime.now();
    return UserModel(
      id: '',
      email: '',
      fullName: '',
      role: 'citizen',
      isActive: false,
      isVerified: false,
      createdAt: now,
      updatedAt: now,
      twoFactorEnabled: false,
      biometricEnabled: false,
      failedLoginAttempts: 0,
    );
  }
}