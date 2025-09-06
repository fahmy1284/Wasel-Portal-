import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_common/theme/app_theme.dart';
import '../blocs/auth/auth_bloc.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final int index;
  final List<String>? requiredRoles;

  const SidebarItem({
    required this.title,
    required this.icon,
    required this.index,
    this.requiredRoles,
  });
}

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const List<SidebarItem> _menuItems = [
    SidebarItem(
      title: 'لوحة التحكم',
      icon: Icons.dashboard_outlined,
      index: 0,
    ),
    SidebarItem(
      title: 'إدارة المستخدمين',
      icon: Icons.people_outline,
      index: 1,
      requiredRoles: ['super_admin', 'admin'],
    ),
    SidebarItem(
      title: 'إدارة الخدمات',
      icon: Icons.miscellaneous_services_outlined,
      index: 2,
      requiredRoles: ['super_admin', 'admin', 'ministry_admin'],
    ),
    SidebarItem(
      title: 'طلبات الخدمات',
      icon: Icons.description_outlined,
      index: 3,
    ),
    SidebarItem(
      title: 'المدفوعات',
      icon: Icons.payment_outlined,
      index: 4,
    ),
    SidebarItem(
      title: 'التقارير',
      icon: Icons.analytics_outlined,
      index: 5,
    ),
    SidebarItem(
      title: 'الإشعارات',
      icon: Icons.notifications_outlined,
      index: 6,
    ),
    SidebarItem(
      title: 'الوزارات والإدارات',
      icon: Icons.account_balance_outlined,
      index: 7,
      requiredRoles: ['super_admin', 'admin'],
    ),
    SidebarItem(
      title: 'سجل الأنشطة',
      icon: Icons.history_outlined,
      index: 8,
      requiredRoles: ['super_admin', 'admin'],
    ),
    SidebarItem(
      title: 'الإعدادات',
      icon: Icons.settings_outlined,
      index: 9,
      requiredRoles: ['super_admin', 'admin'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: AppTheme.yemenWhite,
        border: Border(
          left: BorderSide(color: AppTheme.gray200),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Menu Items
          Expanded(
            child: _buildMenuItems(context),
          ),
          
          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.gray200),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              gradient: AppTheme.yemenGradient,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                '🇾🇪',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // App Name
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بوابة الإدارة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                    fontFamily: 'NotoSansArabic',
                  ),
                ),
                Text(
                  'واصل',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray600,
                    fontFamily: 'NotoSansArabic',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            final item = _menuItems[index];
            
            // Check if user has required role
            if (item.requiredRoles != null) {
              final userRole = state.user.role.name;
              if (!item.requiredRoles!.contains(userRole)) {
                return const SizedBox.shrink();
              }
            }

            final isSelected = selectedIndex == item.index;
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onItemSelected(item.index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.yemenRed.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(
                              color: AppTheme.yemenRed.withOpacity(0.3),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: isSelected 
                              ? AppTheme.yemenRed
                              : AppTheme.gray600,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected 
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected 
                                  ? AppTheme.yemenRed
                                  : AppTheme.gray700,
                              fontFamily: 'NotoSansArabic',
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppTheme.yemenRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.gray200),
        ),
      ),
      child: Column(
        children: [
          // Support Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.gray50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 16,
                      color: AppTheme.gray600,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'المساعدة والدعم',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray700,
                        fontFamily: 'NotoSansArabic',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 12,
                      color: AppTheme.gray500,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'support@wasel.gov.ye',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.gray500,
                        fontFamily: 'NotoSansArabic',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Version
          const Text(
            'الإصدار 1.0.0',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.gray400,
              fontFamily: 'NotoSansArabic',
            ),
          ),
        ],
      ),
    );
  }
}