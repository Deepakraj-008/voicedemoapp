import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sweetyai_learning_assistant/presentation/home_dashboard/home_dashboard.dart'
    show HomeDashboard;
import 'package:sweetyai_learning_assistant/presentation/voice_dashboard/voice_dashboard.dart'
    show VoiceDashboard;

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/biometric_login_button.dart';
import './widgets/social_login_buttons.dart';
import './widgets/voice_activation_widget.dart';
import './widgets/voice_input_field.dart';
import 'widgets/biometric_login_button.dart';
import 'widgets/social_login_buttons.dart';
import 'widgets/voice_activation_widget.dart';
import 'widgets/voice_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  // Mock credentials for demonstration
  final String _mockEmail = 'admin@sweetyai.com';
  final String _mockPassword = 'admin123';
  final String _mockUserEmail = 'user@sweetyai.com';
  final String _mockUserPassword = 'user123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Check mock credentials
    if ((email == _mockEmail && password == _mockPassword) ||
        (email == _mockUserEmail && password == _mockUserPassword)) {
      _showSuccessMessage();
      HapticFeedback.lightImpact();

      // Navigate to voice dashboard
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VoiceDashboard()),
        );
      });
    } else {
      _showErrorMessage(
          'Invalid credentials. Try admin@sweetyai.com/admin123 or user@sweetyai.com/user123');
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleVoiceLogin() {
    // Simulate voice-guided login
    _showVoiceLoginMessage();

    // Auto-fill with mock credentials for demonstration
    Future.delayed(const Duration(seconds: 1), () {
      _emailController.text = _mockEmail;
      _passwordController.text = _mockPassword;

      // Trigger login after voice input
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleLogin();
      });
    });
  }

  void _handleForgotPassword() {
    _showInfoMessage('Password reset link would be sent to your email');
  }

  void _handleSignUp() {
    _showInfoMessage('Sign up functionality would be implemented here');
  }

  void _handleVoiceCommand(String command) {
    if (command.toLowerCase().contains('reset password') ||
        command.toLowerCase().contains('forgot password')) {
      _handleForgotPassword();
    } else if (command.toLowerCase().contains('sign up') ||
        command.toLowerCase().contains('register')) {
      _handleSignUp();
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome to SweetyAI! Login successful',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontSize: 14),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontSize: 14),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showVoiceLoginMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Voice login activated! Authenticating...',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8.h),

                // Sweety Logo
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'S',
                      style: GoogleFonts.inter(
                        fontSize: 12.w,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  'SweetyAI',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),

                SizedBox(height: 1.h),

                Text(
                  'Your AI Learning Assistant',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                SizedBox(height: 6.h),

                // Voice Activation Widget
                VoiceActivationWidget(
                  onVoiceCommand: _handleVoiceCommand,
                  onLoginTriggered: _handleVoiceLogin,
                ),

                SizedBox(height: 4.h),

                // Email Field
                VoiceInputField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  iconName: 'email',
                  keyboardType: TextInputType.emailAddress,
                ),

                // Password Field
                VoiceInputField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  iconName: 'lock',
                  isPassword: true,
                ),

                // Remember Me & Forgot Password
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: colorScheme.primary,
                    ),
                    Text(
                      'Remember me',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _handleForgotPassword,
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Login',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Biometric Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Or use biometric login',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    BiometricLoginButton(
                      onBiometricSuccess: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VoiceDashboard()),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Social Login
                SocialLoginButtons(),

                SizedBox(height: 4.h),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New user? ',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/registration');
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
