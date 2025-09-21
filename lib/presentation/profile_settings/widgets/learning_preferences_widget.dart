import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LearningPreferencesWidget extends StatelessWidget {
  final Map<String, dynamic> learningPreferences;
  final Function(String, dynamic) onPreferenceChanged;

  const LearningPreferencesWidget({
    Key? key,
    required this.learningPreferences,
    required this.onPreferenceChanged,
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
                iconName: 'school',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                "Learning Preferences",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildStudyTimePreferences(),
          SizedBox(height: 3.h),
          _buildDifficultyLevel(),
          SizedBox(height: 3.h),
          _buildNotificationSchedule(),
          SizedBox(height: 3.h),
          _buildLearningStyle(),
        ],
      ),
    );
  }

  Widget _buildStudyTimePreferences() {
    final List<String> timeSlots = ["Morning", "Afternoon", "Evening", "Night"];
    final List<String> selectedTimes =
        (learningPreferences["preferredStudyTimes"] as List).cast<String>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preferred Study Times",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "When do you prefer to study? (Voice command: 'Set study time to morning')",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: timeSlots.map((time) {
            final isSelected = selectedTimes.contains(time.toLowerCase());
            return GestureDetector(
              onTap: () {
                List<String> updatedTimes = List.from(selectedTimes);
                if (isSelected) {
                  updatedTimes.remove(time.toLowerCase());
                } else {
                  updatedTimes.add(time.toLowerCase());
                }
                onPreferenceChanged("preferredStudyTimes", updatedTimes);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Text(
                  time,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDifficultyLevel() {
    final List<Map<String, dynamic>> difficultyLevels = [
      {
        "name": "Beginner",
        "icon": "trending_up",
        "description": "Start with basics"
      },
      {
        "name": "Intermediate",
        "icon": "bar_chart",
        "description": "Balanced challenge"
      },
      {
        "name": "Advanced",
        "icon": "rocket_launch",
        "description": "Complex topics"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Difficulty Level",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "Voice command: 'Set difficulty to intermediate'",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: difficultyLevels.map((level) {
            final isSelected = learningPreferences["difficultyLevel"] ==
                level["name"].toLowerCase();
            return Expanded(
              child: GestureDetector(
                onTap: () => onPreferenceChanged(
                    "difficultyLevel", level["name"].toLowerCase()),
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
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
                        iconName: level["icon"] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        level["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        level["description"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotificationSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Study Reminders",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "Voice command: 'Set study reminders for weekday mornings'",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Enable Study Reminders",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: learningPreferences["studyReminders"] as bool,
              onChanged: (value) =>
                  onPreferenceChanged("studyReminders", value),
            ),
          ],
        ),
        if (learningPreferences["studyReminders"] as bool) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reminder Time",
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    Text(
                      learningPreferences["reminderTime"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Frequency",
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    Text(
                      learningPreferences["reminderFrequency"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLearningStyle() {
    final List<Map<String, dynamic>> learningStyles = [
      {
        "name": "Visual",
        "icon": "visibility",
        "description": "Charts & diagrams"
      },
      {
        "name": "Audio",
        "icon": "headphones",
        "description": "Voice explanations"
      },
      {
        "name": "Hands-on",
        "icon": "build",
        "description": "Practice exercises"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Learning Style",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "How do you learn best?",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: learningStyles.map((style) {
            final isSelected = learningPreferences["learningStyle"] ==
                style["name"].toLowerCase();
            return Expanded(
              child: GestureDetector(
                onTap: () => onPreferenceChanged(
                    "learningStyle", style["name"].toLowerCase()),
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1)
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
                        iconName: style["icon"] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        style["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        style["description"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
