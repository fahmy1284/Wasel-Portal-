import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common/core/theme/app_theme.dart';
import 'config/routes.dart';
import 'injection/dependency_injection.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/dashboard/cubit/dashboard_cubit.dart';
import 'features/transactions/cubit/transactions_cubit.dart';
import 'features/users/cubit/users_cubit.dart';
import 'features/services/cubit/services_cubit.dart';
import 'features/reports/cubit/reports_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await DependencyInjection.init();
  
  runApp(const AdminPortalApp());
}

class AdminPortalApp extends StatelessWidget {
  const AdminPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => DependencyInjection.get<AuthCubit>(),
        ),
        BlocProvider<DashboardCubit>(
          create: (context) => DependencyInjection.get<DashboardCubit>(),
        ),
        BlocProvider<TransactionsCubit>(
          create: (context) => DependencyInjection.get<TransactionsCubit>(),
        ),
        BlocProvider<UsersCubit>(
          create: (context) => DependencyInjection.get<UsersCubit>(),
        ),
        BlocProvider<ServicesCubit>(
          create: (context) => DependencyInjection.get<ServicesCubit>(),
        ),
        BlocProvider<ReportsCubit>(
          create: (context) => DependencyInjection.get<ReportsCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'واصل - بوابة الإدارة',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        locale: const Locale('ar', 'YE'),
        routerConfig: AdminRouter.router,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
      ),
    );
  }
}