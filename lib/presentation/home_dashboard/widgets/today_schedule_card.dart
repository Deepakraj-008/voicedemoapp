import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodayScheduleCard extends StatelessWidget {
  final List<Map<String, dynamic>> scheduleItems;
  final Function(Map<String, dynamic>) onItemTap;
  final Function(Map<String, dynamic>) onItemLongPress;

  const TodayScheduleCard({
    Key? key,
    required this.scheduleItems,
    required this.onItemTap,
    required this.onItemLongPress,
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
                iconName: 'schedule',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                "Today's Schedule",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  "${scheduleItems.length} lessons",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          scheduleItems.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.dividerLight.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'event_available',
                        color: AppTheme.textSecondaryLight,
                        size: 8.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "No lessons scheduled for today",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Say "Schedule study time" to add lessons',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textDisabledLight,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: scheduleItems.take(3).map((item) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(2.w),
                          onTap: () => onItemTap(item),
                          onLongPress: () => onItemLongPress(item),
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(2.w),
                              border: Border.all(
                                color: AppTheme.dividerLight
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                            item["status"] as String)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: _getStatusIcon(
                                          item["status"] as String),
                                      color: _getStatusColor(
                                          item["status"] as String),
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimaryLight,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Row(
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'access_time',
                                            color: AppTheme.textSecondaryLight,
                                            size: 3.w,
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            "${item["time"]} • ${item["duration"]}",
                                            style: AppTheme
                                                .lightTheme.textTheme.bodySmall
                                                ?.copyWith(
                                              color:
                                                  AppTheme.textSecondaryLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                            item["status"] as String)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(1.w),
                                  ),
                                  child: Text(
                                    item["status"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: _getStatusColor(
                                          item["status"] as String),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
          if (scheduleItems.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                'Say "Start lesson" to begin',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppTheme.lightTheme.primaryColor;
      case 'in progress':
        return AppTheme.warningLight;
      case 'completed':
        return AppTheme.successLight;
      case 'missed':
        return AppTheme.errorLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return 'schedule';
      case 'in progress':
        return 'play_circle_filled';
      case 'completed':
        return 'check_circle';
      case 'missed':
        return 'cancel';
      default:
        return 'radio_button_unchecked';
    }
  }
}
