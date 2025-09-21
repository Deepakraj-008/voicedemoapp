import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/permission_request_card.dart';
import './widgets/voice_demo_card.dart';
import './widgets/voice_try_button.dart';
import './widgets/voice_waveform_widget.dart';

class VoiceOnboarding extends StatefulWidget {
  const VoiceOnboarding({super.key});

  @override
  State<VoiceOnboarding> createState() => _VoiceOnboardingState();
}

class _VoiceOnboardingState extends State<VoiceOnboarding>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final AudioRecorder _audioRecorder = AudioRecorder();

  int _currentPage = 0;
  bool _isListening = false;
  bool _isProcessing = false;
  bool _permissionGranted = false;
  bool _isLoading = false;
  double _voiceAmplitude = 0.5;

  final List<Map<String, dynamic>> _demoSteps = [
    {
      "title": "Voice Activation",
      "description": "Wake up your assistant with natural speech",
      "audioExample": "Hello Sweety, what's my schedule today?",
    },
    {
      "title": "Natural Conversation",
      "description": "Ask questions in your own words",
      "audioExample": "Sweety, help me understand calculus better",
    },
    {
      "title": "Hands-Free Learning",
      "description": "Study while walking, cooking, or exercising",
      "audioExample": "Start my Python programming lesson",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _checkMicrophonePermission();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _checkMicrophonePermission() async {
    if (kIsWeb) {
      setState(() => _permissionGranted = true);
      return;
    }

    final status = await Permission.microphone.status;
    setState(() => _permissionGranted = status.isGranted);
  }

  Future<void> _requestMicrophonePermission() async {
    setState(() => _isLoading = true);

    try {
      if (kIsWeb) {
        // Web handles permissions automatically
        setState(() {
          _permissionGranted = true;
          _isLoading = false;
        });
        _showSuccessAndNavigate();
        return;
      }

      final status = await Permission.microphone.request();

      setState(() {
        _permissionGranted = status.isGranted;
        _isLoading = false;
      });

      if (status.isGranted) {
        _showSuccessAndNavigate();
      } else {
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog();
    }
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Voice Assistant enabled successfully!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Permission Required',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Microphone access is needed for voice commands. You can enable it later in settings.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToSettings();
            },
            child: Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _skipToHome();
            },
            child: Text('Continue Without Voice'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Setup Error',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Unable to set up voice assistant. Please try again or continue without voice features.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _requestMicrophonePermission();
            },
            child: Text('Try Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _skipToHome();
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToSettings() async {
    await openAppSettings();
  }

  void _skipToHome() {
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  Future<void> _startVoiceDemo() async {
    if (!_permissionGranted) {
      await _requestMicrophonePermission();
      return;
    }

    setState(() {
      _isListening = true;
      _voiceAmplitude = 0.7;
    });

    try {
      if (await _audioRecorder.hasPermission()) {
        if (kIsWeb) {
          await _audioRecorder.start(
              const RecordConfig(encoder: AudioEncoder.wav),
              path: 'temp_recording.wav');
        } else {
          await _audioRecorder.start(const RecordConfig(),
              path: 'temp_recording');
        }

        // Simulate voice detection after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isListening) {
            _stopVoiceDemo(success: true);
          }
        });
      }
    } catch (e) {
      _stopVoiceDemo(success: false);
    }
  }

  Future<void> _stopVoiceDemo({bool success = false}) async {
    setState(() {
      _isListening = false;
      _isProcessing = success;
      _voiceAmplitude = 0.3;
    });

    try {
      await _audioRecorder.stop();
    } catch (e) {
      // Handle error silently
    }

    if (success) {
      // Simulate processing
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isProcessing = false);
          _showVoiceDetectedFeedback();
        }
      });
    }
  }

  void _showVoiceDetectedFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'hearing',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Great! Voice detected successfully',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _playAudioExample(int index) {
    // Simulate audio playback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Playing: "${_demoSteps[index]["audioExample"]}"',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header with skip button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 20.w), // Spacer for centering
                    Text(
                      'Voice Setup',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: _skipToHome,
                      child: Text(
                        'Skip',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),

                      // Voice illustration with waveform
                      Container(
                        width: double.infinity,
                        height: 25.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.colorScheme.primaryContainer
                                  .withValues(alpha: 0.3),
                              AppTheme.lightTheme.colorScheme.secondaryContainer
                                  .withValues(alpha: 0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            // Background pattern
                            Positioned.fill(
                              child: CustomPaint(
                                painter: BackgroundPatternPainter(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.05),
                                ),
                              ),
                            ),

                            // Waveform widget
                            Center(
                              child: VoiceWaveformWidget(
                                isListening: _isListening,
                                amplitude: _voiceAmplitude,
                              ),
                            ),

                            // Microphone icon overlay
                            if (!_isListening && !_isProcessing)
                              Center(
                                child: Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.surface
                                        .withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(10.w),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme
                                            .lightTheme.colorScheme.shadow
                                            .withValues(alpha: 0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'mic',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 10.w,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Main heading
                      Text(
                        'Meet Your AI Learning Assistant',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 2.h),

                      // Subtitle
                      Text(
                        'Experience hands-free learning with voice commands. Just speak naturally and let Sweety guide your educational journey.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 4.h),

                      // Voice try button
                      VoiceTryButton(
                        onPressed: _isListening
                            ? () => _stopVoiceDemo()
                            : _startVoiceDemo,
                        isListening: _isListening,
                        isProcessing: _isProcessing,
                      ),

                      SizedBox(height: 4.h),

                      // Demo steps
                      Text(
                        'How Voice Learning Works',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 2.h),

                      // Demo cards
                      ..._demoSteps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final step = entry.value;
                        return VoiceDemoCard(
                          title: step["title"] as String,
                          description: step["description"] as String,
                          audioExample: step["audioExample"] as String,
                          onPlay: () => _playAudioExample(index),
                          isPlaying: false,
                        );
                      }).toList(),

                      SizedBox(height: 4.h),

                      // Permission request card
                      PermissionRequestCard(
                        onEnablePressed: _requestMicrophonePermission,
                        onSkipPressed: _skipToHome,
                        isLoading: _isLoading,
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final spacing = size.width * 0.1;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
