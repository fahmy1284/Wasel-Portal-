import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_common/theme/app_theme.dart';
import 'package:wasel_common/services/supabase_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/dashboard/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  runApp(const AdminPortalApp());
}

class AdminPortalApp extends StatelessWidget {
  const AdminPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheckRequested()),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'بوابة الإدارة - واصل',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        locale: const Locale('ar', 'YE'),
        home: const AppWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const SplashScreen();
        } else if (state is AuthAuthenticated) {
          return const DashboardScreen();
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        } else if (state is AuthLoading) {
          return const SplashScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
}