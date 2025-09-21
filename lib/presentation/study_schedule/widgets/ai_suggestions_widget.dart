import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiSuggestionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> suggestions;
  final Function(Map<String, dynamic>) onSuggestionAccept;
  final Function(Map<String, dynamic>) onSuggestionDismiss;
  final VoidCallback onRefreshSuggestions;

  const AiSuggestionsWidget({
    super.key,
    required this.suggestions,
    required this.onSuggestionAccept,
    required this.onSuggestionDismiss,
    required this.onRefreshSuggestions,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'auto_awesome',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'AI Suggestions',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onRefreshSuggestions,
                child: Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return Container(
                width: 80.w,
                margin: EdgeInsets.only(right: 3.w),
                child: _buildSuggestionCard(suggestion),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getSuggestionTypeColor(suggestion['type'] as String)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName:
                      _getSuggestionTypeIcon(suggestion['type'] as String),
                  color: _getSuggestionTypeColor(suggestion['type'] as String),
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['title'] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getSuggestionTypeText(suggestion['type'] as String),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            suggestion['description'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          if (suggestion['scheduledTime'] != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    suggestion['scheduledTime'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onSuggestionAccept(suggestion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onSuggestionDismiss(suggestion),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Dismiss',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSuggestionTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'optimal_time':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'spaced_repetition':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'break_reminder':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'review_session':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getSuggestionTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'optimal_time':
        return 'schedule';
      case 'spaced_repetition':
        return 'repeat';
      case 'break_reminder':
        return 'coffee';
      case 'review_session':
        return 'quiz';
      default:
        return 'lightbulb';
    }
  }

  String _getSuggestionTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'optimal_time':
        return 'Optimal Study Time';
      case 'spaced_repetition':
        return 'Spaced Repetition';
      case 'break_reminder':
        return 'Break Reminder';
      case 'review_session':
        return 'Review Session';
      default:
        return 'Suggestion';
    }
  }
}
