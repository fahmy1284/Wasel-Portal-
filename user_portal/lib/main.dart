import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common/core/theme/app_theme.dart';
import 'config/routes.dart';
import 'injection/dependency_injection.dart';
import 'features/splash/cubit/splash_cubit.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/services/cubit/services_cubit.dart';
import 'features/transactions/cubit/transactions_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await DependencyInjection.init();
  
  runApp(const UserPortalApp());
}

class UserPortalApp extends StatelessWidget {
  const UserPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashCubit>(
          create: (context) => DependencyInjection.get<SplashCubit>(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => DependencyInjection.get<AuthCubit>(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => DependencyInjection.get<HomeCubit>(),
        ),
        BlocProvider<ServicesCubit>(
          create: (context) => DependencyInjection.get<ServicesCubit>(),
        ),
        BlocProvider<TransactionsCubit>(
          create: (context) => DependencyInjection.get<TransactionsCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'واصل - بوابة المواطن',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        locale: const Locale('ar', 'YE'),
        routerConfig: AppRouter.router,
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