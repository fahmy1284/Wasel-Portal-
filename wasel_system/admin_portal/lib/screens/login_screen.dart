import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_common/theme/app_theme.dart';
import 'package:wasel_common/widgets/custom_button.dart';
import 'package:wasel_common/widgets/custom_text_field.dart';
import '../blocs/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
                            _buildHeader(),
                            
                            const SizedBox(height: 32),
                            
                            // Login Form
                            _buildLoginForm(),
                            
                            const SizedBox(height: 24),
                            
                            // Login Button
                            _buildLoginButton(),
                            
                            const SizedBox(height: 16),
                            
                            // Footer
                            _buildFooter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppTheme.yemenGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              '🇾🇪',
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Title
        const Text(
          'بوابة الإدارة',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
            fontFamily: 'NotoSansArabic',
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtitle
        const Text(
          'تسجيل الدخول للوحة التحكم',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray600,
            fontFamily: 'NotoSansArabic',
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          CustomTextField(
            label: 'البريد الإلكتروني',
            hint: 'أدخل البريد الإلكتروني',
            type: TextFieldType.email,
            controller: _emailController,
            isRequired: true,
            validator: TextFieldValidators.combine([
              TextFieldValidators.required,
              TextFieldValidators.email,
            ]),
          ),
          
          const SizedBox(height: 16),
          
          // Password Field
          CustomTextField(
            label: 'كلمة المرور',
            hint: 'أدخل كلمة المرور',
            type: TextFieldType.password,
            controller: _passwordController,
            isRequired: true,
            validator: TextFieldValidators.required,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return CustomButton(
          text: 'تسجيل الدخول',
          onPressed: state is AuthLoading ? null : _handleLogin,
          isLoading: state is AuthLoading,
          isFullWidth: true,
          size: ButtonSize.large,
          icon: Icons.login,
        );
      },
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.gray300,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'أو',
                style: TextStyle(
                  color: AppTheme.gray500,
                  fontFamily: 'NotoSansArabic',
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.gray300,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Help Text
        const Text(
          'للحصول على المساعدة، تواصل مع مدير النظام',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.gray500,
            fontFamily: 'NotoSansArabic',
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Contact Info
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              size: 16,
              color: AppTheme.gray500,
            ),
            const SizedBox(width: 4),
            const Text(
              'support@wasel.gov.ye',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.techBlue,
                fontFamily: 'NotoSansArabic',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Version Info
        const Text(
          'الإصدار 1.0.0',
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.gray400,
            fontFamily: 'NotoSansArabic',
          ),
        ),
      ],
    );
  }
}