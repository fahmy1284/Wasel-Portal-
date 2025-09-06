import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

enum UserRole {
  @JsonValue('super_admin')
  superAdmin,
  @JsonValue('admin')
  admin,
  @JsonValue('ministry_admin')
  ministryAdmin,
  @JsonValue('department_admin')
  departmentAdmin,
  @JsonValue('employee')
  employee,
  @JsonValue('citizen')
  citizen,
}

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  @JsonKey(name: 'national_id')
  final String? nationalId;
  final String? email;
  final String? phone;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? governorate;
  final UserRole role;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    this.nationalId,
    this.email,
    this.phone,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.governorate,
    this.role = UserRole.citizen,
    this.isActive = true,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.profileImageUrl,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? nationalId,
    String? email,
    String? phone,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? governorate,
    UserRole? role,
    bool? isActive,
    bool? emailVerified,
    bool? phoneVerified,
    String? profileImageUrl,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nationalId: nationalId ?? this.nationalId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isAdmin => [
        UserRole.superAdmin,
        UserRole.admin,
        UserRole.ministryAdmin,
        UserRole.departmentAdmin,
      ].contains(role);

  bool get isEmployee => role == UserRole.employee;

  bool get isCitizen => role == UserRole.citizen;

  String get displayRole {
    switch (role) {
      case UserRole.superAdmin:
        return 'مدير عام';
      case UserRole.admin:
        return 'مدير';
      case UserRole.ministryAdmin:
        return 'مدير وزارة';
      case UserRole.departmentAdmin:
        return 'مدير إدارة';
      case UserRole.employee:
        return 'موظف';
      case UserRole.citizen:
        return 'مواطن';
    }
  }

  @override
  List<Object?> get props => [
        id,
        nationalId,
        email,
        phone,
        fullName,
        dateOfBirth,
        gender,
        address,
        city,
        governorate,
        role,
        isActive,
        emailVerified,
        phoneVerified,
        profileImageUrl,
        lastLoginAt,
        createdAt,
        updatedAt,
      ];
}