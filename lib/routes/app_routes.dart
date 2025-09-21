import 'package:flutter/material.dart';
import '../presentation/progress_analytics/progress_analytics.dart';
import '../presentation/registration/registration.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/voice_dashboard/voice_dashboard.dart';
import '../presentation/schedule_manager/schedule_manager.dart';

import '../presentation/login_screen/login_screen.dart';
import '../presentation/course_catalog/course_catalog.dart';



import 'package:flutter/material.dart';
import '../presentation/learning_session/learning_session.dart';
import '../presentation/study_schedule/study_schedule.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/voice_onboarding/voice_onboarding.dart';
import '../presentation/voice_assistant_chat/voice_assistant_chat.dart';


class AppRoutes {
  // TODO: Add your routes here
    // TODO: Add your routes here
  static const String initial = '/';
  static const String learningSession = '/learning-session';
  static const String studySchedule = '/study-schedule';
  static const String homeDashboard = '/home-dashboard';
  static const String profileSettings = '/profile-settings';
  static const String voiceOnboarding = '/voice-onboarding';
  static const String voiceAssistantChat = '/voice-assistant-chat';
  static const String progressAnalytics = '/progress-analytics';
  static const String registration = '/registration';
  static const String splash = '/splash-screen';
  static const String voiceDashboard = '/voice-dashboard';
  static const String scheduleManager = '/schedule-manager';
  static const String courseDetail = '/course-detail';
  
  static const String login = '/login-screen';
  static const String courseCatalog = '/course-catalog';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
     voiceOnboarding: (context) => const VoiceOnboarding(),
      login: (context) => const LoginScreen(),
    courseCatalog: (context) => const CourseCatalog(),
    learningSession: (context) => const LearningSession(),
    studySchedule: (context) => const StudySchedule(),
    homeDashboard: (context) => const HomeDashboard(),
    profileSettings: (context) => const ProfileSettings(),
    voiceAssistantChat: (context) => const VoiceAssistantChat(),
    // TODO: Add your other routes here
    progressAnalytics: (context) => const ProgressAnalytics(),
    registration: (context) => const Registration(),
    splash: (context) => const SplashScreen(),
    voiceDashboard: (context) => const VoiceDashboard(),
    scheduleManager: (context) => const ScheduleManager(),
    courseDetail: (context) => const CourseDetail(),
    // TODO: Add your other routes here
  };
}

