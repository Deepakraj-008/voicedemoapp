import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickScheduleModal extends StatefulWidget {
  final DateTime selectedDate;
  final Function(Map<String, dynamic>) onScheduleSession;
  final List<String> availableCourses;

  const QuickScheduleModal({
    super.key,
    required this.selectedDate,
    required this.onScheduleSession,
    required this.availableCourses,
  });

  @override
  State<QuickScheduleModal> createState() => _QuickScheduleModalState();
}

class _QuickScheduleModalState extends State<QuickScheduleModal> {
  String? selectedCourse;
  String selectedType = 'lesson';
  TimeOfDay selectedTime = TimeOfDay.now();
  int selectedDuration = 60;
  final TextEditingController _descriptionController = TextEditingController();
  bool isListeningToVoice = false;

  final List<String> sessionTypes = ['lesson', 'quiz', 'review', 'project'];
  final List<int> durations = [30, 45, 60, 90, 120];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Schedule',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _toggleVoiceInput,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isListeningToVoice
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: isListeningToVoice ? 'mic' : 'mic_none',
                        color: isListeningToVoice
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Date: ${_formatDate(widget.selectedDate)}',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3.h),
          _buildCourseSelection(),
          SizedBox(height: 3.h),
          _buildSessionTypeSelection(),
          SizedBox(height: 3.h),
          _buildTimeAndDurationSelection(),
          SizedBox(height: 3.h),
          _buildDescriptionInput(),
          SizedBox(height: 4.h),
          _buildActionButtons(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildCourseSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCourse,
              hint: Text(
                'Select a course',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              isExpanded: true,
              items: widget.availableCourses.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(
                    course,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Type',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          children: sessionTypes.map((type) {
            final isSelected = selectedType == type;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedType = type;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Text(
                  type.toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeAndDurationSelection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: _selectTime,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime.format(context),
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Duration (min)',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedDuration,
                    isExpanded: true,
                    items: durations.map((duration) {
                      return DropdownMenuItem<int>(
                        value: duration,
                        child: Text(
                          '$duration min',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedDuration = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add session notes or objectives...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: selectedCourse != null ? _scheduleSession : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Schedule'),
          ),
        ),
      ],
    );
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _toggleVoiceInput() {
    setState(() {
      isListeningToVoice = !isListeningToVoice;
    });

    if (isListeningToVoice) {
      // Simulate voice input processing
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            isListeningToVoice = false;
          });
          _processVoiceCommand("Schedule Python lesson at 3 PM for 90 minutes");
        }
      });
    }
  }

  void _processVoiceCommand(String command) {
    // Simple voice command processing simulation
    if (command.toLowerCase().contains('python')) {
      setState(() {
        selectedCourse = widget.availableCourses.firstWhere(
          (course) => course.toLowerCase().contains('python'),
          orElse: () => widget.availableCourses.first,
        );
      });
    }

    if (command.toLowerCase().contains('3 pm')) {
      setState(() {
        selectedTime = const TimeOfDay(hour: 15, minute: 0);
      });
    }

    if (command.toLowerCase().contains('90 minutes')) {
      setState(() {
        selectedDuration = 90;
      });
    }
  }

  void _scheduleSession() {
    if (selectedCourse == null) return;

    final endTime = TimeOfDay(
      hour: (selectedTime.hour + (selectedDuration ~/ 60)) % 24,
      minute: (selectedTime.minute + (selectedDuration % 60)) % 60,
    );

    final sessionData = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'courseName': selectedCourse!,
      'type': selectedType,
      'date': widget.selectedDate,
      'startTime': selectedTime.format(context),
      'endTime': endTime.format(context),
      'duration': selectedDuration,
      'description': _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : 'Scheduled via quick schedule',
      'status': 'upcoming',
    };

    widget.onScheduleSession(sessionData);
    Navigator.pop(context);
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
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}
