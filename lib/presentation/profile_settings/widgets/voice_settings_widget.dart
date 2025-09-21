import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> voiceSettings;
  final Function(String, dynamic) onSettingChanged;

  const VoiceSettingsWidget({
    Key? key,
    required this.voiceSettings,
    required this.onSettingChanged,
  }) : super(key: key);

  @override
  State<VoiceSettingsWidget> createState() => _VoiceSettingsWidgetState();
}

class _VoiceSettingsWidgetState extends State<VoiceSettingsWidget> {
  bool _isPlaying = false;

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
                iconName: 'mic',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                "Voice Settings",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildWakeWordSensitivity(),
          SizedBox(height: 3.h),
          _buildVoiceGenderSelection(),
          SizedBox(height: 3.h),
          _buildSpeechRateSlider(),
          SizedBox(height: 3.h),
          _buildVoicePreview(),
        ],
      ),
    );
  }

  Widget _buildWakeWordSensitivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Wake Word Sensitivity",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "Adjust how easily 'Hello Sweety' activates the assistant",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              "Low",
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Expanded(
              child: Slider(
                value: (widget.voiceSettings["wakeWordSensitivity"] as double),
                min: 0.0,
                max: 1.0,
                divisions: 10,
                onChanged: (value) {
                  widget.onSettingChanged("wakeWordSensitivity", value);
                },
              ),
            ),
            Text(
              "High",
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoiceGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Voice Gender & Accent",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildVoiceOption(
                "Female",
                "US English",
                widget.voiceSettings["voiceGender"] == "female",
                () => widget.onSettingChanged("voiceGender", "female"),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildVoiceOption(
                "Male",
                "US English",
                widget.voiceSettings["voiceGender"] == "male",
                () => widget.onSettingChanged("voiceGender", "male"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoiceOption(
      String gender, String accent, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: gender == "Female" ? 'person' : 'person_outline',
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              gender,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              accent,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeechRateSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Speech Rate",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "Adjust how fast Sweety speaks",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'speed',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              "Slow",
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Expanded(
              child: Slider(
                value: (widget.voiceSettings["speechRate"] as double),
                min: 0.5,
                max: 2.0,
                divisions: 15,
                onChanged: (value) {
                  widget.onSettingChanged("speechRate", value);
                },
              ),
            ),
            Text(
              "Fast",
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'fast_forward',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoicePreview() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Voice Preview",
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Hello! I'm Sweety, your AI learning assistant. How can I help you today?",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 2.h),
          Center(
            child: ElevatedButton.icon(
              onPressed: _playVoicePreview,
              icon: CustomIconWidget(
                iconName: _isPlaying ? 'stop' : 'play_arrow',
                color: Colors.white,
                size: 4.w,
              ),
              label: Text(
                _isPlaying ? "Stop Preview" : "Play Preview",
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _playVoicePreview() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      // Simulate voice preview duration
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    }
  }
}
