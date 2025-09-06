import 'package:flutter/material.dart';
import 'package:wasel_common/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _progressController;
  late Animation<double> _logoAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 1000));
    _progressController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.yemenGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Animation
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoAnimation.value,
                            child: Transform.rotate(
                              angle: (1 - _logoAnimation.value) * 2 * 3.14159,
                              child: Container(
                                width: 120,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: AppTheme.yemenWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    '🇾🇪',
                                    style: TextStyle(fontSize: 48),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // App Title
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: const Column(
                          children: [
                            Text(
                              'بوابة الإدارة الشاملة',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.yemenWhite,
                                fontFamily: 'NotoSansArabic',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'تطبيق واصل - الجمهورية اليمنية',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme.yemenWhite,
                                fontFamily: 'NotoSansArabic',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Subtitle
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: const Text(
                          'منصة إدارة الخدمات الحكومية الإلكترونية',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.yemenWhite,
                            fontFamily: 'NotoSansArabic',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Loading Section
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // Loading Text
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.yemenWhite,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'جاري التحميل...',
                          style: TextStyle(
                            color: AppTheme.yemenWhite,
                            fontSize: 16,
                            fontFamily: 'NotoSansArabic',
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Progress Bar
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppTheme.yemenWhite.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerRight,
                                widthFactor: _progressAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.yemenWhite,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(_progressAnimation.value * 100).toInt()}%',
                              style: const TextStyle(
                                color: AppTheme.yemenWhite,
                                fontSize: 12,
                                fontFamily: 'NotoSansArabic',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}