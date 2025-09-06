import 'package:flutter/material.dart';
import 'package:wasel_common/theme/app_theme.dart';
import 'package:wasel_common/constants/app_constants.dart';
import 'package:intl/intl.dart';

class RecentRequestsCard extends StatelessWidget {
  final List<Map<String, dynamic>> requests;

  const RecentRequestsCard({
    super.key,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.yemenWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gray200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gray400.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'الطلبات الحديثة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gray900,
                  fontFamily: 'NotoSansArabic',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all requests
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontFamily: 'NotoSansArabic',
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Requests List
          if (requests.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 48,
                      color: AppTheme.gray400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد طلبات حديثة',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.gray500,
                        fontFamily: 'NotoSansArabic',
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              separatorBuilder: (context, index) => const Divider(
                color: AppTheme.gray200,
              ),
              itemBuilder: (context, index) {
                final request = requests[index];
                return _buildRequestItem(request);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> request) {
    final status = request['status'] as String? ?? 'draft';
    final requestNumber = request['request_number'] as String? ?? '';
    final createdAt = request['created_at'] as String?;
    final serviceId = request['service_id'] as String? ?? '';
    
    DateTime? createdDate;
    if (createdAt != null) {
      try {
        createdDate = DateTime.parse(createdAt);
      } catch (e) {
        // Handle parsing error
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Status Indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              shape: BoxShape.circle,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Request Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      requestNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                        fontFamily: 'NotoSansArabic',
                      ),
                    ),
                    const Spacer(),
                    if (createdDate != null)
                      Text(
                        DateFormat('dd/MM/yyyy').format(createdDate),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray500,
                          fontFamily: 'NotoSansArabic',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppConstants.requestStatusLabels[status] ?? status,
                        style: TextStyle(
                          fontSize: 10,
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'NotoSansArabic',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'خدمة: $serviceId',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray600,
                          fontFamily: 'NotoSansArabic',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Button
          IconButton(
            onPressed: () {
              // TODO: Navigate to request details
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.gray400,
            ),
            tooltip: 'عرض التفاصيل',
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'draft':
        return AppTheme.gray500;
      case 'submitted':
        return AppTheme.techBlue;
      case 'under_review':
        return AppTheme.warningYellow;
      case 'approved':
        return AppTheme.successGreen;
      case 'rejected':
        return AppTheme.errorRed;
      case 'completed':
        return AppTheme.successGreen;
      case 'cancelled':
        return AppTheme.gray500;
      default:
        return AppTheme.gray400;
    }
  }
}