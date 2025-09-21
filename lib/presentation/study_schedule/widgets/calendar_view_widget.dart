import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';

class CalendarViewWidget extends StatefulWidget {
  final String viewType;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final Map<DateTime, List<Map<String, dynamic>>> scheduleData;
  final Function(DateTime) onQuickSchedule;

  const CalendarViewWidget({
    super.key,
    required this.viewType,
    required this.selectedDay,
    required this.onDaySelected,
    required this.scheduleData,
    required this.onQuickSchedule,
  });

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay;
    _updateCalendarFormat();
  }

  @override
  void didUpdateWidget(CalendarViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewType != widget.viewType) {
      _updateCalendarFormat();
    }
  }

  void _updateCalendarFormat() {
    switch (widget.viewType.toLowerCase()) {
      case 'daily':
        _calendarFormat = CalendarFormat.week;
        break;
      case 'weekly':
        _calendarFormat = CalendarFormat.twoWeeks;
        break;
      case 'monthly':
        _calendarFormat = CalendarFormat.month;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TableCalendar<Map<String, dynamic>>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              final normalizedDay = DateTime(day.year, day.month, day.day);
              return widget.scheduleData[normalizedDay] ?? [];
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle:
                  AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ) ??
                      const TextStyle(),
              holidayTextStyle:
                  AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ) ??
                      const TextStyle(),
              selectedDecoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
              canMarkersOverflow: true,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle:
                  AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ) ??
                      const TextStyle(),
              leftChevronIcon: CustomIconWidget(
                iconName: 'chevron_left',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              rightChevronIcon: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ) ??
                  const TextStyle(),
              weekendStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ) ??
                  const TextStyle(),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              widget.onDaySelected(selectedDay);
            },
            onDayLongPressed: (selectedDay, focusedDay) {
              widget.onQuickSchedule(selectedDay);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          if (widget
                  .scheduleData[DateTime(widget.selectedDay.year,
                      widget.selectedDay.month, widget.selectedDay.day)]
                  ?.isNotEmpty ??
              false)
            _buildSelectedDayEvents(),
        ],
      ),
    );
  }

  Widget _buildSelectedDayEvents() {
    final selectedDayKey = DateTime(widget.selectedDay.year,
        widget.selectedDay.month, widget.selectedDay.day);
    final events = widget.scheduleData[selectedDayKey] ?? [];

    if (events.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          SizedBox(height: 1.h),
          Text(
            'Sessions for ${_formatDate(widget.selectedDay)}',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...events.map((event) => _buildEventTile(event)).toList(),
        ],
      ),
    );
  }

  Widget _buildEventTile(Map<String, dynamic> event) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 6.h,
            decoration: BoxDecoration(
              color: _getEventColor(event['type'] as String),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['courseName'] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${event['startTime']} - ${event['endTime']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (event['description'] != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    event['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getEventColor(event['type'] as String)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getEventTypeText(event['type'] as String),
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: _getEventColor(event['type'] as String),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'lesson':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'quiz':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'review':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'project':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getEventTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'lesson':
        return 'Lesson';
      case 'quiz':
        return 'Quiz';
      case 'review':
        return 'Review';
      case 'project':
        return 'Project';
      default:
        return 'Session';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
