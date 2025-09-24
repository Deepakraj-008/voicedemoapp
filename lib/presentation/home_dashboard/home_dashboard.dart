import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sweetyai_learning_assistant/core/app_routes.dart' show AppRoutes;

import '../../core/app_export.dart';
import './widgets/branded_header_widget.dart';
import './widgets/progress_overview_card.dart';
import './widgets/quick_action_card.dart';
import './widgets/recent_achievements_card.dart';
import './widgets/today_schedule_card.dart';
import './widgets/voice_assistant_button.dart';
import './widgets/voice_waveform_widget.dart';
import './widgets/features_grid.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isVoiceListening = false;
  bool _showVoiceWaveform = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data
  final List<Map<String, dynamic>> _todaySchedule = [
    {
      "id": 1,
      "title": "Flutter Widgets Deep Dive",
      "time": "10:00 AM",
      "duration": "45 min",
      "status": "Upcoming",
      "type": "lesson",
    },
    {
      "id": 2,
      "title": "State Management Quiz",
      "time": "2:30 PM",
      "duration": "20 min",
      "status": "Upcoming",
      "type": "quiz",
    },
    {
      "id": 3,
      "title": "Dart Fundamentals Review",
      "time": "4:00 PM",
      "duration": "30 min",
      "status": "Completed",
      "type": "lesson",
    },
  ];

  final Map<String, dynamic> _progressData = {
    "courseProgress": 0.68,
    "streakDays": 12,
    "masteryScore": 0.85,
    "weeklyProgress": 8.5,
    "weeklyGoal": 12.0,
  };

  final List<Map<String, dynamic>> _quickActions = [
    {
      "id": 1,
      "title": "Schedule Study",
      "subtitle": "Plan your time",
      "icon": "schedule",
      "type": "schedule",
      "voiceCommand": "Schedule study time",
    },
    {
      "id": 2,
      "title": "Take Quiz",
      "subtitle": "Test knowledge",
      "icon": "quiz",
      "type": "quiz",
      "voiceCommand": "Take quiz",
    },
    {
      "id": 3,
      "title": "Ask Question",
      "subtitle": "Get help",
      "icon": "help_outline",
      "type": "question",
      "voiceCommand": "Ask question",
    },
    {
      "id": 4,
      "title": "Practice Code",
      "subtitle": "Hands-on coding",
      "icon": "code",
      "type": "practice",
      "voiceCommand": "Start practice",
    },
  ];

  final List<Map<String, dynamic>> _recentAchievements = [
    {
      "id": 1,
      "title": "12 Day Streak",
      "icon": "local_fire_department",
      "type": "streak",
      "earnedAt": "2025-09-21",
    },
    {
      "id": 2,
      "title": "Quiz Master",
      "icon": "quiz",
      "type": "mastery",
      "earnedAt": "2025-09-20",
    },
    {
      "id": 3,
      "title": "Perfect Score",
      "icon": "star",
      "type": "perfect",
      "earnedAt": "2025-09-19",
    },
    {
      "id": 4,
      "title": "Course Complete",
      "icon": "school",
      "type": "completion",
      "earnedAt": "2025-09-18",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        // Update data here in real implementation
      });
    }
  }

  void _toggleVoiceListening() {
    setState(() {
      _isVoiceListening = !_isVoiceListening;
      if (_isVoiceListening) {
        _showVoiceWaveform = true;
        // In real implementation, start voice recognition here
        _simulateVoiceActivation();
      } else {
        _showVoiceWaveform = false;
        // In real implementation, stop voice recognition here
      }
    });
  }

  void _simulateVoiceActivation() {
    // Simulate "Hello Sweety" detection
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isVoiceListening) {
        setState(() {
          _showVoiceWaveform = true;
        });
        // Navigate to voice assistant chat
        Navigator.pushNamed(context, '/voice-assistant-chat');
      }
    });
  }

  void _onScheduleItemTap(Map<String, dynamic> item) {
    if ((item["status"] as String).toLowerCase() == "upcoming") {
      // Navigate to learning session
      Navigator.pushNamed(context, '/learning-session');
    }
  }

  void _onScheduleItemLongPress(Map<String, dynamic> item) {
    _showScheduleContextMenu(item);
  }

  void _showScheduleContextMenu(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(0.25.h),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                item["title"] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              SizedBox(height: 3.h),
              _buildContextMenuItem(
                icon: 'schedule',
                title: 'Reschedule',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/study-schedule');
                },
              ),
              _buildContextMenuItem(
                icon: 'skip_next',
                title: 'Skip',
                onTap: () {
                  Navigator.pop(context);
                  // Handle skip logic
                },
              ),
              _buildContextMenuItem(
                icon: 'check_circle',
                title: 'Mark Complete',
                onTap: () {
                  Navigator.pop(context);
                  // Handle mark complete logic
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(2.w),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.textSecondaryLight,
                size: 5.w,
              ),
              SizedBox(width: 4.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQuickActionTap(Map<String, dynamic> action) {
    final actionType = action["type"] as String;
    switch (actionType.toLowerCase()) {
      case 'schedule':
        Navigator.pushNamed(context, '/study-schedule');
        break;
      case 'quiz':
        Navigator.pushNamed(context, '/learning-session');
        break;
      case 'question':
        Navigator.pushNamed(context, '/voice-assistant-chat');
        break;
      case 'practice':
        Navigator.pushNamed(context, '/learning-session');
        break;
    }
  }

  void _onWaveformTap() {
    Navigator.pushNamed(context, '/voice-assistant-chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              BrandedHeaderWidget(
                userName: "Alex",
                isVoiceListening: _isVoiceListening,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      child: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: "Home"),
                          Tab(text: "Courses"),
                          Tab(text: "Schedule"),
                          Tab(text: "Profile"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildNewHomeTab(),
                          _buildPlaceholderTab("Courses"),
                          _buildPlaceholderTab("Schedule"),
                          _buildPlaceholderTab("Profile"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showVoiceWaveform)
            Positioned(
              top: 35.h,
              left: 20.w,
              child: VoiceWaveformWidget(
                isActive: _showVoiceWaveform,
                onTap: _onWaveformTap,
              ),
            ),
          VoiceAssistantButton(
            isListening: _isVoiceListening,
            onPressed: _toggleVoiceListening,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildHomeTab() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            TodayScheduleCard(
              scheduleItems: _todaySchedule,
              onItemTap: _onScheduleItemTap,
              onItemLongPress: _onScheduleItemLongPress,
            ),
            ProgressOverviewCard(
              progressData: _progressData,
            ),
            QuickActionCard(
              actions: _quickActions,
              onActionTap: _onQuickActionTap,
            ),
            RecentAchievementsCard(
              achievements: _recentAchievements,
            ),
            SizedBox(height: 25.h), // Space for floating button
          ],
        ),
      ),
    );
  }

  Widget _buildNewHomeTab() {
    // Feature list — these navigate to existing routes in the app
    final features = <FeatureItem>[
      FeatureItem(
        id: 'courses',
        title: 'Courses',
        subtitle: 'Browse & continue learning',
        lottieAsset: 'assets/crex/img_app_logo.svg',
        fallbackIcon: Icons.school,
        onTap: () => Navigator.pushNamed(context, AppRoutes.courseCatalog),
      ),
      FeatureItem(
        id: 'schedule',
        title: 'Study Schedule',
        subtitle: 'Plan your sessions',
        lottieAsset: 'assets/crex/banner_asia_cup.jpg',
        fallbackIcon: Icons.schedule,
        onTap: () => Navigator.pushNamed(context, AppRoutes.studySchedule),
      ),
      FeatureItem(
        id: 'live',
        title: 'Voice Assistant',
        subtitle: 'Talk to Sweety',
        lottieAsset: 'assets/crex/img_app_logo.svg',
        fallbackIcon: Icons.mic,
        onTap: () => Navigator.pushNamed(context, AppRoutes.voiceAssistantChat),
      ),
      FeatureItem(
        id: 'crex',
        title: 'Sports Hub',
        subtitle: 'Live scores & matches',
        lottieAsset: 'assets/crex/banner_asia_cup.jpg',
        fallbackIcon: Icons.sports,
        onTap: () => Navigator.pushNamed(context, AppRoutes.crexHub),
      ),
      FeatureItem(
        id: 'analytics',
        title: 'Progress',
        subtitle: 'Track your growth',
        lottieAsset: 'assets/crex/img_app_logo.svg',
        fallbackIcon: Icons.insights,
        onTap: () => Navigator.pushNamed(context, AppRoutes.progressAnalytics),
      ),
      FeatureItem(
        id: 'voice_dash',
        title: 'Voice Dashboard',
        subtitle: 'Sessions & recordings',
        lottieAsset: 'assets/crex/img_app_logo.svg',
        fallbackIcon: Icons.mic_none,
        onTap: () => Navigator.pushNamed(context, AppRoutes.voiceDashboard),
      ),
    ];

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Features',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FeaturesGrid(features: features),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Quick Actions',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            QuickActionCard(
                actions: _quickActions, onActionTap: _onQuickActionTap),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recent Achievements',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            RecentAchievementsCard(achievements: _recentAchievements),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.textSecondaryLight,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            "$tabName Coming Soon",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "This feature is under development",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textDisabledLight,
            ),
          ),
        ],
      ),
    );
  }
}
