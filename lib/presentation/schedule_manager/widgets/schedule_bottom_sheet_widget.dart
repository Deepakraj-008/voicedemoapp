import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ScheduleBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic>? session;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback? onDelete;

  const ScheduleBottomSheetWidget({
    super.key,
    this.session,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<ScheduleBottomSheetWidget> createState() =>
      _ScheduleBottomSheetWidgetState();
}

class _ScheduleBottomSheetWidgetState extends State<ScheduleBottomSheetWidget> {
  late TextEditingController _courseController;
  late TextEditingController _notesController;
  String _selectedDifficulty = 'intermediate';
  int _selectedDuration = 60;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  final List<String> _difficulties = ['beginner', 'intermediate', 'advanced'];
  final List<int> _durations = [30, 45, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadSessionData();
  }

  void _initializeControllers() {
    _courseController = TextEditingController();
    _notesController = TextEditingController();
  }

  void _loadSessionData() {
    if (widget.session != null) {
      final session = widget.session!;
      _courseController.text = session['courseName'] as String? ?? '';
      _notesController.text = session['notes'] as String? ?? '';
      _selectedDifficulty = session['difficulty'] as String? ?? 'intermediate';
      _selectedDuration = session['duration'] as int? ?? 60;

      if (session['startTime'] != null) {
        final timeParts = (session['startTime'] as String).split(':');
        _selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }

      if (session['date'] != null) {
        _selectedDate = session['date'] as DateTime;
      }
    }
  }

  @override
  void dispose() {
    _courseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, colorScheme),
          SizedBox(height: 3.h),
          _buildForm(theme, colorScheme),
          SizedBox(height: 3.h),
          _buildActionButtons(theme, colorScheme),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.session != null ? 'Edit Session' : 'Schedule New Session',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'close',
              color: colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          'Course Name',
          _courseController,
          'Enter course name',
          theme,
          colorScheme,
        ),
        SizedBox(height: 2.h),
        _buildDateTimeSelectors(theme, colorScheme),
        SizedBox(height: 2.h),
        _buildDurationSelector(theme, colorScheme),
        SizedBox(height: 2.h),
        _buildDifficultySelector(theme, colorScheme),
        SizedBox(height: 2.h),
        _buildTextField(
          'Notes (Optional)',
          _notesController,
          'Add session notes',
          theme,
          colorScheme,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
    ThemeData theme,
    ColorScheme colorScheme, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSelectors(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildSelectorButton(
            'Date',
            _formatDate(_selectedDate),
            () => _selectDate(context),
            theme,
            colorScheme,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: _buildSelectorButton(
            'Time',
            _selectedTime.format(context),
            () => _selectTime(context),
            theme,
            colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          children: _durations.map((duration) {
            final isSelected = _selectedDuration == duration;
            return GestureDetector(
              onTap: () => setState(() => _selectedDuration = duration),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected ? colorScheme.primary : colorScheme.outline,
                  ),
                ),
                child: Text(
                  '${duration}min',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
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

  Widget _buildDifficultySelector(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: _difficulties.map((difficulty) {
            final isSelected = _selectedDifficulty == difficulty;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDifficulty = difficulty),
                child: Container(
                  margin: EdgeInsets.only(
                      right: difficulty != _difficulties.last ? 2.w : 0),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getDifficultyColor(difficulty, colorScheme)
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getDifficultyColor(difficulty, colorScheme),
                    ),
                  ),
                  child: Text(
                    difficulty.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : _getDifficultyColor(difficulty, colorScheme),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectorButton(
    String label,
    String value,
    VoidCallback onTap,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        if (widget.session != null && widget.onDelete != null) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete?.call();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
              child: Text('Delete'),
            ),
          ),
          SizedBox(width: 4.w),
        ],
        Expanded(
          child: ElevatedButton(
            onPressed: _saveSession,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
            child: Text(widget.session != null ? 'Update' : 'Schedule'),
          ),
        ),
      ],
    );
  }

  void _saveSession() {
    if (_courseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a course name')),
      );
      return;
    }

    final sessionData = {
      'id': widget.session?['id'] ?? DateTime.now().millisecondsSinceEpoch,
      'courseName': _courseController.text.trim(),
      'date': _selectedDate,
      'startTime':
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      'endTime': _calculateEndTime(),
      'duration': _selectedDuration,
      'difficulty': _selectedDifficulty,
      'status': widget.session?['status'] ?? 'scheduled',
      'notes': _notesController.text.trim(),
    };

    widget.onSave(sessionData);
    Navigator.pop(context);
  }

  String _calculateEndTime() {
    final endTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    ).add(Duration(minutes: _selectedDuration));

    return '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
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
