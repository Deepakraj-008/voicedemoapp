import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceAssistantFab extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isListening;

  const VoiceAssistantFab({
    super.key,
    this.onPressed,
    this.isListening = false,
  });

  @override
  State<VoiceAssistantFab> createState() => _VoiceAssistantFabState();
}

class _VoiceAssistantFabState extends State<VoiceAssistantFab>
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
      duration: const Duration(milliseconds: 2000),
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
  void didUpdateWidget(VoiceAssistantFab oldWidget) {
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
    _waveController.repeat();
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _waveAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer wave effect
            if (widget.isListening)
              Container(
                width: 20.w * (1 + _waveAnimation.value * 0.5),
                height: 20.w * (1 + _waveAnimation.value * 0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.tertiary.withValues(
                    alpha: 0.3 * (1 - _waveAnimation.value),
                  ),
                ),
              ),

            // Middle wave effect
            if (widget.isListening)
              Container(
                width: 16.w * (1 + _waveAnimation.value * 0.3),
                height: 16.w * (1 + _waveAnimation.value * 0.3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.tertiary.withValues(
                    alpha: 0.4 * (1 - _waveAnimation.value),
                  ),
                ),
              ),

            // Main FAB
            Transform.scale(
              scale: widget.isListening ? _pulseAnimation.value : 1.0,
              child: FloatingActionButton(
                onPressed: widget.onPressed,
                backgroundColor: widget.isListening
                    ? colorScheme.tertiary
                    : colorScheme.tertiary,
                foregroundColor: Colors.white,
                elevation: widget.isListening ? 8 : 6,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: widget.isListening
                      ? CustomIconWidget(
                          key: const ValueKey('listening'),
                          iconName: 'mic',
                          color: Colors.white,
                          size: 6.w,
                        )
                      : CustomIconWidget(
                          key: const ValueKey('idle'),
                          iconName: 'mic_none',
                          color: Colors.white,
                          size: 6.w,
                        ),
                ),
              ),
            ),

            // Voice activity indicator
            if (widget.isListening)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: AppTheme.successLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 1.5.w,
                      height: 1.5.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
