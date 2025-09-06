import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wasel_common/services/supabase_service.dart';
import 'package:wasel_common/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final User? user;

  const AuthUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseService _supabaseService = SupabaseService.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);

    // Listen to auth state changes
    _supabaseService.authStateChanges.listen((AuthState authState) {
      add(AuthUserUpdated(authState.session?.user));
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = _supabaseService.currentUser;
      if (user != null) {
        final userProfile = await _supabaseService.getUserProfile(user.id);
        if (userProfile != null) {
          final userModel = UserModel.fromJson(userProfile);
          
          // Check if user has admin privileges
          if (userModel.isAdmin || userModel.isEmployee) {
            emit(AuthAuthenticated(userModel));
          } else {
            emit(const AuthError('ليس لديك صلاحية للوصول لبوابة الإدارة'));
          }
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('خطأ في التحقق من المصادقة: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final response = await _supabaseService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        final userProfile = await _supabaseService.getUserProfile(response.user!.id);
        if (userProfile != null) {
          final userModel = UserModel.fromJson(userProfile);
          
          // Check if user has admin privileges
          if (userModel.isAdmin || userModel.isEmployee) {
            // Update last login
            await _supabaseService.updateUserProfile(
              userModel.id,
              {'last_login_at': DateTime.now().toIso8601String()},
            );
            
            emit(AuthAuthenticated(userModel));
          } else {
            await _supabaseService.signOut();
            emit(const AuthError('ليس لديك صلاحية للوصول لبوابة الإدارة'));
          }
        } else {
          emit(const AuthError('لم يتم العثور على بيانات المستخدم'));
        }
      } else {
        emit(const AuthError('فشل في تسجيل الدخول'));
      }
    } on AuthException catch (e) {
      String errorMessage;
      switch (e.message) {
        case 'Invalid login credentials':
          errorMessage = 'بيانات الدخول غير صحيحة';
          break;
        case 'Email not confirmed':
          errorMessage = 'يرجى تأكيد البريد الإلكتروني أولاً';
          break;
        case 'Too many requests':
          errorMessage = 'محاولات كثيرة، يرجى المحاولة لاحقاً';
          break;
        default:
          errorMessage = 'خطأ في تسجيل الدخول: ${e.message}';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('خطأ غير متوقع: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _supabaseService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('خطأ في تسجيل الخروج: ${e.toString()}'));
    }
  }

  Future<void> _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      try {
        final userProfile = await _supabaseService.getUserProfile(event.user!.id);
        if (userProfile != null) {
          final userModel = UserModel.fromJson(userProfile);
          
          // Check if user has admin privileges
          if (userModel.isAdmin || userModel.isEmployee) {
            emit(AuthAuthenticated(userModel));
          } else {
            emit(const AuthError('ليس لديك صلاحية للوصول لبوابة الإدارة'));
          }
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }
}