import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class VoiceActivationWidget extends StatefulWidget {
  const VoiceActivationWidget({
    super.key,
    this.onVoiceCommand,
    this.onLoginTriggered,
  });

  final Function(String)? onVoiceCommand;
  final VoidCallback? onLoginTriggered;

  @override
  State<VoiceActivationWidget> createState() => _VoiceActivationWidgetState();
}

class _VoiceActivationWidgetState extends State<VoiceActivationWidget>
    with TickerProviderStateMixin {
  bool _isListening = false;
  bool _isWakeWordDetected = false;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startWakeWordDetection();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startWakeWordDetection() async {
    try {
      bool hasPermission = await _requestMicrophonePermission();
      if (!hasPermission) return;

      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isListening = true;
        });

        _pulseController.repeat(reverse: true);

        // Simulate continuous listening for wake word
        _simulateWakeWordDetection();
      }
    } catch (e) {
      _showErrorMessage('Voice activation failed to start');
    }
  }

  void _simulateWakeWordDetection() {
    // Simulate wake word detection after random intervals
    Future.delayed(const Duration(seconds: 10), () {
      if (_isListening && mounted) {
        _onWakeWordDetected();
      }
    });
  }

  void _onWakeWordDetected() {
    setState(() {
      _isWakeWordDetected = true;
    });

    _pulseController.stop();
    _waveController.repeat(reverse: true);

    _showWakeWordDetectedMessage();

    // Start listening for voice command
    _startVoiceCommandListening();
  }

  Future<void> _startVoiceCommandListening() async {
    try {
      if (kIsWeb) {
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: 'voice_command.wav',
        );
      } else {
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: 'voice_command.m4a',
        );
      }

      // Listen for voice command for 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        _processVoiceCommand();
      });
    } catch (e) {
      _showErrorMessage('Failed to start voice command listening');
    }
  }

  Future<void> _processVoiceCommand() async {
    try {
      final path = await _audioRecorder.stop();

      if (path != null) {
        // Simulate voice command processing
        String command = _simulateVoiceCommandRecognition();

        widget.onVoiceCommand?.call(command);

        if (command.toLowerCase().contains('log me in') ||
            command.toLowerCase().contains('login')) {
          widget.onLoginTriggered?.call();
        }
      }
    } catch (e) {
      _showErrorMessage('Failed to process voice command');
    } finally {
      _resetVoiceActivation();
    }
  }

  String _simulateVoiceCommandRecognition() {
    final commands = [
      'Hello Sweety, log me in',
      'Hello Sweety, login please',
      'Hello Sweety, authenticate me',
      'Hello Sweety, sign me in',
    ];
    return commands[DateTime.now().millisecond % commands.length];
  }

  void _resetVoiceActivation() {
    setState(() {
      _isWakeWordDetected = false;
    });

    _waveController.stop();
    _waveController.reset();

    // Restart wake word detection
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _startWakeWordDetection();
      }
    });
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  void _showWakeWordDetectedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Hello! I\'m listening for your command...',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _isWakeWordDetected ? _waveAnimation : _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isWakeWordDetected
                    ? _waveAnimation.value
                    : _pulseAnimation.value,
                child: CustomIconWidget(
                  iconName: _isWakeWordDetected ? 'mic' : 'mic_none',
                  color: _isWakeWordDetected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 8.w,
                ),
              );
            },
          ),
          SizedBox(height: 2.h),
          Text(
            _isWakeWordDetected
                ? 'Listening for command...'
                : 'Say "Hello Sweety" to activate',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _isWakeWordDetected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (_isListening && !_isWakeWordDetected) ...[
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 1.w,
                        height: 3.h * (0.5 + 0.5 * _pulseAnimation.value),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}
