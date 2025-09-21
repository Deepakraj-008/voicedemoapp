import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccessibilitySettingsWidget extends StatelessWidget {
  final Map<String, dynamic> accessibilitySettings;
  final Function(String, dynamic) onAccessibilitySettingChanged;

  const AccessibilitySettingsWidget({
    Key? key,
    required this.accessibilitySettings,
    required this.onAccessibilitySettingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'accessibility',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                "Accessibility",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildVoiceNavigationSettings(),
          SizedBox(height: 3.h),
          _buildVisualSettings(),
          SizedBox(height: 3.h),
          _buildInputSettings(),
        ],
      ),
    );
  }

  Widget _buildVoiceNavigationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Voice Navigation",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildAccessibilityToggle(
          "Voice-Only Navigation",
          "Navigate the app using only voice commands",
          "voiceOnlyNavigation",
          accessibilitySettings["voiceOnlyNavigation"] as bool,
          "record_voice_over",
        ),
        SizedBox(height: 2.h),
        _buildAccessibilityToggle(
          "Extended Voice Feedback",
          "Detailed voice descriptions of all interface elements",
          "extendedVoiceFeedback",
          accessibilitySettings["extendedVoiceFeedback"] as bool,
          "volume_up",
        ),
        SizedBox(height: 2.h),
        _buildAccessibilityToggle(
          "Voice Command Confirmation",
          "Confirm each voice command before execution",
          "voiceCommandConfirmation",
          accessibilitySettings["voiceCommandConfirmation"] as bool,
          "check_circle",
        ),
      ],
    );
  }

  Widget _buildVisualSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visual Accessibility",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildAccessibilityToggle(
          "High Contrast Mode",
          "Increase contrast for better visibility",
          "highContrastMode",
          accessibilitySettings["highContrastMode"] as bool,
          "contrast",
        ),
        SizedBox(height: 2.h),
        _buildFontSizeSlider(),
        SizedBox(height: 2.h),
        _buildAccessibilityToggle(
          "Reduce Motion",
          "Minimize animations and transitions",
          "reduceMotion",
          accessibilitySettings["reduceMotion"] as bool,
          "motion_photos_off",
        ),
        SizedBox(height: 2.h),
        _buildAccessibilityToggle(
          "Screen Reader Support",
          "Optimize for screen reading software",
          "screenReaderSupport",
          accessibilitySettings["screenReaderSupport"] as bool,
          "visibility",
        ),
      ],
    );
  }

  Widget _buildInputSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Input Methods",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        _buildAccessibilityToggle(
          "Large Touch Targets",
          "Increase button and touch area sizes",
          "largeTouchTargets",
          accessibilitySettings["largeTouchTargets"] as bool,
          "touch_app",
        ),
        SizedBox(height: 2.h),
        _buildAccessibilityToggle(
          "Gesture Alternatives",
          "Provide button alternatives to gestures",
          "gestureAlternatives",
          accessibilitySettings["gestureAlternatives"] as bool,
          "pan_tool",
        ),
        SizedBox(height: 2.h),
        _buildVoiceTimeoutSlider(),
      ],
    );
  }

  Widget _buildAccessibilityToggle(
    String title,
    String description,
    String key,
    bool value,
    String iconName,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: value
            ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: value
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2)
              : AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: value
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: value
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) =>
                onAccessibilitySettingChanged(key, newValue),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'text_fields',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                "Font Size",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                "A",
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Expanded(
                child: Slider(
                  value: (accessibilitySettings["fontSize"] as double),
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  onChanged: (value) {
                    onAccessibilitySettingChanged("fontSize", value);
                  },
                ),
              ),
              Text(
                "A",
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          Text(
            "Current size: ${((accessibilitySettings["fontSize"] as double) * 100).round()}%",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceTimeoutSlider() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'timer',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                "Voice Command Timeout",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            "How long to wait for voice commands",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                "3s",
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Expanded(
                child: Slider(
                  value: (accessibilitySettings["voiceTimeout"] as double),
                  min: 3.0,
                  max: 15.0,
                  divisions: 12,
                  onChanged: (value) {
                    onAccessibilitySettingChanged("voiceTimeout", value);
                  },
                ),
              ),
              Text(
                "15s",
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            "Current timeout: ${(accessibilitySettings["voiceTimeout"] as double).round()} seconds",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
