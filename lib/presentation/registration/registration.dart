import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/create_account_button.dart';
import './widgets/password_strength_indicator.dart';
import './widgets/success_animation.dart';
import './widgets/terms_privacy_links.dart';
import './widgets/voice_assistant_avatar.dart';
import './widgets/voice_input_field.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isListening = false;
  bool _isLoading = false;
  bool _showSuccess = false;
  String _currentListeningField = '';

  // Mock user data for partial form saving
  final Map<String, String> _savedFormData = {};

  @override
  void initState() {
    super.initState();
    _loadSavedFormData();
    _requestMicrophonePermission();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      _showVoiceFeedback('Microphone permission is required for voice input');
    }
  }

  void _loadSavedFormData() {
    // Simulate loading saved form data
    if (_savedFormData.isNotEmpty) {
      _emailController.text = _savedFormData['email'] ?? '';
      _displayNameController.text = _savedFormData['displayName'] ?? '';
      _showVoiceFeedback(
          'Welcome back! Would you like to resume completing your registration?');
    }
  }

  void _saveFormData() {
    _savedFormData['email'] = _emailController.text;
    _savedFormData['displayName'] = _displayNameController.text;
    // Don't save passwords for security
  }

  Future<void> _toggleVoiceInput(String fieldName) async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening(fieldName);
    }
  }

  Future<void> _startListening(String fieldName) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isListening = true;
          _currentListeningField = fieldName;
        });

        _showVoiceFeedback('Listening for $fieldName. Please speak now.');

        await _audioRecorder.start(const RecordConfig(),
            path: 'temp_recording.m4a');

        // Simulate voice recognition after 3 seconds
        await Future.delayed(const Duration(seconds: 3));
        await _stopListening();

        // Mock voice input results
        final mockVoiceResults = {
          'email': 'john.doe@example.com',
          'password': 'SecurePass123!',
          'confirmPassword': 'SecurePass123!',
          'displayName': 'John Doe',
        };

        final result = mockVoiceResults[fieldName] ?? '';
        if (result.isNotEmpty) {
          _handleVoiceInput(fieldName, result);
        }
      }
    } catch (e) {
      _showVoiceFeedback('Voice input failed. Please try typing instead.');
      setState(() {
        _isListening = false;
        _currentListeningField = '';
      });
    }
  }

  Future<void> _stopListening() async {
    try {
      await _audioRecorder.stop();
      setState(() {
        _isListening = false;
        _currentListeningField = '';
      });
    } catch (e) {
      // Handle error silently
    }
  }

  void _handleVoiceInput(String fieldName, String input) {
    switch (fieldName) {
      case 'email':
        _emailController.text = input;
        _showVoiceFeedback('Is $input correct?');
        break;
      case 'password':
        _passwordController.text = input;
        _showVoiceFeedback('Password entered. Please confirm your password.');
        break;
      case 'confirmPassword':
        _confirmPasswordController.text = input;
        _showVoiceFeedback('Password confirmation entered.');
        break;
      case 'displayName':
        _displayNameController.text = input;
        _showVoiceFeedback('Display name set to $input');
        break;
    }
    setState(() {});
  }

  void _showVoiceFeedback(String message) {
    // In a real app, this would use text-to-speech
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleVoiceCommand(String command) {
    switch (command.toLowerCase()) {
      case 'go back':
        Navigator.pop(context);
        break;
      case 'clear form':
        _clearForm();
        break;
      case 'create account':
        if (_isFormValid()) {
          _createAccount();
        }
        break;
    }
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _displayNameController.clear();
    _savedFormData.clear();
    _showVoiceFeedback('Form cleared');
    setState(() {});
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }
    if (value.length < 2) {
      return 'Display name must be at least 2 characters';
    }
    return null;
  }

  Future<void> _createAccount() async {
    if (!_isFormValid()) {
      _showVoiceFeedback('Please fix the errors in the form');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate account creation
      await Future.delayed(const Duration(seconds: 2));

      // Clear saved form data on success
      _savedFormData.clear();

      setState(() {
        _isLoading = false;
        _showSuccess = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showVoiceFeedback('Account creation failed. Please try again.');
    }
  }

  void _onSuccessComplete() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/voice-dashboard',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _showSuccess
          ? SuccessAnimation(
              onComplete: _onSuccessComplete,
              onVoiceFeedback: _showVoiceFeedback,
            )
          : Stack(
              children: [
                // Background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.05),
                        AppTheme.lightTheme.scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),

                // Main content
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),

                          // Header
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.lightTheme.colorScheme.primary,
                                        AppTheme
                                            .lightTheme.colorScheme.tertiary,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'school',
                                      color: Colors.white,
                                      size: 10.w,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'Join VoiceLearn AI',
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Create your account and start your AI-powered learning journey',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 6.h),

                          // Form fields
                          VoiceInputField(
                            label: 'Display Name',
                            hint: 'Enter your full name',
                            controller: _displayNameController,
                            validator: _validateDisplayName,
                            onVoiceInput: (input) =>
                                _handleVoiceInput('displayName', input),
                            isListening: _isListening &&
                                _currentListeningField == 'displayName',
                            onVoiceToggle: () =>
                                _toggleVoiceInput('displayName'),
                          ),

                          SizedBox(height: 3.h),

                          VoiceInputField(
                            label: 'Email Address',
                            hint: 'Enter your email address',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            onVoiceInput: (input) =>
                                _handleVoiceInput('email', input),
                            isListening: _isListening &&
                                _currentListeningField == 'email',
                            onVoiceToggle: () => _toggleVoiceInput('email'),
                          ),

                          SizedBox(height: 3.h),

                          VoiceInputField(
                            label: 'Password',
                            hint: 'Create a strong password',
                            controller: _passwordController,
                            isPassword: true,
                            validator: _validatePassword,
                            onVoiceInput: (input) =>
                                _handleVoiceInput('password', input),
                            isListening: _isListening &&
                                _currentListeningField == 'password',
                            onVoiceToggle: () => _toggleVoiceInput('password'),
                          ),

                          // Password strength indicator
                          PasswordStrengthIndicator(
                            password: _passwordController.text,
                            onVoiceFeedback: _showVoiceFeedback,
                          ),

                          SizedBox(height: 3.h),

                          VoiceInputField(
                            label: 'Confirm Password',
                            hint: 'Re-enter your password',
                            controller: _confirmPasswordController,
                            isPassword: true,
                            isConfirmPassword: true,
                            validator: _validateConfirmPassword,
                            onVoiceInput: (input) =>
                                _handleVoiceInput('confirmPassword', input),
                            isListening: _isListening &&
                                _currentListeningField == 'confirmPassword',
                            onVoiceToggle: () =>
                                _toggleVoiceInput('confirmPassword'),
                          ),

                          SizedBox(height: 4.h),

                          // Terms and Privacy
                          TermsPrivacyLinks(
                            onVoiceFeedback: _showVoiceFeedback,
                          ),

                          SizedBox(height: 4.h),

                          // Create Account Button
                          CreateAccountButton(
                            isEnabled: _isFormValid(),
                            isLoading: _isLoading,
                            onPressed: _createAccount,
                            onVoiceFeedback: _showVoiceFeedback,
                          ),

                          SizedBox(height: 3.h),

                          // Sign in link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _saveFormData();
                                    Navigator.pushNamed(
                                        context, '/splash-screen');
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ),
                ),

                // Voice Assistant Avatar
                VoiceAssistantAvatar(
                  isListening: _isListening,
                  onTap: () {
                    if (_isListening) {
                      _stopListening();
                    } else {
                      _showVoiceFeedback(
                          'Voice assistant ready. Say "create account", "go back", or "clear form"');
                    }
                  },
                ),
              ],
            ),
    );
  }
}
