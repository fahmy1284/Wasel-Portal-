import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();
  
  SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      storageOptions: const StorageClientOptions(
        retryAttempts: 10,
      ),
    );
  }
  
  // Auth methods
  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;
  bool get isAuthenticated => currentUser != null;
  
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
  
  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }
  
  Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }
  
  Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.updateUser(
      UserAttributes(
        email: email,
        password: password,
        data: data,
      ),
    );
  }
  
  // Database methods
  SupabaseQueryBuilder from(String table) => client.from(table);
  
  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    var query = client.from(table).select(columns);
    
    if (filters != null) {
      filters.forEach((key, value) {
        if (value != null) {
          query = query.eq(key, value);
        }
      });
    }
    
    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    if (offset != null) {
      query = query.range(offset, offset + (limit ?? 20) - 1);
    }
    
    return await query;
  }
  
  Future<Map<String, dynamic>?> selectSingle(
    String table, {
    String columns = '*',
    required Map<String, dynamic> filters,
  }) async {
    var query = client.from(table).select(columns);
    
    filters.forEach((key, value) {
      if (value != null) {
        query = query.eq(key, value);
      }
    });
    
    return await query.maybeSingle();
  }
  
  Future<List<Map<String, dynamic>>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    return await client.from(table).insert(data).select();
  }
  
  Future<List<Map<String, dynamic>>> insertMany(
    String table,
    List<Map<String, dynamic>> data,
  ) async {
    return await client.from(table).insert(data).select();
  }
  
  Future<List<Map<String, dynamic>>> update(
    String table,
    Map<String, dynamic> data, {
    required Map<String, dynamic> filters,
  }) async {
    var query = client.from(table).update(data);
    
    filters.forEach((key, value) {
      if (value != null) {
        query = query.eq(key, value);
      }
    });
    
    return await query.select();
  }
  
  Future<void> delete(
    String table, {
    required Map<String, dynamic> filters,
  }) async {
    var query = client.from(table).delete();
    
    filters.forEach((key, value) {
      if (value != null) {
        query = query.eq(key, value);
      }
    });
    
    await query;
  }
  
  // Storage methods
  SupabaseStorageClient get storage => client.storage;
  
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required List<int> fileBytes,
    String? contentType,
  }) async {
    await storage.from(bucket).uploadBinary(
      path,
      fileBytes,
      fileOptions: FileOptions(
        contentType: contentType,
        upsert: true,
      ),
    );
    
    return storage.from(bucket).getPublicUrl(path);
  }
  
  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    await storage.from(bucket).remove([path]);
  }
  
  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return storage.from(bucket).getPublicUrl(path);
  }
  
  Future<List<int>> downloadFile({
    required String bucket,
    required String path,
  }) async {
    return await storage.from(bucket).download(path);
  }
  
  // Realtime methods
  RealtimeChannel channel(String name) => client.channel(name);
  
  RealtimeChannel subscribeToTable({
    required String table,
    String? filter,
    void Function(PostgresChangePayload)? onInsert,
    void Function(PostgresChangePayload)? onUpdate,
    void Function(PostgresChangePayload)? onDelete,
  }) {
    final channel = client.channel('public:$table');
    
    if (onInsert != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: table,
        filter: filter,
        callback: onInsert,
      );
    }
    
    if (onUpdate != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: table,
        filter: filter,
        callback: onUpdate,
      );
    }
    
    if (onDelete != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: table,
        filter: filter,
        callback: onDelete,
      );
    }
    
    channel.subscribe();
    return channel;
  }
  
  // RPC (Remote Procedure Call) methods
  Future<T> rpc<T>(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    return await client.rpc(functionName, params: params);
  }
  
  // Utility methods
  Future<bool> checkConnection() async {
    try {
      await client.from('system_settings').select('id').limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<Map<String, dynamic>?> getSystemSetting(String key) async {
    return await selectSingle(
      'system_settings',
      filters: {'key': key},
    );
  }
  
  Future<void> updateSystemSetting(String key, String value) async {
    await client.from('system_settings').upsert({
      'key': key,
      'value': value,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
  
  // User profile methods
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    return await selectSingle(
      'users',
      filters: {'id': userId},
    );
  }
  
  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await update(
      'users',
      {
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      },
      filters: {'id': userId},
    );
  }
  
  // Service methods
  Future<List<Map<String, dynamic>>> getServices({
    String? category,
    String? ministryId,
    bool activeOnly = true,
  }) async {
    final filters = <String, dynamic>{};
    
    if (category != null) filters['category'] = category;
    if (ministryId != null) filters['ministry_id'] = ministryId;
    if (activeOnly) filters['status'] = 'active';
    
    return await select(
      'services',
      filters: filters,
      orderBy: 'priority',
      ascending: false,
    );
  }
  
  // Service request methods
  Future<List<Map<String, dynamic>>> getUserRequests(String userId) async {
    return await select(
      'service_requests',
      filters: {'user_id': userId},
      orderBy: 'created_at',
      ascending: false,
    );
  }
  
  Future<Map<String, dynamic>> createServiceRequest({
    required String userId,
    required String serviceId,
    Map<String, dynamic>? formData,
  }) async {
    final result = await insert('service_requests', {
      'user_id': userId,
      'service_id': serviceId,
      'form_data': formData,
      'status': 'draft',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    
    return result.first;
  }
  
  Future<void> submitServiceRequest(String requestId) async {
    await update(
      'service_requests',
      {
        'status': 'submitted',
        'submitted_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      filters: {'id': requestId},
    );
  }
  
  // Notification methods
  Future<List<Map<String, dynamic>>> getUserNotifications(
    String userId, {
    bool unreadOnly = false,
  }) async {
    final filters = {'user_id': userId};
    if (unreadOnly) filters['is_read'] = false;
    
    return await select(
      'notifications',
      filters: filters,
      orderBy: 'created_at',
      ascending: false,
    );
  }
  
  Future<void> markNotificationAsRead(String notificationId) async {
    await update(
      'notifications',
      {'is_read': true},
      filters: {'id': notificationId},
    );
  }
  
  Future<void> markAllNotificationsAsRead(String userId) async {
    await update(
      'notifications',
      {'is_read': true},
      filters: {'user_id': userId, 'is_read': false},
    );
  }
  
  // Analytics methods
  Future<Map<String, dynamic>> getDashboardStats() async {
    final results = await Future.wait([
      rpc('get_user_statistics'),
      rpc('get_service_statistics'),
      select('service_requests_summary'),
    ]);
    
    return {
      'user_stats': results[0],
      'service_stats': results[1],
      'request_summary': results[2],
    };
  }
}