import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VoiceAssistantWidget extends StatefulWidget {
  final bool isListening;
  final Function() onToggleListening;
  final Function(String) onVoiceCommand;

  const VoiceAssistantWidget({
    super.key,
    required this.isListening,
    required this.onToggleListening,
    required this.onVoiceCommand,
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
    _initializeAnimations();
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

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildVoiceButton(colorScheme),
          SizedBox(height: 2.h),
          _buildStatusText(theme, colorScheme),
          SizedBox(height: 2.h),
          _buildQuickCommands(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildVoiceButton(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: widget.onToggleListening,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isListening ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: widget.isListening
                    ? colorScheme.tertiary
                    : colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (widget.isListening
                            ? colorScheme.tertiary
                            : colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: widget.isListening ? 20 : 8,
                    spreadRadius: widget.isListening ? 4 : 0,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.isListening) _buildWaveAnimation(colorScheme),
                  CustomIconWidget(
                    iconName: widget.isListening ? 'mic' : 'mic_none',
                    color: colorScheme.onPrimary,
                    size: 32,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaveAnimation(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.onPrimary.withValues(
                alpha: 0.3 * (1 - _waveAnimation.value),
              ),
              width: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusText(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          widget.isListening ? 'Listening...' : 'Tap to speak',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          widget.isListening
              ? 'Say your command now'
              : 'Voice commands available',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickCommands(ThemeData theme, ColorScheme colorScheme) {
    final commands = [
      'Show this week',
      'Schedule Python',
      'Next month',
      'Today\'s sessions',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Commands:',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: commands
              .map((command) => _buildCommandChip(
                    command,
                    theme,
                    colorScheme,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCommandChip(
    String command,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () => widget.onVoiceCommand(command),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          '"$command"',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
