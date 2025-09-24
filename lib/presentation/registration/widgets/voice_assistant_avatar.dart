import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VoiceAssistantAvatar extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;

  const VoiceAssistantAvatar({
    super.key,
    required this.isListening,
    required this.onTap,
  });

  @override
  State<VoiceAssistantAvatar> createState() => _VoiceAssistantAvatarState();
}

class _VoiceAssistantAvatarState extends State<VoiceAssistantAvatar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceAssistantAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.h,
      right: 4.w,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isListening ? _pulseAnimation.value : 1.0,
              child: CustomIconWidget(
                iconName: widget.isListening ? 'mic' : 'assistant',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 8.w,
              ),
            );
          },
        ),
      ),
    );
  }
}
