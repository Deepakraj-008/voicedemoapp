import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievements_banner_widget.dart';
import './widgets/continue_learning_card_widget.dart';
import './widgets/greeting_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/voice_assistant_widget.dart';

class VoiceDashboard extends StatefulWidget {
  const VoiceDashboard({super.key});

  @override
  State<VoiceDashboard> createState() => _VoiceDashboardState();
}

class _VoiceDashboardState extends State<VoiceDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isListening = false;
  bool _isRefreshing = false;
  int _currentTabIndex = 0;

  // Mock user data
  final String _userName = "Alex";
  final int _streakDays = 12;
  final int _xpPoints = 2450;
  final String _todayGoal = "Complete Python Functions Module";

  // Mock course data
  final String _currentCourse = "Python Programming Fundamentals";
  final String _courseImage =
      "https://images.unsplash.com/photo-1526379095098-d400fd0bf935?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3";
  final double _courseProgress = 0.68;
  final String _nextSession = "Functions & Parameters - 25 min";

  // Mock achievements data
  final List<Map<String, dynamic>> _recentAchievements = [
    {
      "title": "Week Warrior",
      "description": "Completed 7 days of consistent learning",
      "icon": "local_fire_department",
      "type": "streak",
      "earnedDate": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "title": "Python Basics Master",
      "description": "Finished all basic Python concepts",
      "icon": "school",
      "type": "completion",
      "earnedDate": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "title": "Code Explorer",
      "description": "Wrote your first 100 lines of code",
      "icon": "code",
      "type": "milestone",
      "earnedDate": DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
        _handleTabNavigation(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabNavigation(int index) {
    switch (index) {
      case 0:
        // Dashboard - current screen
        break;
      case 1:
        Navigator.pushNamed(context, '/course-catalog');
        break;
      case 2:
        Navigator.pushNamed(context, '/study-schedule');
        break;
      case 3:
        Navigator.pushNamed(context, '/progress-analytics');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile-settings');
        break;
    }
  }

  void _toggleVoiceAssistant() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Start voice recognition
      _startVoiceRecognition();
    } else {
      // Stop voice recognition
      _stopVoiceRecognition();
    }
  }

  void _startVoiceRecognition() {
    // Voice recognition implementation would go here
    // For now, simulate listening for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    });
  }

  void _stopVoiceRecognition() {
    // Stop voice recognition implementation
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      // Voice confirmation of refresh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Learning data updated successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resumeLearning() {
    Navigator.pushNamed(context, '/course-detail');
  }

  void _voiceResumeLearning() {
    setState(() {
      _isListening = true;
    });

    // Simulate voice command processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
        _resumeLearning();
      }
    });
  }

  void _startNewCourse() {
    Navigator.pushNamed(context, '/course-detail');
  }

  void _takeQuiz() {
    // Navigate to quiz screen (not implemented)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _reviewFlashcards() {
    // Navigate to flashcards screen (not implemented)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Flashcards feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _checkSchedule() {
    Navigator.pushNamed(context, '/schedule-manager');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'VoiceLearn AI',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Row(
              children: [
                if (_isListening)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'mic',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Listening...',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(width: 2.w),
                IconButton(
                  onPressed: () {
                    // Navigate to notifications (not implemented)
                  },
                  icon: CustomIconWidget(
                    iconName: 'notifications_outlined',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
          indicatorWeight: 3,
          labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle:
              AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Courses'),
            Tab(text: 'Schedule'),
            Tab(text: 'Progress'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.lightTheme.colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  GreetingCardWidget(
                    userName: _userName,
                    streakDays: _streakDays,
                    xpPoints: _xpPoints,
                    todayGoal: _todayGoal,
                  ),
                  SizedBox(height: 2.h),
                  ContinueLearningCardWidget(
                    courseName: _currentCourse,
                    courseImage: _courseImage,
                    progress: _courseProgress,
                    nextSession: _nextSession,
                    onResume: _resumeLearning,
                    onVoiceResume: _voiceResumeLearning,
                  ),
                  SizedBox(height: 2.h),
                  QuickActionsWidget(
                    onStartNewCourse: _startNewCourse,
                    onTakeQuiz: _takeQuiz,
                    onReviewFlashcards: _reviewFlashcards,
                    onCheckSchedule: _checkSchedule,
                  ),
                  SizedBox(height: 2.h),
                  AchievementsBannerWidget(
                    recentAchievements: _recentAchievements,
                  ),
                  SizedBox(height: 25.h), // Space for floating voice assistant
                ],
              ),
            ),
          ),
          VoiceAssistantWidget(
            isListening: _isListening,
            onTap: _toggleVoiceAssistant,
          ),
          if (_isRefreshing)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Updating learning data...',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
