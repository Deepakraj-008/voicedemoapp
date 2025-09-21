import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseInfoCards extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const CourseInfoCards({
    super.key,
    required this.courseData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          // Difficulty Card
          Expanded(
            child: _buildInfoCard(
              context,
              icon: 'trending_up',
              title: 'Difficulty',
              value: courseData["difficulty"] as String,
              color: _getDifficultyColor(courseData["difficulty"] as String),
            ),
          ),

          SizedBox(width: 3.w),

          // Duration Card
          Expanded(
            child: _buildInfoCard(
              context,
              icon: 'schedule',
              title: 'Duration',
              value: courseData["duration"] as String,
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
          ),

          SizedBox(width: 3.w),

          // Students Card
          Expanded(
            child: _buildInfoCard(
              context,
              icon: 'people',
              title: 'Students',
              value: courseData["studentsCount"] as String,
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
