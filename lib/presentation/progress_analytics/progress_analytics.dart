import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/progress_chart_widget.dart';
import './widgets/progress_stats_card.dart';
import './widgets/skill_radar_chart.dart';
import './widgets/voice_assistant_fab.dart';

class ProgressAnalytics extends StatefulWidget {
  const ProgressAnalytics({super.key});

  @override
  State<ProgressAnalytics> createState() => _ProgressAnalyticsState();
}

class _ProgressAnalyticsState extends State<ProgressAnalytics>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 3;
  bool _isVoiceListening = false;
  String _selectedPeriod = 'This Month';

  // Mock data for progress analytics
  final List<Map<String, dynamic>> _progressStats = [
    {
      "title": "Study Hours",
      "value": "47h",
      "subtitle": "+12h from last month",
      "icon": Icons.schedule,
      "color": AppTheme.primaryLight,
    },
    {
      "title": "Courses Completed",
      "value": "3",
      "subtitle": "2 in progress",
      "icon": Icons.book,
      "color": AppTheme.successLight,
    },
    {
      "title": "Current Streak",
      "value": "12",
      "subtitle": "days in a row",
      "icon": Icons.local_fire_department,
      "color": AppTheme.warningLight,
    },
    {
      "title": "XP Earned",
      "value": "2,450",
      "subtitle": "+340 this week",
      "icon": Icons.stars,
      "color": AppTheme.accentLight,
    },
  ];

  final List<Map<String, dynamic>> _chartData = [
    {"day": "Mon", "hours": 3, "xp": 120},
    {"day": "Tue", "hours": 1, "xp": 80},
    {"day": "Wed", "hours": 4, "xp": 200},
    {"day": "Thu", "hours": 2, "xp": 150},
    {"day": "Fri", "hours": 5, "xp": 250},
    {"day": "Sat", "hours": 3, "xp": 180},
    {"day": "Sun", "hours": 4, "xp": 220},
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      "title": "First Steps",
      "description": "Complete your first course",
      "icon": Icons.flag,
      "color": AppTheme.successLight,
      "isEarned": true,
      "earnedDate": DateTime.now().subtract(const Duration(days: 15)),
    },
    {
      "title": "Code Master",
      "description": "Write 100 lines of code",
      "icon": Icons.code,
      "color": AppTheme.primaryLight,
      "isEarned": true,
      "earnedDate": DateTime.now().subtract(const Duration(days: 8)),
    },
    {
      "title": "Streak King",
      "description": "Maintain 7-day streak",
      "icon": Icons.local_fire_department,
      "color": AppTheme.warningLight,
      "isEarned": true,
      "earnedDate": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "title": "Night Owl",
      "description": "Study after 10 PM",
      "icon": Icons.nightlight,
      "color": AppTheme.secondaryLight,
      "isEarned": false,
      "earnedDate": null,
    },
    {
      "title": "Speed Demon",
      "description": "Complete quiz in under 2 min",
      "icon": Icons.speed,
      "color": AppTheme.accentLight,
      "isEarned": false,
      "earnedDate": null,
    },
    {
      "title": "Perfectionist",
      "description": "Score 100% on 5 quizzes",
      "icon": Icons.star,
      "color": AppTheme.warningLight,
      "isEarned": false,
      "earnedDate": null,
    },
  ];

  final List<Map<String, dynamic>> _skillData = [
    {
      "skill": "JavaScript",
      "level": 8,
      "improvement": 23,
      "description":
          "Strong understanding of ES6+ features, async programming, and DOM manipulation.",
    },
    {
      "skill": "Python",
      "level": 6,
      "improvement": -5,
      "description":
          "Good grasp of basics, need to work on advanced concepts like decorators and metaclasses.",
    },
    {
      "skill": "React",
      "level": 7,
      "improvement": 15,
      "description":
          "Comfortable with hooks, state management, and component lifecycle.",
    },
    {
      "skill": "Node.js",
      "level": 5,
      "improvement": 8,
      "description":
          "Basic server-side development, working on advanced patterns and performance optimization.",
    },
    {
      "skill": "Database",
      "level": 4,
      "improvement": 12,
      "description":
          "Understanding SQL basics, learning NoSQL databases and query optimization.",
    },
  ];

  final List<String> _periods = [
    'This Week',
    'This Month',
    'This Year',
    'All Time'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
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
      appBar: CustomAppBar(
        title: 'Progress Analytics',
        actions: [
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'tune',
              color: colorScheme.onSurface,
              size: 5.w,
            ),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => _periods.map((period) {
              return PopupMenuItem<String>(
                value: period,
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: _selectedPeriod == period
                          ? 'radio_button_checked'
                          : 'radio_button_unchecked',
                      color: _selectedPeriod == period
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(period),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: colorScheme.surface,
            child: CustomTabBar(
              controller: _tabController,
              tabs: const ['Progress', 'Skills', 'Achievements', 'Goals'],
              variant: TabBarVariant.underlined,
              selectedColor: colorScheme.primary,
              unselectedColor: colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: colorScheme.primary,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProgressTab(),
                _buildSkillsTab(),
                _buildAchievementsTab(),
                _buildGoalsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
      floatingActionButton: VoiceAssistantFab(
        isListening: _isVoiceListening,
        onPressed: _toggleVoiceAssistant,
      ),
    );
  }

  Widget _buildProgressTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Progress data updated'),
              backgroundColor: AppTheme.successLight,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _selectedPeriod,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Stats cards
            Wrap(
              spacing: 3.w,
              runSpacing: 2.h,
              children: _progressStats.map((stat) {
                return ProgressStatsCard(
                  title: stat['title'] as String,
                  value: stat['value'] as String,
                  subtitle: stat['subtitle'] as String,
                  icon: stat['icon'] as IconData,
                  iconColor: stat['color'] as Color,
                  onTap: () => _speakStatistic(stat),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),

            // Progress charts
            ProgressChartWidget(
              chartType: 'line',
              chartData: _chartData,
              title: 'Weekly Study Hours',
            ),
            SizedBox(height: 3.h),

            ProgressChartWidget(
              chartType: 'bar',
              chartData: _chartData,
              title: 'Skills Progress',
            ),
            SizedBox(height: 3.h),

            // Voice insights section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'psychology',
                        color: colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'AI Insights',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "You've studied 47 hours this month, completing 3 courses with a 12-day streak. Your JavaScript skills improved 23% this week. Consider reviewing Python basics based on recent quiz scores.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton.icon(
                    onPressed: () => _speakInsights(),
                    icon: CustomIconWidget(
                      iconName: 'volume_up',
                      color: Colors.white,
                      size: 4.w,
                    ),
                    label: const Text('Listen to Insights'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkillRadarChart(skillData: _skillData),
          SizedBox(height: 3.h),
          ProgressChartWidget(
            chartType: 'pie',
            chartData: _chartData,
            title: 'Time Distribution by Language',
          ),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final earnedAchievements =
        _achievements.where((a) => a['isEarned'] as bool).toList();
    final unEarnedAchievements =
        _achievements.where((a) => !(a['isEarned'] as bool)).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Achievement summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.1),
                  colorScheme.secondary.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'emoji_events',
                    color: AppTheme.warningLight,
                    size: 8.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${earnedAchievements.length} Achievements Earned',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${unEarnedAchievements.length} more to unlock',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Earned achievements
          if (earnedAchievements.isNotEmpty) ...[
            Text(
              'Earned Achievements',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 3.w,
              runSpacing: 2.h,
              children: earnedAchievements.map((achievement) {
                return AchievementBadgeWidget(
                  title: achievement['title'] as String,
                  description: achievement['description'] as String,
                  icon: achievement['icon'] as IconData,
                  badgeColor: achievement['color'] as Color,
                  isEarned: achievement['isEarned'] as bool,
                  earnedDate: achievement['earnedDate'] as DateTime?,
                  onTap: () => _speakAchievement(achievement),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
          ],

          // Locked achievements
          if (unEarnedAchievements.isNotEmpty) ...[
            Text(
              'Locked Achievements',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 3.w,
              runSpacing: 2.h,
              children: unEarnedAchievements.map((achievement) {
                return AchievementBadgeWidget(
                  title: achievement['title'] as String,
                  description: achievement['description'] as String,
                  icon: achievement['icon'] as IconData,
                  badgeColor: achievement['color'] as Color,
                  isEarned: achievement['isEarned'] as bool,
                  earnedDate: achievement['earnedDate'] as DateTime?,
                  onTap: () => _speakAchievement(achievement),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildGoalsTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> goals = [
      {
        "title": "Complete React Course",
        "description": "Finish all 12 modules of the React fundamentals course",
        "progress": 0.75,
        "target": "Dec 31, 2024",
        "icon": Icons.school,
        "color": AppTheme.primaryLight,
      },
      {
        "title": "30-Day Streak",
        "description": "Study for 30 consecutive days",
        "progress": 0.4,
        "target": "Jan 15, 2025",
        "icon": Icons.local_fire_department,
        "color": AppTheme.warningLight,
      },
      {
        "title": "Master JavaScript",
        "description": "Achieve level 10 proficiency in JavaScript",
        "progress": 0.8,
        "target": "Feb 1, 2025",
        "icon": Icons.code,
        "color": AppTheme.accentLight,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add new goal button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: InkWell(
              onTap: () => _showAddGoalDialog(),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add',
                    color: colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Set New Goal',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Current goals
          Text(
            'Current Goals',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 2.h),

          ...goals.map((goal) {
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:
                              (goal['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName:
                              (goal['icon'] as IconData).codePoint.toString(),
                          color: goal['color'] as Color,
                          size: 5.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal['title'] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                                fontSize: 14.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Target: ${goal['target']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${((goal['progress'] as double) * 100).toInt()}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: goal['color'] as Color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    goal['description'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  LinearProgressIndicator(
                    value: goal['progress'] as double,
                    backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(goal['color'] as Color),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  void _toggleVoiceAssistant() {
    setState(() {
      _isVoiceListening = !_isVoiceListening;
    });

    if (_isVoiceListening) {
      _startVoiceRecognition();
    } else {
      _stopVoiceRecognition();
    }
  }

  void _startVoiceRecognition() {
    // Simulate voice recognition start
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice assistant is listening...'),
        backgroundColor: AppTheme.accentLight,
        duration: const Duration(seconds: 2),
      ),
    );

    // Auto-stop after 5 seconds for demo
    Future.delayed(const Duration(seconds: 5), () {
      if (_isVoiceListening) {
        setState(() {
          _isVoiceListening = false;
        });
        _processVoiceCommand("explain my performance graph");
      }
    });
  }

  void _stopVoiceRecognition() {
    // Simulate voice recognition stop
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice assistant stopped listening'),
        backgroundColor: AppTheme.warningLight,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _processVoiceCommand(String command) {
    String response = '';

    if (command.toLowerCase().contains('performance') ||
        command.toLowerCase().contains('graph')) {
      response =
          'Your performance shows steady improvement with 47 study hours this month. You completed 3 courses and maintained a 12-day streak.';
    } else if (command.toLowerCase().contains('skills')) {
      response =
          'Your JavaScript skills improved 23% this week, while Python needs attention with a 5% decline. Focus on Python basics for better results.';
    } else if (command.toLowerCase().contains('achievements')) {
      response =
          'You have earned 3 achievements: First Steps, Code Master, and Streak King. 3 more achievements are waiting to be unlocked.';
    } else {
      response =
          'I can help you understand your progress, skills, and achievements. Try asking about your performance graph or skill improvements.';
    }

    _showVoiceResponse(response);
  }

  void _showVoiceResponse(String response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'psychology',
              color: Theme.of(context).colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            const Text('AI Assistant'),
          ],
        ),
        content: Text(response),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Simulate TTS
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Speaking response...'),
                  backgroundColor: AppTheme.accentLight,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'volume_up',
              color: Colors.white,
              size: 4.w,
            ),
            label: const Text('Listen'),
          ),
        ],
      ),
    );
  }

  void _speakStatistic(Map<String, dynamic> stat) {
    final message = '${stat['title']}: ${stat['value']}. ${stat['subtitle']}.';
    _showVoiceResponse(message);
  }

  void _speakInsights() {
    const insights =
        "You've studied 47 hours this month, completing 3 courses with a 12-day streak. Your JavaScript skills improved 23% this week. Consider reviewing Python basics based on recent quiz scores.";
    _showVoiceResponse(insights);
  }

  void _speakAchievement(Map<String, dynamic> achievement) {
    final isEarned = achievement['isEarned'] as bool;
    final message = isEarned
        ? 'Achievement unlocked: ${achievement['title']}. ${achievement['description']}. Earned ${_formatEarnedDate(achievement['earnedDate'] as DateTime?)}.'
        : 'Locked achievement: ${achievement['title']}. ${achievement['description']}. Complete the requirements to unlock this badge.';
    _showVoiceResponse(message);
  }

  String _formatEarnedDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '${difference} days ago';
    } else {
      return 'on ${date.month}/${date.day}/${date.year}';
    }
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set New Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g., Complete Python Course',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your goal...',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Target Date',
                hintText: 'MM/DD/YYYY',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Goal created successfully!'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: const Text('Create Goal'),
          ),
        ],
      ),
    );
  }
}
