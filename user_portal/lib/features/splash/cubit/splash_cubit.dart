import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// States
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashCompleted extends SplashState {
  final bool isAuthenticated;

  const SplashCompleted({required this.isAuthenticated});

  @override
  List<Object?> get props => [isAuthenticated];
}

class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initialize() async {
    emit(SplashLoading());

    try {
      // Simulate initialization delay
      await Future.delayed(const Duration(seconds: 3));

      // Check authentication status
      // This would typically check stored tokens, etc.
      final isAuthenticated = false; // Replace with actual auth check

      emit(SplashCompleted(isAuthenticated: isAuthenticated));
    } catch (e) {
      emit(SplashError('خطأ في تحميل التطبيق: ${e.toString()}'));
    }
  }
}