import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressOverviewCard extends StatelessWidget {
  final Map<String, dynamic> progressData;

  const ProgressOverviewCard({
    Key? key,
    required this.progressData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                iconName: 'trending_up',
                color: AppTheme.successLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                "Progress Overview",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildProgressRing(
                  title: "Course Progress",
                  value: (progressData["courseProgress"] as num).toDouble(),
                  color: AppTheme.lightTheme.primaryColor,
                  icon: 'school',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildProgressRing(
                  title: "Streak Days",
                  value: (progressData["streakDays"] as num).toDouble() / 30.0,
                  color: AppTheme.warningLight,
                  icon: 'local_fire_department',
                  displayValue: "${progressData["streakDays"]} days",
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildProgressRing(
                  title: "Mastery Score",
                  value: (progressData["masteryScore"] as num).toDouble(),
                  color: AppTheme.successLight,
                  icon: 'star',
                  displayValue: "${((progressData["masteryScore"] as num) * 100).toInt()}%",
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'insights',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Weekly Goal",
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "${progressData["weeklyProgress"]}/${progressData["weeklyGoal"]} hours completed",
                        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    "${((progressData["weeklyProgress"] as num) / (progressData["weeklyGoal"] as num) * 100).toInt()}%",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing({
    required String title,
    required double value,
    required Color color,
    required String icon,
    String? displayValue,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 20.w,
          height: 20.w,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    value: value.clamp(0.0, 1.0),
                    strokeWidth: 1.w,
                    backgroundColor: color.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: icon,
                      color: color,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          displayValue ?? "${(value * 100).toInt()}%",
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}