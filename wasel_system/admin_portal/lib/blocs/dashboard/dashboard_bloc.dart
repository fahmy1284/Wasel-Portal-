import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wasel_common/services/supabase_service.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardDataRequested extends DashboardEvent {}

class DashboardRefreshRequested extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardData data;

  const DashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// Data Model
class DashboardData extends Equatable {
  final int totalUsers;
  final int totalCitizens;
  final int totalStaff;
  final int activeUsers;
  final int totalRequests;
  final int pendingRequests;
  final int completedRequests;
  final int rejectedRequests;
  final int totalServices;
  final int activeServices;
  final double totalRevenue;
  final List<Map<String, dynamic>> recentRequests;
  final List<Map<String, dynamic>> popularServices;
  final Map<String, int> requestsByStatus;
  final Map<String, int> requestsByMonth;

  const DashboardData({
    required this.totalUsers,
    required this.totalCitizens,
    required this.totalStaff,
    required this.activeUsers,
    required this.totalRequests,
    required this.pendingRequests,
    required this.completedRequests,
    required this.rejectedRequests,
    required this.totalServices,
    required this.activeServices,
    required this.totalRevenue,
    required this.recentRequests,
    required this.popularServices,
    required this.requestsByStatus,
    required this.requestsByMonth,
  });

