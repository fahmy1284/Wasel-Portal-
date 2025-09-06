import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'service_model.g.dart';

enum ServiceStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('deprecated')
  deprecated,
}

@JsonSerializable()
class ServiceModel extends Equatable {
  final String id;
  @JsonKey(name: 'ministry_id')
  final String? ministryId;
  @JsonKey(name: 'department_id')
  final String? departmentId;
  final String name;
  @JsonKey(name: 'name_en')
  final String? nameEn;
  final String? description;
  @JsonKey(name: 'description_en')
  final String? descriptionEn;
  final String? category;
  final String? subcategory;
  @JsonKey(name: 'service_code')
  final String serviceCode;
  @JsonKey(name: 'fee_amount')
  final double feeAmount;
  @JsonKey(name: 'processing_time_days')
  final int processingTimeDays;
  @JsonKey(name: 'required_documents')
  final List<String> requiredDocuments;
  final ServiceStatus status;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  final String? instructions;
  @JsonKey(name: 'terms_and_conditions')
  final String? termsAndConditions;
  @JsonKey(name: 'is_online')
  final bool isOnline;
  final int priority;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const ServiceModel({
    required this.id,
    this.ministryId,
    this.departmentId,
    required this.name,
    this.nameEn,
    this.description,
    this.descriptionEn,
    this.category,
    this.subcategory,
    required this.serviceCode,
    this.feeAmount = 0.0,
    this.processingTimeDays = 1,
    this.requiredDocuments = const [],
    this.status = ServiceStatus.active,
    this.iconUrl,
    this.instructions,
    this.termsAndConditions,
    this.isOnline = true,
    this.priority = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  ServiceModel copyWith({
    String? id,
    String? ministryId,
    String? departmentId,
    String? name,
    String? nameEn,
    String? description,
    String? descriptionEn,
    String? category,
    String? subcategory,
    String? serviceCode,
    double? feeAmount,
    int? processingTimeDays,
    List<String>? requiredDocuments,
    ServiceStatus? status,
    String? iconUrl,
    String? instructions,
    String? termsAndConditions,
    bool? isOnline,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      ministryId: ministryId ?? this.ministryId,
      departmentId: departmentId ?? this.departmentId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      serviceCode: serviceCode ?? this.serviceCode,
      feeAmount: feeAmount ?? this.feeAmount,
      processingTimeDays: processingTimeDays ?? this.processingTimeDays,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      status: status ?? this.status,
      iconUrl: iconUrl ?? this.iconUrl,
      instructions: instructions ?? this.instructions,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      isOnline: isOnline ?? this.isOnline,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == ServiceStatus.active;
  bool get isFree => feeAmount == 0.0;
  bool get hasDocuments => requiredDocuments.isNotEmpty;

  String get displayStatus {
    switch (status) {
      case ServiceStatus.active:
        return 'نشط';
      case ServiceStatus.inactive:
        return 'غير نشط';
      case ServiceStatus.maintenance:
        return 'قيد الصيانة';
      case ServiceStatus.deprecated:
        return 'متوقف';
    }
  }

  String get formattedFee {
    if (feeAmount == 0.0) return 'مجاني';
    return '${feeAmount.toStringAsFixed(0)} ريال يمني';
  }

  String get processingTimeText {
    if (processingTimeDays == 1) return 'يوم واحد';
    if (processingTimeDays == 2) return 'يومان';
    if (processingTimeDays <= 10) return '$processingTimeDays أيام';
    return '$processingTimeDays يوماً';
  }

  @override
  List<Object?> get props => [
        id,
        ministryId,
        departmentId,
        name,
        nameEn,
        description,
        descriptionEn,
        category,
        subcategory,
        serviceCode,
        feeAmount,
        processingTimeDays,
        requiredDocuments,
        status,
        iconUrl,
        instructions,
        termsAndConditions,
        isOnline,
        priority,
        createdAt,
        updatedAt,
      ];
}