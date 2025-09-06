import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_common/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/chart_card.dart';
import '../widgets/recent_requests_card.dart';
import '../widgets/sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(DashboardDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                // App Bar
                _buildAppBar(),
                
                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppTheme.yemenWhite,
        border: Border(
          bottom: BorderSide(color: AppTheme.gray200),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Title
            const Text(
              'لوحة التحكم',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.gray900,
                fontFamily: 'NotoSansArabic',
              ),
            ),
            
            const Spacer(),
            
            // Refresh Button
            IconButton(
              onPressed: () {
                context.read<DashboardBloc>().add(DashboardRefreshRequested());
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'تحديث البيانات',
            ),
            
            const SizedBox(width: 16),
            
            // Notifications
            IconButton(
              onPressed: () {
                // TODO: Show notifications
              },
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'الإشعارات',
            ),
            
            const SizedBox(width: 16),
            
            // User Menu
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return PopupMenuButton<String>(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.yemenRed,
                          child: Text(
                            state.user.fullName.isNotEmpty 
                                ? state.user.fullName[0].toUpperCase()
                                : 'A',
                            style: const TextStyle(
                              color: AppTheme.yemenWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.fullName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.gray900,
                                fontFamily: 'NotoSansArabic',
                              ),
                            ),
                            Text(
                              state.user.displayRole,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.gray600,
                                fontFamily: 'NotoSansArabic',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.gray600,
                        ),
                      ],
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person_outline),
                            SizedBox(width: 8),
                            Text('الملف الشخصي'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings_outlined),
                            SizedBox(width: 8),
                            Text('الإعدادات'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: AppTheme.errorRed),
                            SizedBox(width: 8),
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(color: AppTheme.errorRed),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'logout':
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                          break;
                        case 'profile':
                          // TODO: Navigate to profile
                          break;
                        case 'settings':
                          // TODO: Navigate to settings
                          break;
                      }
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedIndex == 0) {
      return _buildDashboardContent();
    }
    
    // TODO: Add other screens based on selected index
    return const Center(
      child: Text(
        'قريباً...',
        style: TextStyle(
          fontSize: 24,
          color: AppTheme.gray500,
          fontFamily: 'NotoSansArabic',
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.errorRed,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.errorRed,
                    fontFamily: 'NotoSansArabic',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<DashboardBloc>().add(DashboardDataRequested());
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        
        if (state is DashboardLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Cards
                _buildStatisticsCards(state.data),
                
                const SizedBox(height: 24),
                
                // Charts Row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ChartCard(
                        title: 'الطلبات حسب الحالة',
                        child: _buildRequestStatusChart(state.data.requestsByStatus),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: ChartCard(
                        title: 'الطلبات الشهرية',
                        child: _buildMonthlyRequestsChart(state.data.requestsByMonth),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Recent Requests
                RecentRequestsCard(
                  requests: state.data.recentRequests,
                ),
              ],
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatisticsCards(DashboardData data) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        DashboardCard(
          title: 'إجمالي المستخدمين',
          value: data.totalUsers.toString(),
          icon: Icons.people_outline,
          color: AppTheme.techBlue,
          subtitle: '${data.activeUsers} نشط',
        ),
        DashboardCard(
          title: 'إجمالي الطلبات',
          value: data.totalRequests.toString(),
          icon: Icons.description_outlined,
          color: AppTheme.successGreen,
          subtitle: '${data.pendingRequests} قيد المراجعة',
        ),
        DashboardCard(
          title: 'الخدمات النشطة',
          value: data.activeServices.toString(),
          icon: Icons.miscellaneous_services_outlined,
          color: AppTheme.purplePrimary,
          subtitle: 'من ${data.totalServices} خدمة',
        ),
        DashboardCard(
          title: 'إجمالي الإيرادات',
          value: '${data.totalRevenue.toStringAsFixed(0)} ر.ي',
          icon: Icons.attach_money_outlined,
          color: AppTheme.warningYellow,
          subtitle: 'هذا الشهر',
        ),
      ],
    );
  }

  Widget _buildRequestStatusChart(Map<String, int> data) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد بيانات',
          style: TextStyle(
            color: AppTheme.gray500,
            fontFamily: 'NotoSansArabic',
          ),
        ),
      );
    }

    final sections = data.entries.map((entry) {
      Color color;
      switch (entry.key) {
        case 'completed':
          color = AppTheme.successGreen;
          break;
        case 'pending':
        case 'submitted':
        case 'under_review':
          color = AppTheme.warningYellow;
          break;
        case 'rejected':
          color = AppTheme.errorRed;
          break;
        default:
          color = AppTheme.gray400;
      }

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.value}',
        color: color,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.yemenWhite,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildMonthlyRequestsChart(Map<String, int> data) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد بيانات',
          style: TextStyle(
            color: AppTheme.gray500,
            fontFamily: 'NotoSansArabic',
          ),
        ),
      );
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final spots = sortedEntries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < sortedEntries.length) {
                  final monthKey = sortedEntries[value.toInt()].key;
                  final parts = monthKey.split('-');
                  return Text(
                    '${parts[1]}/${parts[0].substring(2)}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.yemenRed,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.yemenRed.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}