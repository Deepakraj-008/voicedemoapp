import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickSuggestionsWidget extends StatelessWidget {
  final Function(String) onSuggestionTap;
  final bool isVisible;

  const QuickSuggestionsWidget({
    Key? key,
    required this.onSuggestionTap,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final suggestions = [
      {
        'text': 'Explain this concept',
        'icon': 'lightbulb_outline',
      },
      {
        'text': 'Generate practice problems',
        'icon': 'quiz',
      },
      {
        'text': 'Help with homework',
        'icon': 'school',
      },
      {
        'text': 'Create study schedule',
        'icon': 'schedule',
      },
      {
        'text': 'Review my progress',
        'icon': 'trending_up',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Commands',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: suggestions.map((suggestion) {
              return _buildSuggestionChip(
                text: suggestion['text'] as String,
                icon: suggestion['icon'] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip({
    required String text,
    required String icon,
  }) {
    return GestureDetector(
      onTap: () => onSuggestionTap(text),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.primaryColor,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                text,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
