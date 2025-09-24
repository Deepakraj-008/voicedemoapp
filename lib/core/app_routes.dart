import 'package:flutter/material.dart';
import '../../presentation/home_dashboard/home_dashboard.dart';
import '../../presentation/course_catalog/course_catalog.dart';
import '../../presentation/course_details/course_details.dart';
import '../../presentation/study_schedule/study_schedule.dart';
import '../../presentation/progress_analytics/progress_analytics.dart';
import '../../presentation/profile_settings/profile_settings.dart';
import '../../presentation/voice_assistant_chat/voice_assistant_chat.dart';
import '../../presentation/voice_dashboard/voice_dashboard.dart';
import '../../presentation/ai_assistant_chat/ai_assistant_chat.dart';
// import '../../presentation/ai_live_data_dashboard/ai_dashboard.dart'; // File is empty
import '../../presentation/learning_session/learning_session.dart';
import '../../presentation/voice_onboarding/voice_onboarding.dart';
import '../../presentation/login_screen/login_screen.dart';
import '../../presentation/registration/registration.dart';

// Sports (Crex) imports
import '../../presentation/crex/crex_hub_screen.dart';
import '../../presentation/crex/home_screen.dart';
import '../../presentation/crex/matches_screen.dart';
import '../../presentation/crex/fixtures_screen.dart';
import '../../presentation/crex/series_hub_screen.dart';
import '../../presentation/crex/series_screen.dart';
import '../../presentation/crex/videos_screen.dart';
import '../../presentation/crex/match_detail_screen.dart';

class AppRoutes {
  // Initial route
  static const String initial = '/home';

  // Main app routes
  static const String home = '/home';
  static const String courseCatalog = '/courses';
  static const String courseDetails = '/course-details';
  static const String studySchedule = '/study-schedule';
  static const String progressAnalytics = '/progress-analytics';
  static const String profileSettings = '/profile-settings';

  // Voice & AI routes
  static const String voiceAssistantChat = '/voice-assistant-chat';
  static const String voiceDashboard = '/voice-dashboard';
  static const String aiAssistantChat = '/ai-assistant-chat';
  static const String aiLiveDataDashboard = '/ai-live-dashboard';

  // Learning routes
  static const String learningSession = '/learning-session';
  static const String voiceOnboarding = '/voice-onboarding';

  // Sports routes (Crex)
  static const String crexHub = '/crex';
  static const String crexHome = '/crex/home';
  static const String crexMatches = '/crex/matches';
  static const String crexFixtures = '/crex/fixtures';
  static const String crexSeriesHub = '/crex/series-hub';
  static const String crexSeries = '/crex/series';
  static const String crexVideos = '/crex/videos';
  static const String crexMatchDetail = '/crex/match-detail';

  // Auth routes (to be preserved as per requirements)
  static const String login = '/login';
  static const String registration = '/registration';

  static Map<String, WidgetBuilder> get routes {
    return {
      // Main app routes
      initial: (context) => const HomeDashboard(),
      courseCatalog: (context) => const CourseCatalog(),
      courseDetails: (context) => const CourseDetail(),
      studySchedule: (context) => const StudySchedule(),
      progressAnalytics: (context) => const ProgressAnalytics(),
      profileSettings: (context) => const ProfileSettings(),

      // Voice & AI routes
      voiceAssistantChat: (context) => const VoiceAssistantChat(),
      voiceDashboard: (context) => const VoiceDashboard(),
      aiAssistantChat: (context) => const AIAssistantChat(),
      // aiLiveDataDashboard: (context) => const AiLiveDataDashboard(), // File is empty

      // Learning routes
      learningSession: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return LearningSession(sessionId: args['sessionId'] as String);
      },
      voiceOnboarding: (context) => const VoiceOnboarding(),

      // Auth routes (preserved as per requirements)
      login: (context) => const LoginScreen(),
      registration: (context) => const Registration(),

      // Sports (Crex) routes
      crexHub: (context) => const CrexHubScreen(),
      crexHome: (context) => const CrexHomeScreen(),
      crexMatches: (context) => const CrexMatchesScreen(),
      crexFixtures: (context) => const CrexFixturesScreen(),
      crexSeriesHub: (context) => const CrexSeriesHubScreen(),
      crexSeries: (context) => const CrexSeriesScreen(
            seriesKey: '',
          ),
      crexVideos: (context) => const CrexVideosScreen(),
      crexMatchDetail: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return CrexMatchDetailScreen(matchId: args['matchId'] as String);
      },
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case crexMatchDetail:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CrexMatchDetailScreen(
              matchId: args['matchId'] as String,
            ),
            settings: settings,
          );
        }
        return _errorRoute();
      default:
        return null;
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
