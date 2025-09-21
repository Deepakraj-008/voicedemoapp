import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VoiceTryButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isListening;
  final bool isProcessing;

  const VoiceTryButton({
    super.key,
    required this.onPressed,
    this.isListening = false,
    this.isProcessing = false,
  });

  @override
  State<VoiceTryButton> createState() => _VoiceTryButtonState();
}

class _VoiceTryButtonState extends State<VoiceTryButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VoiceTryButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              width: 70.w,
              height: 8.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isListening
                      ? [
                          AppTheme.lightTheme.colorScheme.secondary,
                          AppTheme.lightTheme.colorScheme.primary,
                        ]
                      : [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.8),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: widget.isListening
                        ? AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.3)
                        : AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                    blurRadius: 20 * _pulseAnimation.value,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pulse effect overlay
                  if (widget.isListening)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(
                              alpha: (1.0 - (_pulseAnimation.value - 1.0) / 0.3)
                                  .clamp(0.0, 1.0),
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                  // Button content
                  Center(
                    child: widget.isProcessing
                        ? SizedBox(
                            width: 6.w,
                            height: 6.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: widget.isListening ? 'stop' : 'mic',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 6.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                widget.isListening
                                    ? 'Listening...'
                                    : 'Try saying "Hello Sweety"',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
