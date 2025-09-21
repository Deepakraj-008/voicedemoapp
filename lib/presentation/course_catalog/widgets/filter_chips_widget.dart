import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final ValueChanged<String>? onCategorySelected;
  final VoidCallback? onClearFilters;

  const FilterChipsWidget({
    super.key,
    required this.categories,
    required this.selectedCategories,
    this.onCategorySelected,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length + (selectedCategories.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (selectedCategories.isNotEmpty && index == 0) {
            return _buildClearAllChip(context, colorScheme);
          }

          final categoryIndex =
              selectedCategories.isNotEmpty ? index - 1 : index;
          final category = categories[categoryIndex];
          final isSelected = selectedCategories.contains(category);

          return _buildFilterChip(context, colorScheme, category, isSelected);
        },
      ),
    );
  }

  Widget _buildClearAllChip(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'clear_all',
              color: colorScheme.error,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              'Clear All',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        onSelected: (_) => onClearFilters?.call(),
        backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.1),
        selectedColor: colorScheme.errorContainer.withValues(alpha: 0.2),
        side: BorderSide(
          color: colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, ColorScheme colorScheme,
      String category, bool isSelected) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: FilterChip(
        label: Text(
          category,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onCategorySelected?.call(category),
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primary,
        checkmarkColor: colorScheme.onPrimary,
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
      ),
    );
  }
}
