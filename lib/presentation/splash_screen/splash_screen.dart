import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import './widgets/animated_logo_widget.dart';
import './widgets/loading_progress_widget.dart';
import './widgets/permission_modal_widget.dart';
import './widgets/voice_waveform_widget.dart';

/// Splash Screen for VoiceLearn AI
/// Provides branded app launch experience while initializing AI voice services
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  double _loadingProgress = 0.0;
  String _statusText = 'Initializing VoiceLearn AI...';
  bool _showPermissionModal = false;
  bool _isInitializing = true;
  Timer? _progressTimer;
  Timer? _navigationTimer;

  // Mock initialization states
  final List<Map<String, dynamic>> _initializationSteps = [
    {'text': 'Initializing VoiceLearn AI...', 'duration': 500},
    {'text': 'Loading voice models...', 'duration': 800},
    {'text': 'Checking microphone permissions...', 'duration': 600},
    {'text': 'Preparing AI assistant...', 'duration': 700},
    {'text': 'Validating authentication...', 'duration': 500},
    {'text': 'Ready to learn!', 'duration': 300},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  void _startInitialization() {
    _simulateInitializationProgress();
  }

  void _simulateInitializationProgress() {
    int currentStep = 0;
    double progressPerStep = 1.0 / _initializationSteps.length;

    void processNextStep() {
      if (currentStep < _initializationSteps.length) {
        final step = _initializationSteps[currentStep];

        setState(() {
          _statusText = step['text'] as String;
          _loadingProgress = (currentStep + 1) * progressPerStep;
        });

        // Special handling for microphone permission step
        if (currentStep == 2) {
          _checkMicrophonePermission().then((hasPermission) {
            if (!hasPermission) {
              setState(() {
                _showPermissionModal = true;
                _isInitializing = false;
              });
              return;
            }

            // Continue with next step if permission granted
            Timer(Duration(milliseconds: step['duration'] as int), () {
              currentStep++;
              processNextStep();
            });
          });
        } else {
          Timer(Duration(milliseconds: step['duration'] as int), () {
            currentStep++;
            processNextStep();
          });
        }
      } else {
        // Initialization complete
        setState(() {
          _isInitializing = false;
        });
        _navigateToNextScreen();
      }
    }

    processNextStep();
  }

  Future<bool> _checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      setState(() {
        _showPermissionModal = false;
        _isInitializing = true;
      });

      // Continue initialization from step 3
      Timer(const Duration(milliseconds: 300), () {
        _continueInitializationFromStep(3);
      });
    } else {
      // Permission denied, show modal again or continue without voice
      setState(() {
        _showPermissionModal = true;
      });
    }
  }

  void _continueInitializationFromStep(int startStep) {
    int currentStep = startStep;
    double progressPerStep = 1.0 / _initializationSteps.length;

    void processNextStep() {
      if (currentStep < _initializationSteps.length) {
        final step = _initializationSteps[currentStep];

        setState(() {
          _statusText = step['text'] as String;
          _loadingProgress = (currentStep + 1) * progressPerStep;
        });

        Timer(Duration(milliseconds: step['duration'] as int), () {
          currentStep++;
          processNextStep();
        });
      } else {
        setState(() {
          _isInitializing = false;
        });
        _navigateToNextScreen();
      }
    }

    processNextStep();
  }

  void _skipVoicePermission() {
    setState(() {
      _showPermissionModal = false;
      _isInitializing = true;
      _statusText = 'Continuing without voice features...';
    });

    Timer(const Duration(milliseconds: 500), () {
      _continueInitializationFromStep(3);
    });
  }

  void _navigateToNextScreen() {
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        // Mock authentication check
        final isAuthenticated = _checkAuthenticationStatus();

        if (isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/voice-dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/registration');
        }
      }
    });
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check - in real app, check stored tokens
    return false; // Always show registration for demo
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _progressTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E293B), // Dark blue
                  Color(0xFF3B82F6), // Light blue
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),

          // Safe area content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Top spacer
                  SizedBox(height: 15.h),

                  // App logo with animation
                  const AnimatedLogoWidget(
                    size: 120.0,
                    primaryColor: Colors.white,
                    secondaryColor: Color(0xFF3B82F6),
                  ),

                  SizedBox(height: 3.h),

                  // App name
                  Text(
                    'VoiceLearn AI',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Tagline
                  Text(
                    'Your AI-Powered Learning Companion',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 0.5,
                    ),
                  ),

                  // Flexible spacer
                  const Spacer(),

                  // Voice waveform visualization
                  VoiceWaveformWidget(
                    isAnimating: _isInitializing,
                    color: Colors.white,
                    height: 60.0,
                    width: 70.w,
                  ),

                  SizedBox(height: 4.h),

                  // Loading progress
                  LoadingProgressWidget(
                    progress: _loadingProgress,
                    statusText: _statusText,
                    showProgress: _isInitializing,
                    progressColor: Colors.white,
                  ),

                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),

          // Permission modal overlay
          _showPermissionModal
              ? PermissionModalWidget(
                  onRetry: _requestMicrophonePermission,
                  onSkip: _skipVoicePermission,
                  title: 'Microphone Permission Required',
                  description:
                      'VoiceLearn AI needs microphone access to provide voice-controlled learning experiences. Please grant permission to continue.',
                  retryButtonText: 'Grant Permission',
                  skipButtonText: 'Continue Without Voice',
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
