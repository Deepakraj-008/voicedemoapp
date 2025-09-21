import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class CalendarViewWidget extends StatefulWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final Map<DateTime, List<Map<String, dynamic>>> events;

  const CalendarViewWidget({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.events,
  });

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(colorScheme),
          _buildCalendar(colorScheme),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getFormattedMonth(widget.focusedDay),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              _buildFormatButton(
                'Month',
                CalendarFormat.month,
                colorScheme,
              ),
              SizedBox(width: 2.w),
              _buildFormatButton(
                'Week',
                CalendarFormat.week,
                colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(
    String label,
    CalendarFormat format,
    ColorScheme colorScheme,
  ) {
    final isSelected = _calendarFormat == format;

    return GestureDetector(
      onTap: () {
        setState(() {
          _calendarFormat = format;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.primary,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(ColorScheme colorScheme) {
    return TableCalendar<Map<String, dynamic>>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: widget.focusedDay,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      calendarFormat: _calendarFormat,
      eventLoader: (day) {
        return widget.events[DateTime(day.year, day.month, day.day)] ?? [];
      },
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: widget.onDaySelected,
      onPageChanged: widget.onPageChanged,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: colorScheme.error,
        ),
        holidayTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: colorScheme.error,
        ),
        selectedDecoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
        todayDecoration: BoxDecoration(
          color: colorScheme.secondary.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        todayTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSecondary,
          fontWeight: FontWeight.w600,
        ),
        defaultTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSurface,
        ),
        markerDecoration: BoxDecoration(
          color: colorScheme.tertiary,
          shape: BoxShape.circle,
        ),
        markersMaxCount: 3,
        canMarkersOverflow: true,
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        headerPadding: EdgeInsets.zero,
        headerMargin: EdgeInsets.zero,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
        weekendStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: colorScheme.error.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getFormattedMonth(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}