import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FloatingControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final bool isVoiceActive;
  final double playbackSpeed;
  final VoidCallback onPlayPause;
  final VoidCallback onVoiceToggle;
  final Function(double) onSpeedChange;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onSettings;

  const FloatingControlsWidget({
    Key? key,
    required this.isPlaying,
    required this.isVoiceActive,
    required this.playbackSpeed,
    required this.onPlayPause,
    required this.onVoiceToggle,
    required this.onSpeedChange,
    this.onPrevious,
    this.onNext,
    required this.onSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous button
          IconButton(
            onPressed: onPrevious,
            icon: Icon(
              Icons.skip_previous,
              color: onPrevious != null
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.3),
              size: 6.w,
            ),
          ),

          // Play/Pause button
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onPlayPause,
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 7.w,
              ),
            ),
          ),

          // Next button
          IconButton(
            onPressed: onNext,
            icon: Icon(
              Icons.skip_next,
              color: onNext != null
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.3),
              size: 6.w,
            ),
          ),

          // Voice toggle button
          IconButton(
            onPressed: onVoiceToggle,
            icon: Icon(
              isVoiceActive ? Icons.mic : Icons.mic_off,
              color: isVoiceActive
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
              size: 6.w,
            ),
          ),

          // Speed control button
          PopupMenuButton<double>(
            initialValue: playbackSpeed,
            onSelected: onSpeedChange,
            itemBuilder: (context) => [
              PopupMenuItem(value: 0.5, child: Text('0.5x')),
              PopupMenuItem(value: 0.75, child: Text('0.75x')),
              PopupMenuItem(value: 1.0, child: Text('1.0x')),
              PopupMenuItem(value: 1.25, child: Text('1.25x')),
              PopupMenuItem(value: 1.5, child: Text('1.5x')),
              PopupMenuItem(value: 2.0, child: Text('2.0x')),
            ],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${playbackSpeed}x',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Settings button
          IconButton(
            onPressed: onSettings,
            icon: Icon(
              Icons.settings,
              color: AppTheme.lightTheme.colorScheme.onSurface.withOpacity(0.6),
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }
}
