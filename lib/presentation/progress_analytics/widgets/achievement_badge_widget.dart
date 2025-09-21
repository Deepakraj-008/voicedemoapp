import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color badgeColor;
  final bool isEarned;
  final DateTime? earnedDate;
  final VoidCallback? onTap;

  const AchievementBadgeWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.badgeColor,
    required this.isEarned,
    this.earnedDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned
                ? badgeColor.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isEarned
              ? [
                  BoxShadow(
                    color: badgeColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: isEarned
                        ? badgeColor.withValues(alpha: 0.2)
                        : colorScheme.outline.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: icon.codePoint.toString(),
                    color: isEarned
                        ? badgeColor
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 6.w,
                  ),
                ),
                if (isEarned)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: AppTheme.successLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 1,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 2.w,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isEarned
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 11.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              isEarned && earnedDate != null
                  ? _formatDate(earnedDate!)
                  : 'Not earned',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isEarned
                    ? badgeColor
                    : colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 9.sp,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else if (difference < 30) {
      return '${(difference / 7).floor()}w ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
