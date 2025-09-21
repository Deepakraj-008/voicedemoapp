import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_suggestions_widget.dart';
import './widgets/calendar_view_widget.dart';
import './widgets/quick_schedule_modal.dart';
import './widgets/schedule_header_widget.dart';
import './widgets/today_schedule_widget.dart';
import './widgets/voice_command_widget.dart';

class StudySchedule extends StatefulWidget {
  const StudySchedule({super.key});

  @override
  State<StudySchedule> createState() => _StudyScheduleState();
}

class _StudyScheduleState extends State<StudySchedule>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedView = 'Daily';
  DateTime selectedDay = DateTime.now();
  bool isVoiceListening = false;
  bool showVoiceCommands = false;

  // Mock data for schedule
  final Map<DateTime, List<Map<String, dynamic>>> scheduleData = {};
  final List<Map<String, dynamic>> todaySchedule = [];
  final List<Map<String, dynamic>> aiSuggestions = [];
  final List<String> availableCourses = [
    'Python Programming',
    'Data Structures',
    'Machine Learning',
    'Web Development',
    'Mobile Development',
    'Database Design',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 3);
    _initializeMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Today's schedule
    todaySchedule.addAll([
      {
        'id': 1,
        'courseName': 'Python Programming',
        'type': 'lesson',
        'startTime': '09:00 AM',
        'endTime': '10:30 AM',
        'duration': 90,
        'description':
            'Object-Oriented Programming concepts and practical implementation',
        'status': 'completed',
      },
      {
        'id': 2,
        'courseName': 'Data Structures',
        'type': 'quiz',
        'startTime': '02:00 PM',
        'endTime': '02:45 PM',
        'duration': 45,
        'description': 'Binary Trees and Graph Algorithms assessment',
        'status': 'in_progress',
      },
      {
        'id': 3,
        'courseName': 'Machine Learning',
        'type': 'review',
        'startTime': '04:00 PM',
        'endTime': '05:00 PM',
        'duration': 60,
        'description':
            'Review supervised learning algorithms and model evaluation',
        'status': 'upcoming',
      },
    ]);

    // Schedule data for calendar
    scheduleData[today] = List.from(todaySchedule);

    // Tomorrow's schedule
    final tomorrow = today.add(const Duration(days: 1));
    scheduleData[tomorrow] = [
      {
        'id': 4,
        'courseName': 'Web Development',
        'type': 'lesson',
        'startTime': '10:00 AM',
        'endTime': '11:30 AM',
        'duration': 90,
        'description': 'React.js components and state management',
        'status': 'upcoming',
      },
      {
        'id': 5,
        'courseName': 'Database Design',
        'type': 'project',
        'startTime': '03:00 PM',
        'endTime': '05:00 PM',
        'duration': 120,
        'description': 'Design and implement a relational database schema',
        'status': 'upcoming',
      },
    ];

    // Next week's schedule
    for (int i = 2; i <= 7; i++) {
      final date = today.add(Duration(days: i));
      scheduleData[date] = [
        {
          'id': 10 + i,
          'courseName': availableCourses[i % availableCourses.length],
          'type': ['lesson', 'quiz', 'review'][i % 3],
          'startTime': '${9 + (i % 3)}:00 AM',
          'endTime': '${10 + (i % 3)}:30 AM',
          'duration': 90,
          'description':
              'Scheduled session for ${availableCourses[i % availableCourses.length]}',
          'status': 'upcoming',
        },
      ];
    }

    // AI Suggestions
    aiSuggestions.addAll([
      {
        'id': 1,
        'type': 'optimal_time',
        'title': 'Optimal Study Time',
        'description':
            'Based on your performance data, you learn best between 9-11 AM. Consider scheduling complex topics during this time.',
        'scheduledTime': 'Tomorrow 9:00 AM',
      },
      {
        'id': 2,
        'type': 'spaced_repetition',
        'title': 'Review Python Basics',
        'description':
            'It\'s been 3 days since your last Python review. Spaced repetition suggests reviewing now for better retention.',
        'scheduledTime': 'Today 6:00 PM',
      },
      {
        'id': 3,
        'type': 'break_reminder',
        'title': 'Take a Break',
        'description':
            'You\'ve been studying for 2 hours. Research shows 15-minute breaks improve focus and retention.',
        'scheduledTime': null,
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ScheduleHeaderWidget(
              selectedView: selectedView,
              onViewChanged: _onViewChanged,
              onVoiceCommand: _toggleVoiceCommands,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshSchedule,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (showVoiceCommands)
                        VoiceCommandWidget(
                          onVoiceCommand: _processVoiceCommand,
                          isListening: isVoiceListening,
                        ),
                      TodayScheduleWidget(
                        todaySchedule: todaySchedule,
                        onSessionStart: _onSessionStart,
                        onSessionReschedule: _onSessionReschedule,
                        onSessionComplete: _onSessionComplete,
                      ),
                      SizedBox(height: 2.h),
                      CalendarViewWidget(
                        viewType: selectedView,
                        selectedDay: selectedDay,
                        onDaySelected: _onDaySelected,
                        scheduleData: scheduleData,
                        onQuickSchedule: _showQuickScheduleModal,
                      ),
                      SizedBox(height: 2.h),
                      AiSuggestionsWidget(
                        suggestions: aiSuggestions,
                        onSuggestionAccept: _onSuggestionAccept,
                        onSuggestionDismiss: _onSuggestionDismiss,
                        onRefreshSuggestions: _refreshAiSuggestions,
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleVoiceListening,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: CustomIconWidget(
            key: ValueKey(isVoiceListening),
            iconName: isVoiceListening ? 'mic' : 'mic_none',
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        onTap: _onTabChanged,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'psychology',
              color: _tabController.index == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Voice',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _tabController.index == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Home',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'play_circle',
              color: _tabController.index == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Learn',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: _tabController.index == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Schedule',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'chat',
              color: _tabController.index == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Assistant',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _tabController.index == 5
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Profile',
          ),
        ],
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        labelStyle: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
      ),
    );
  }

  void _onViewChanged(String view) {
    setState(() {
      selectedView = view;
    });
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      selectedDay = day;
    });
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/voice-onboarding');
        break;
      case 1:
        Navigator.pushNamed(context, '/home-dashboard');
        break;
      case 2:
        Navigator.pushNamed(context, '/learning-session');
        break;
      case 3:
        // Current screen - do nothing
        break;
      case 4:
        Navigator.pushNamed(context, '/voice-assistant-chat');
        break;
      case 5:
        Navigator.pushNamed(context, '/profile-settings');
        break;
    }
  }

  void _toggleVoiceCommands() {
    setState(() {
      showVoiceCommands = !showVoiceCommands;
    });
  }

  void _toggleVoiceListening() {
    setState(() {
      isVoiceListening = !isVoiceListening;
      if (isVoiceListening) {
        showVoiceCommands = true;
      }
    });

    if (isVoiceListening) {
      // Simulate voice listening timeout
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && isVoiceListening) {
          setState(() {
            isVoiceListening = false;
          });
        }
      });
    }
  }

  void _processVoiceCommand(String command) {
    setState(() {
      isVoiceListening = false;
    });

    // Process different voice commands
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains("what's my schedule today") ||
        lowerCommand.contains("today's schedule")) {
      _showTodayScheduleDialog();
    } else if (lowerCommand.contains("schedule") &&
        (lowerCommand.contains("lesson") || lowerCommand.contains("session"))) {
      _showQuickScheduleModal(DateTime.now());
    } else if (lowerCommand.contains("show this week")) {
      setState(() {
        selectedView = 'Weekly';
      });
    } else if (lowerCommand.contains("next lesson") ||
        lowerCommand.contains("when is my next")) {
      _showNextLessonDialog();
    } else if (lowerCommand.contains("move") &&
        lowerCommand.contains("evening")) {
      _rescheduleToEvening();
    }
  }

  void _showTodayScheduleDialog() {
    final upcomingSessions = todaySchedule
        .where((session) =>
            session['status'] == 'upcoming' ||
            session['status'] == 'in_progress')
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Today\'s Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: upcomingSessions.isEmpty
              ? [Text('No upcoming sessions today')]
              : upcomingSessions
                  .map((session) => ListTile(
                        title: Text(session['courseName'] as String),
                        subtitle: Text(
                            '${session['startTime']} - ${session['endTime']}'),
                        leading: CustomIconWidget(
                          iconName: _getSessionIcon(session['type'] as String),
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ))
                  .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNextLessonDialog() {
    final nextSession = todaySchedule.firstWhere(
      (session) => session['status'] == 'upcoming',
      orElse: () => <String, dynamic>{},
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Next Lesson'),
        content: nextSession.isEmpty
            ? Text('No upcoming lessons today')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextSession['courseName'] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                      'Time: ${nextSession['startTime']} - ${nextSession['endTime']}'),
                  Text('Duration: ${nextSession['duration']} minutes'),
                  if (nextSession['description'] != null)
                    Text('Topic: ${nextSession['description']}'),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _rescheduleToEvening() {
    // Find today's quiz and reschedule it
    final quizIndex = todaySchedule.indexWhere((session) =>
        session['type'] == 'quiz' && session['status'] != 'completed');

    if (quizIndex != -1) {
      setState(() {
        todaySchedule[quizIndex]['startTime'] = '06:00 PM';
        todaySchedule[quizIndex]['endTime'] = '06:45 PM';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz rescheduled to 6:00 PM'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  String _getSessionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'lesson':
        return 'school';
      case 'quiz':
        return 'quiz';
      case 'review':
        return 'refresh';
      case 'project':
        return 'work';
      default:
        return 'event';
    }
  }

  void _showQuickScheduleModal(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: QuickScheduleModal(
          selectedDate: date,
          onScheduleSession: _onScheduleSession,
          availableCourses: availableCourses,
        ),
      ),
    );
  }

  void _onScheduleSession(Map<String, dynamic> sessionData) {
    final sessionDate = DateTime(
      (sessionData['date'] as DateTime).year,
      (sessionData['date'] as DateTime).month,
      (sessionData['date'] as DateTime).day,
    );

    setState(() {
      if (scheduleData[sessionDate] == null) {
        scheduleData[sessionDate] = [];
      }
      scheduleData[sessionDate]!.add(sessionData);

      // If it's today, also add to today's schedule
      final today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      if (sessionDate == today) {
        todaySchedule.add(sessionData);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session scheduled successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onSessionStart(Map<String, dynamic> session) {
    final index = todaySchedule.indexWhere((s) => s['id'] == session['id']);
    if (index != -1) {
      setState(() {
        todaySchedule[index]['status'] =
            session['status'] == 'in_progress' ? 'upcoming' : 'in_progress';
      });
    }
  }

  void _onSessionReschedule(Map<String, dynamic> session) {
    _showQuickScheduleModal(DateTime.now());
  }

  void _onSessionComplete(Map<String, dynamic> session) {
    final index = todaySchedule.indexWhere((s) => s['id'] == session['id']);
    if (index != -1) {
      setState(() {
        todaySchedule[index]['status'] = 'completed';
      });
    }
  }

  void _onSuggestionAccept(Map<String, dynamic> suggestion) {
    setState(() {
      aiSuggestions.removeWhere((s) => s['id'] == suggestion['id']);
    });

    // Process the accepted suggestion
    if (suggestion['scheduledTime'] != null) {
      // Auto-schedule the suggested session
      final sessionData = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'courseName': suggestion['title'] as String,
        'type': suggestion['type'] == 'spaced_repetition' ? 'review' : 'lesson',
        'date': DateTime.now(),
        'startTime': (suggestion['scheduledTime'] as String).split(' ').last,
        'endTime':
            '${int.parse((suggestion['scheduledTime'] as String).split(' ').last.split(':')[0]) + 1}:00 ${(suggestion['scheduledTime'] as String).split(' ').last.split(' ')[1]}',
        'duration': 60,
        'description': suggestion['description'] as String,
        'status': 'upcoming',
      };

      _onScheduleSession(sessionData);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Suggestion accepted'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _onSuggestionDismiss(Map<String, dynamic> suggestion) {
    setState(() {
      aiSuggestions.removeWhere((s) => s['id'] == suggestion['id']);
    });
  }

  Future<void> _refreshSchedule() async {
    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Refresh AI suggestions
      _refreshAiSuggestions();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Schedule updated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _refreshAiSuggestions() {
    // Add new AI suggestions
    final newSuggestions = [
      {
        'id': DateTime.now().millisecondsSinceEpoch,
        'type': 'review_session',
        'title': 'Review Data Structures',
        'description':
            'Your last quiz showed some gaps in tree algorithms. A focused review session could help.',
        'scheduledTime': 'Tomorrow 2:00 PM',
      },
    ];

    setState(() {
      aiSuggestions.addAll(newSuggestions);
    });
  }
}
