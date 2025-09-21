import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onStartNewCourse;
  final VoidCallback onTakeQuiz;
  final VoidCallback onReviewFlashcards;
  final VoidCallback onCheckSchedule;

  const QuickActionsWidget({
    super.key,
    required this.onStartNewCourse,
    required this.onTakeQuiz,
    required this.onReviewFlashcards,
    required this.onCheckSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
            children: [
              _buildActionCard(
                icon: 'school',
                title: 'Start New Course',
                subtitle: 'Begin learning',
                color: AppTheme.lightTheme.colorScheme.primary,
                onTap: onStartNewCourse,
              ),
              _buildActionCard(
                icon: 'quiz',
                title: 'Take a Quiz',
                subtitle: 'Test knowledge',
                color: AppTheme.lightTheme.colorScheme.secondary,
                onTap: onTakeQuiz,
              ),
              _buildActionCard(
                icon: 'style',
                title: 'Review Cards',
                subtitle: 'Quick revision',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                onTap: onReviewFlashcards,
              ),
              _buildActionCard(
                icon: 'calendar_today',
                title: 'My Schedule',
                subtitle: 'View sessions',
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.8),
                onTap: onCheckSchedule,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 6.w,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomIconWidget(
                  iconName: 'mic',
                  color: color.withValues(alpha: 0.6),
                  size: 4.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
