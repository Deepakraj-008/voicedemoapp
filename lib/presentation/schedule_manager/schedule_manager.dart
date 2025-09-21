import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/calendar_view_widget.dart';
import './widgets/schedule_bottom_sheet_widget.dart';
import './widgets/session_card_widget.dart';
import './widgets/voice_assistant_widget.dart';
import 'widgets/calendar_view_widget.dart';
import 'widgets/schedule_bottom_sheet_widget.dart';
import 'widgets/session_card_widget.dart';
import 'widgets/voice_assistant_widget.dart';

class ScheduleManager extends StatefulWidget {
  const ScheduleManager({super.key});

  @override
  State<ScheduleManager> createState() => _ScheduleManagerState();
}

class _ScheduleManagerState extends State<ScheduleManager>
    with TickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _isListening = false;
  int _currentBottomNavIndex = 2; // Schedule tab active

  late TabController _tabController;
  final List<String> _tabTitles = ['Calendar', 'Sessions', 'Voice Assistant'];

  // Mock data for scheduled sessions
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  final List<Map<String, dynamic>> _allSessions = [
    {
      'id': 1,
      'courseName': 'Python Fundamentals',
      'date': DateTime.now(),
      'startTime': '09:00',
      'endTime': '10:30',
      'duration': 90,
      'difficulty': 'beginner',
      'status': 'scheduled',
      'notes': 'Focus on data structures and algorithms',
    },
    {
      'id': 2,
      'courseName': 'JavaScript Advanced',
      'date': DateTime.now().add(const Duration(days: 1)),
      'startTime': '14:00',
      'endTime': '15:00',
      'duration': 60,
      'difficulty': 'advanced',
      'status': 'scheduled',
      'notes': 'Async/await and promises deep dive',
    },
    {
      'id': 3,
      'courseName': 'Cloud Architecture',
      'date': DateTime.now().add(const Duration(days: 2)),
      'startTime': '10:00',
      'endTime': '11:30',
      'duration': 90,
      'difficulty': 'intermediate',
      'status': 'scheduled',
      'notes': 'AWS services overview and best practices',
    },
    {
      'id': 4,
      'courseName': 'Bash Scripting',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'startTime': '16:00',
      'endTime': '17:00',
      'duration': 60,
      'difficulty': 'intermediate',
      'status': 'completed',
      'notes': 'Automation scripts for deployment',
    },
    {
      'id': 5,
      'courseName': 'PowerShell Basics',
      'date': DateTime.now().add(const Duration(days: 3)),
      'startTime': '11:00',
      'endTime': '12:30',
      'duration': 90,
      'difficulty': 'beginner',
      'status': 'scheduled',
      'notes': 'Windows administration and automation',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeTabController();
    _organizeEvents();
  }

  void _initializeTabController() {
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  void _organizeEvents() {
    _events.clear();
    for (final session in _allSessions) {
      final date = session['date'] as DateTime;
      final key = DateTime(date.year, date.month, date.day);

      if (_events[key] == null) {
        _events[key] = [];
      }
      _events[key]!.add(session);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(theme, colorScheme),
      body: Column(
        children: [
          _buildTabBar(theme, colorScheme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCalendarTab(),
                _buildSessionsTab(),
                _buildVoiceAssistantTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(colorScheme),
      bottomNavigationBar: _buildBottomNavigationBar(colorScheme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      title: Text(
        'Schedule Manager',
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _showScheduleOptions,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          CalendarViewWidget(
            selectedDay: _selectedDay,
            focusedDay: _focusedDay,
            onDaySelected: _onDaySelected,
            onPageChanged: _onPageChanged,
            events: _events,
          ),
          SizedBox(height: 2.h),
          _buildSelectedDaySessions(),
        ],
      ),
    );
  }

  Widget _buildSessionsTab() {
    final upcomingSessions = _allSessions
        .where((session) => (session['date'] as DateTime).isAfter(
              DateTime.now().subtract(const Duration(days: 1)),
            ))
        .toList();

    upcomingSessions.sort(
        (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    return upcomingSessions.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            itemCount: upcomingSessions.length,
            itemBuilder: (context, index) {
              final session = upcomingSessions[index];
              return SessionCardWidget(
                session: session,
                onTap: () => _showSessionDetails(session),
                onEdit: () => _editSession(session),
                onDelete: () => _deleteSession(session['id'] as int),
              );
            },
          );
  }

  Widget _buildVoiceAssistantTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          VoiceAssistantWidget(
            isListening: _isListening,
            onToggleListening: _toggleVoiceListening,
            onVoiceCommand: _handleVoiceCommand,
          ),
          SizedBox(height: 3.h),
          _buildVoiceCommandsHelp(),
        ],
      ),
    );
  }

  Widget _buildSelectedDaySessions() {
    final selectedDateKey = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    final daySessions = _events[selectedDateKey] ?? [];

    if (daySessions.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'event_available',
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No sessions scheduled',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Tap the + button to schedule a new session',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: daySessions
          .map((session) => SessionCardWidget(
                session: session,
                onTap: () => _showSessionDetails(session),
                onEdit: () => _editSession(session),
                onDelete: () => _deleteSession(session['id'] as int),
              ))
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Sessions Scheduled',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start your learning journey by scheduling your first study session',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: _scheduleNewSession,
              icon: CustomIconWidget(
                iconName: 'add',
                color: colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text('Schedule Session'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceCommandsHelp() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final commands = [
      {
        'command': 'Show this week',
        'description': 'Display current week\'s schedule',
      },
      {
        'command': 'Schedule Python practice',
        'description': 'Create new Python study session',
      },
      {
        'command': 'Go to next month',
        'description': 'Navigate to next month view',
      },
      {
        'command': 'Today\'s sessions',
        'description': 'Show today\'s scheduled sessions',
      },
      {
        'command': 'Reschedule Friday session',
        'description': 'Modify Friday\'s study session',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voice Commands Guide',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          ...commands.map((cmd) => Container(
                margin: EdgeInsets.only(bottom: 1.5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: EdgeInsets.only(top: 1.h, right: 3.w),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${cmd['command']}"',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            cmd['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(ColorScheme colorScheme) {
    return FloatingActionButton(
      onPressed: _scheduleNewSession,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      child: CustomIconWidget(
        iconName: 'add',
        color: colorScheme.onPrimary,
        size: 28,
      ),
    );
  }

  Widget _buildBottomNavigationBar(ColorScheme colorScheme) {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard_outlined',
            color: _currentBottomNavIndex == 0
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'dashboard',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'book_outlined',
            color: _currentBottomNavIndex == 1
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'book',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'schedule_outlined',
            color: _currentBottomNavIndex == 2
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'schedule',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics_outlined',
            color: _currentBottomNavIndex == 3
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'analytics',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Progress',
        ),
      ],
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _onBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/voice-dashboard',
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/course-detail',
          (route) => false,
        );
        break;
      case 2:
        // Already on schedule manager
        break;
      case 3:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/progress-analytics',
          (route) => false,
        );
        break;
    }
  }

  void _toggleVoiceListening() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Simulate voice recognition timeout
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isListening) {
          setState(() {
            _isListening = false;
          });
        }
      });
    }
  }

  void _handleVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('show this week') ||
        lowerCommand.contains('this week')) {
      _tabController.animateTo(0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Showing this week\'s schedule')),
      );
    } else if (lowerCommand.contains('schedule') &&
        lowerCommand.contains('python')) {
      _scheduleNewSession();
    } else if (lowerCommand.contains('next month')) {
      setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
      });
      _tabController.animateTo(0);
    } else if (lowerCommand.contains('today') ||
        lowerCommand.contains('today\'s sessions')) {
      setState(() {
        _selectedDay = DateTime.now();
        _focusedDay = DateTime.now();
      });
      _tabController.animateTo(0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Command recognized: "$command"')),
      );
    }
  }

  void _scheduleNewSession() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ScheduleBottomSheetWidget(
          onSave: _saveSession,
        ),
      ),
    );
  }

  void _editSession(Map<String, dynamic> session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ScheduleBottomSheetWidget(
          session: session,
          onSave: _saveSession,
          onDelete: () => _deleteSession(session['id'] as int),
        ),
      ),
    );
  }

  void _saveSession(Map<String, dynamic> sessionData) {
    setState(() {
      final existingIndex = _allSessions.indexWhere(
        (session) => session['id'] == sessionData['id'],
      );

      if (existingIndex != -1) {
        _allSessions[existingIndex] = sessionData;
      } else {
        _allSessions.add(sessionData);
      }

      _organizeEvents();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _allSessions.indexWhere(
                      (session) => session['id'] == sessionData['id']) !=
                  -1
              ? 'Session updated successfully'
              : 'Session scheduled successfully',
        ),
      ),
    );
  }

  void _deleteSession(int sessionId) {
    setState(() {
      _allSessions.removeWhere((session) => session['id'] == sessionId);
      _organizeEvents();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session deleted successfully')),
    );
  }

  void _showSessionDetails(Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(session['courseName'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${_formatDate(session['date'] as DateTime)}'),
            Text('Time: ${session['startTime']} - ${session['endTime']}'),
            Text('Duration: ${session['duration']} minutes'),
            Text('Difficulty: ${session['difficulty']}'),
            Text('Status: ${session['status']}'),
            if (session['notes'] != null &&
                (session['notes'] as String).isNotEmpty)
              Text('Notes: ${session['notes']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editSession(session);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showScheduleOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'sync',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Sync with Calendar'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Syncing with device calendar...')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Notification Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Opening notification settings...')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Export Schedule'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting schedule...')),
                );
              },
            ),
          ],
        ),
      ),
    );
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
