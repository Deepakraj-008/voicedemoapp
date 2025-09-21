import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SessionCardWidget extends StatelessWidget {
  final Map<String, dynamic> session;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SessionCardWidget({
    super.key,
    required this.session,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final courseName = session['courseName'] as String? ?? 'Unknown Course';
    final duration = session['duration'] as int? ?? 60;
    final startTime = session['startTime'] as String? ?? '09:00';
    final endTime = session['endTime'] as String? ?? '10:00';
    final status = session['status'] as String? ?? 'scheduled';
    final difficulty = session['difficulty'] as String? ?? 'intermediate';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStatusColor(status, colorScheme).withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, colorScheme, courseName, status),
            SizedBox(height: 2.h),
            _buildTimeInfo(theme, colorScheme, startTime, endTime, duration),
            SizedBox(height: 1.h),
            _buildFooter(theme, colorScheme, difficulty),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    ColorScheme colorScheme,
    String courseName,
    String status,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                courseName,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              _buildStatusChip(theme, colorScheme, status),
            ],
          ),
        ),
        _buildActionMenu(colorScheme),
      ],
    );
  }

  Widget _buildStatusChip(
    ThemeData theme,
    ColorScheme colorScheme,
    String status,
  ) {
    final statusColor = _getStatusColor(status, colorScheme);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildActionMenu(ColorScheme colorScheme) {
    return PopupMenuButton<String>(
      icon: CustomIconWidget(
        iconName: 'more_vert',
        color: colorScheme.onSurface.withValues(alpha: 0.6),
        size: 20,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'edit',
                color: colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text('Edit Session'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: colorScheme.error,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text('Delete Session'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(
    ThemeData theme,
    ColorScheme colorScheme,
    String startTime,
    String endTime,
    int duration,
  ) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'access_time',
          color: colorScheme.primary,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          '$startTime - $endTime',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 4.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: colorScheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${duration}min',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    ThemeData theme,
    ColorScheme colorScheme,
    String difficulty,
  ) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'trending_up',
          color: _getDifficultyColor(difficulty, colorScheme),
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          difficulty.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: _getDifficultyColor(difficulty, colorScheme),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'completed':
        return colorScheme.tertiary;
      case 'in_progress':
        return colorScheme.secondary;
      case 'missed':
        return colorScheme.error;
      case 'scheduled':
      default:
        return colorScheme.primary;
    }
  }

  Color _getDifficultyColor(String difficulty, ColorScheme colorScheme) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return colorScheme.tertiary;
      case 'advanced':
        return colorScheme.error;
      case 'intermediate':
      default:
        return colorScheme.secondary;
    }
  }
}
