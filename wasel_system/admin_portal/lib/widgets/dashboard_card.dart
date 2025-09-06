import 'package:flutter/material.dart';
import 'package:wasel_common/theme/app_theme.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppTheme.gray400,
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Value
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gray900,
                  fontFamily: 'NotoSansArabic',
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.gray600,
                  fontFamily: 'NotoSansArabic',
                ),
              ),
              
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray500,
                    fontFamily: 'NotoSansArabic',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}