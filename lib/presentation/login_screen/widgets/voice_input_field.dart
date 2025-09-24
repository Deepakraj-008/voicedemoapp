import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class VoiceInputField extends StatefulWidget {
  const VoiceInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconName,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onVoiceInput,
  });

  final TextEditingController controller;
  final String hintText;
  final String iconName;
  final bool isPassword;
  final TextInputType keyboardType;
  final Function(String)? onVoiceInput;

  @override
  State<VoiceInputField> createState() => _VoiceInputFieldState();
}

class _VoiceInputFieldState extends State<VoiceInputField>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _obscureText = true;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startVoiceInput() async {
    if (_isRecording) {
      await _stopVoiceInput();
      return;
    }

    try {
      bool hasPermission = await _requestMicrophonePermission();
      if (!hasPermission) {
        _showPermissionDeniedMessage();
        return;
      }

      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        _animationController.repeat(reverse: true);

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'voice_input.wav',
          );
        } else {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: 'voice_input.aac',
          );
        }

        // Simulate voice-to-text conversion after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (_isRecording) {
            _stopVoiceInput();
          }
        });
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _animationController.stop();
      _showErrorMessage('Voice input failed. Please try again.');
    }
  }

  Future<void> _stopVoiceInput() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
      });

      _animationController.stop();
      _animationController.reset();

      if (path != null) {
        // Simulate voice-to-text conversion
        String voiceText = _simulateVoiceToText();
        widget.controller.text = voiceText;
        widget.onVoiceInput?.call(voiceText);
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _animationController.stop();
      _showErrorMessage('Failed to process voice input.');
    }
  }

  String _simulateVoiceToText() {
    if (widget.keyboardType == TextInputType.emailAddress) {
      return 'user@example.com';
    } else if (widget.isPassword) {
      return 'password123';
    }
    return 'Voice input text';
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Microphone permission is required for voice input',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
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
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: widget.iconName,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          suffixIcon: Container(
            width: 80,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.isPassword)
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: _obscureText ? 'visibility' : 'visibility_off',
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isRecording ? _pulseAnimation.value : 1.0,
                      child: IconButton(
                        icon: CustomIconWidget(
                          iconName: _isRecording ? 'mic' : 'mic_none',
                          color: _isRecording
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: _startVoiceInput,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (widget.keyboardType == TextInputType.emailAddress) {
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }
          if (widget.isPassword && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }
}