  @override
  List<Object?> get props => [
        totalUsers,
        totalCitizens,
        totalStaff,
        activeUsers,
        totalRequests,
        pendingRequests,
        completedRequests,
        rejectedRequests,
        totalServices,
        activeServices,
        totalRevenue,
        recentRequests,
        popularServices,
        requestsByStatus,
        requestsByMonth,
      ];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SupabaseService _supabaseService = SupabaseService.instance;

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardDataRequested>(_onDashboardDataRequested);
    on<DashboardRefreshRequested>(_onDashboardRefreshRequested);
  }

  Future<void> _onDashboardDataRequested(
    DashboardDataRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    await _loadDashboardData(emit);
  }

  Future<void> _onDashboardRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboardData(emit);
  }

  Future<void> _loadDashboardData(Emitter<DashboardState> emit) async {
    try {
      // Get user statistics
      final userStats = await _getUserStatistics();
      
      // Get request statistics
      final requestStats = await _getRequestStatistics();
      
      // Get service statistics
      final serviceStats = await _getServiceStatistics();
      
      // Get recent requests
      final recentRequests = await _getRecentRequests();
      
      // Get popular services
      final popularServices = await _getPopularServices();
      
      // Get requests by status
      final requestsByStatus = await _getRequestsByStatus();
      
      // Get requests by month
      final requestsByMonth = await _getRequestsByMonth();
      
      // Calculate total revenue
      final totalRevenue = await _getTotalRevenue();

      final dashboardData = DashboardData(
        totalUsers: userStats['total_users'] ?? 0,
        totalCitizens: userStats['citizens'] ?? 0,
        totalStaff: userStats['staff'] ?? 0,
        activeUsers: userStats['active_users'] ?? 0,
        totalRequests: requestStats['total_requests'] ?? 0,
        pendingRequests: requestStats['pending_requests'] ?? 0,
        completedRequests: requestStats['completed_requests'] ?? 0,
        rejectedRequests: requestStats['rejected_requests'] ?? 0,
        totalServices: serviceStats['total_services'] ?? 0,
        activeServices: serviceStats['active_services'] ?? 0,
        totalRevenue: totalRevenue,
        recentRequests: recentRequests,
        popularServices: popularServices,
        requestsByStatus: requestsByStatus,
        requestsByMonth: requestsByMonth,
      );

      emit(DashboardLoaded(dashboardData));
    } catch (e) {
      emit(DashboardError('خطأ في تحميل بيانات لوحة التحكم: ${e.toString()}'));
    }
  }

  Future<Map<String, dynamic>> _getUserStatistics() async {
    try {
      final result = await _supabaseService.rpc('get_user_statistics');
      return result ?? {};
    } catch (e) {
      // Fallback to manual calculation
      final users = await _supabaseService.select('users');
      
      int totalUsers = users.length;
      int citizens = users.where((u) => u['role'] == 'citizen').length;
      int staff = users.where((u) => ['admin', 'ministry_admin', 'department_admin', 'employee'].contains(u['role'])).length;
      int activeUsers = users.where((u) => u['is_active'] == true).length;
      
      return {
        'total_users': totalUsers,
        'citizens': citizens,
        'staff': staff,
        'active_users': activeUsers,
      };
    }
  }

  Future<Map<String, dynamic>> _getRequestStatistics() async {
    try {
      final requests = await _supabaseService.select('service_requests');
      
      int totalRequests = requests.length;
      int pendingRequests = requests.where((r) => ['submitted', 'under_review'].contains(r['status'])).length;
      int completedRequests = requests.where((r) => r['status'] == 'completed').length;
      int rejectedRequests = requests.where((r) => r['status'] == 'rejected').length;
      
      return {
        'total_requests': totalRequests,
        'pending_requests': pendingRequests,
        'completed_requests': completedRequests,
        'rejected_requests': rejectedRequests,
      };
    } catch (e) {
      return {
        'total_requests': 0,
        'pending_requests': 0,
        'completed_requests': 0,
        'rejected_requests': 0,
      };
    }
  }

  Future<Map<String, dynamic>> _getServiceStatistics() async {
    try {
      final services = await _supabaseService.select('services');
      
      int totalServices = services.length;
      int activeServices = services.where((s) => s['status'] == 'active').length;
      
      return {
        'total_services': totalServices,
        'active_services': activeServices,
      };
    } catch (e) {
      return {
        'total_services': 0,
        'active_services': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> _getRecentRequests() async {
    try {
      return await _supabaseService.select(
        'service_requests',
        orderBy: 'created_at',
        ascending: false,
        limit: 10,
      );
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getPopularServices() async {
    try {
      // This would be better implemented with a proper SQL query
      final requests = await _supabaseService.select('service_requests');
      final services = await _supabaseService.select('services');
      
      // Count requests per service
      Map<String, int> serviceCounts = {};
      for (var request in requests) {
        String serviceId = request['service_id'];
        serviceCounts[serviceId] = (serviceCounts[serviceId] ?? 0) + 1;
      }
      
      // Get top 5 services
      var sortedServices = serviceCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      List<Map<String, dynamic>> popularServices = [];
      for (var entry in sortedServices.take(5)) {
        var service = services.firstWhere(
          (s) => s['id'] == entry.key,
          orElse: () => null,
        );
        if (service != null) {
          popularServices.add({
            ...service,
            'request_count': entry.value,
          });
        }
      }
      
      return popularServices;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, int>> _getRequestsByStatus() async {
    try {
      final requests = await _supabaseService.select('service_requests');
      
      Map<String, int> statusCounts = {};
      for (var request in requests) {
        String status = request['status'];
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }
      
      return statusCounts;
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, int>> _getRequestsByMonth() async {
    try {
      final requests = await _supabaseService.select('service_requests');
      
      Map<String, int> monthCounts = {};
      for (var request in requests) {
        if (request['created_at'] != null) {
          DateTime createdAt = DateTime.parse(request['created_at']);
          String monthKey = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}';
          monthCounts[monthKey] = (monthCounts[monthKey] ?? 0) + 1;
        }
      }
      
      return monthCounts;
    } catch (e) {
      return {};
    }
  }

  Future<double> _getTotalRevenue() async {
    try {
      final payments = await _supabaseService.select(
        'payments',
        filters: {'status': 'completed'},
      );
      
      double total = 0.0;
      for (var payment in payments) {
        total += (payment['amount'] ?? 0.0).toDouble();
      }
      
      return total;
    } catch (e) {
      return 0.0;
    }
  }
}