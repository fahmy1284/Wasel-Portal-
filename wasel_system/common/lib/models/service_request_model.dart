import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'service_request_model.g.dart';

enum RequestStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('submitted')
  submitted,
  @JsonValue('under_review')
  underReview,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@JsonSerializable()
class ServiceRequestModel extends Equatable {
  final String id;
  @JsonKey(name: 'request_number')
  final String requestNumber;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'service_id')
  final String serviceId;
  final RequestStatus status;
  @JsonKey(name: 'form_data')
  final Map<String, dynamic>? formData;
  @JsonKey(name: 'submitted_at')
  final DateTime? submittedAt;
  @JsonKey(name: 'reviewed_at')
  final DateTime? reviewedAt;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @JsonKey(name: 'reviewer_id')
  final String? reviewerId;
  @JsonKey(name: 'reviewer_notes')
  final String? reviewerNotes;
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  final int priority;
  @JsonKey(name: 'estimated_completion_date')
  final DateTime? estimatedCompletionDate;
  @JsonKey(name: 'actual_completion_date')
  final DateTime? actualCompletionDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const ServiceRequestModel({
    required this.id,
    required this.requestNumber,
    required this.userId,
    required this.serviceId,
    this.status = RequestStatus.draft,
    this.formData,
    this.submittedAt,
    this.reviewedAt,
    this.completedAt,
    this.reviewerId,
    this.reviewerNotes,
    this.rejectionReason,
    this.priority = 0,
    this.estimatedCompletionDate,
    this.actualCompletionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceRequestModelToJson(this);

  ServiceRequestModel copyWith({
    String? id,
    String? requestNumber,
    String? userId,
    String? serviceId,
    RequestStatus? status,
    Map<String, dynamic>? formData,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    DateTime? completedAt,
    String? reviewerId,
    String? reviewerNotes,
    String? rejectionReason,
    int? priority,
    DateTime? estimatedCompletionDate,
    DateTime? actualCompletionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      status: status ?? this.status,
      formData: formData ?? this.formData,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      completedAt: completedAt ?? this.completedAt,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerNotes: reviewerNotes ?? this.reviewerNotes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      priority: priority ?? this.priority,
      estimatedCompletionDate: estimatedCompletionDate ?? this.estimatedCompletionDate,
      actualCompletionDate: actualCompletionDate ?? this.actualCompletionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isDraft => status == RequestStatus.draft;
  bool get isSubmitted => status == RequestStatus.submitted;
  bool get isUnderReview => status == RequestStatus.underReview;
  bool get isApproved => status == RequestStatus.approved;
  bool get isRejected => status == RequestStatus.rejected;
  bool get isCompleted => status == RequestStatus.completed;
  bool get isCancelled => status == RequestStatus.cancelled;
  bool get isActive => ![RequestStatus.completed, RequestStatus.cancelled, RequestStatus.rejected].contains(status);
  bool get canEdit => status == RequestStatus.draft;
  bool get canCancel => [RequestStatus.draft, RequestStatus.submitted].contains(status);

  String get displayStatus {
    switch (status) {
      case RequestStatus.draft:
        return 'مسودة';
      case RequestStatus.submitted:
        return 'مقدم';
      case RequestStatus.underReview:
        return 'قيد المراجعة';
      case RequestStatus.approved:
        return 'موافق عليه';
      case RequestStatus.rejected:
        return 'مرفوض';
      case RequestStatus.completed:
        return 'مكتمل';
      case RequestStatus.cancelled:
        return 'ملغي';
    }
  }

  String get statusColor {
    switch (status) {
      case RequestStatus.draft:
        return '#6B7280'; // gray
      case RequestStatus.submitted:
        return '#3B82F6'; // blue
      case RequestStatus.underReview:
        return '#F59E0B'; // yellow
      case RequestStatus.approved:
        return '#10B981'; // green
      case RequestStatus.rejected:
        return '#EF4444'; // red
      case RequestStatus.completed:
        return '#16A34A'; // success green
      case RequestStatus.cancelled:
        return '#6B7280'; // gray
    }
  }

  double get progressPercentage {
    switch (status) {
      case RequestStatus.draft:
        return 0.1;
      case RequestStatus.submitted:
        return 0.3;
      case RequestStatus.underReview:
        return 0.6;
      case RequestStatus.approved:
        return 0.8;
      case RequestStatus.completed:
        return 1.0;
      case RequestStatus.rejected:
      case RequestStatus.cancelled:
        return 0.0;
    }
  }

  List<String> get statusSteps {
    return [
      'إنشاء الطلب',
      'تقديم الطلب',
      'مراجعة الطلب',
      'الموافقة',
      'إكمال الطلب',
    ];
  }

  int get currentStepIndex {
    switch (status) {
      case RequestStatus.draft:
        return 0;
      case RequestStatus.submitted:
        return 1;
      case RequestStatus.underReview:
        return 2;
      case RequestStatus.approved:
        return 3;
      case RequestStatus.completed:
        return 4;
      case RequestStatus.rejected:
      case RequestStatus.cancelled:
        return -1;
    }
  }

  Duration? get processingDuration {
    if (submittedAt == null) return null;
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(submittedAt!);
  }

  bool get isOverdue {
    if (estimatedCompletionDate == null || isCompleted) return false;
    return DateTime.now().isAfter(estimatedCompletionDate!);
  }

  int get daysRemaining {
    if (estimatedCompletionDate == null || isCompleted) return 0;
    final now = DateTime.now();
    if (now.isAfter(estimatedCompletionDate!)) return 0;
    return estimatedCompletionDate!.difference(now).inDays;
  }

  @override
  List<Object?> get props => [
        id,
        requestNumber,
        userId,
        serviceId,
        status,
        formData,
        submittedAt,
        reviewedAt,
        completedAt,
        reviewerId,
        reviewerNotes,
        rejectionReason,
        priority,
        estimatedCompletionDate,
        actualCompletionDate,
        createdAt,
        updatedAt,
      ];
}