import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceAssistantWidget extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;

  const VoiceAssistantWidget({
    super.key,
    required this.isListening,
    required this.onTap,
  });

  @override
  State<VoiceAssistantWidget> createState() => _VoiceAssistantWidgetState();
}

class _VoiceAssistantWidgetState extends State<VoiceAssistantWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
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

    if (widget.isListening) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(VoiceAssistantWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _waveController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _pulseController.stop();
    _waveController.stop();
    _pulseController.reset();
    _waveController.reset();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.h,
      right: 4.w,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isListening ? _pulseAnimation.value : 1.0,
              child: Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.3),
                      blurRadius: widget.isListening ? 20 : 8,
                      spreadRadius: widget.isListening ? 4 : 2,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.isListening)
                      AnimatedBuilder(
                        animation: _waveAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 14.w * (1 + _waveAnimation.value * 0.5),
                            height: 14.w * (1 + _waveAnimation.value * 0.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.tertiary
                                    .withValues(
                                        alpha:
                                            0.3 * (1 - _waveAnimation.value)),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    CustomIconWidget(
                      iconName: widget.isListening ? 'mic' : 'mic_none',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
