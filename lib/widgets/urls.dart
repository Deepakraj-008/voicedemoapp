import 'package:flutter/material.dart';

// ===================== URLS =====================
class URLS {
  // For emulator: 10.0.2.2; For real device, pass your PC IP:
  // flutter run --dart-define=API_BASE=http://192.168.1.xx:8003
  static const String baseUrl = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://10.0.2.2:8003',
  );

  static String _v(String path) => "$baseUrl$path";

  // -------- Account APIs --------
  static String deleteAccount = "/api/v1/account/delete/request";
  static String cancelDeleteAccount = "/api/v1/account/delete/cancel";
  static String deleteAccountStatus = "/api/v1/account/delete/status";

  // -------- Auth APIs --------
  static String login = "/api/token/";
  static String tokenRefresh = "/api/token/refresh/";
  static String register = "/api/registration/";
  static String validateEmail = "/api/validate_email/";
  static const String verifyOtp = "/api/verify/";
  static String sendOtp = "/api/registration_otp/";
  static String resetRequestPassword = "/api/password-reset/request-otp/";
  static String resetPassword = "/api/password-reset/reset/";
  static String googleLogin = "/api/auth/google/";

  // -------- Course APIs --------
  static String courseList = "/api/courses/?name=";
  static String subscribedCourseList = "/api/user_courses/";
  static String addCourse = "/api/subscribe/";
  static String deleteCourse(int? courseId) => "/api/unsubscribe/$courseId/";

  // -------- Settings APIs --------
  static String userSettings = "/api/user_settings/";
  static String userSettingsUpdate = "/api/user_settings/";

  // -------- Exam APIs --------
  static String examFilters = "/api/start_exam/";
  static String examFiltersUpdate = "/api/get_user_counters/";
  static String prepareExam = "/api/start_exam/";
  static String validateExam = "/api/submit_exam/";
  static String adaptiveExam = "/adaptive/start/";
  static String preLoadAdaptive = "/adaptive/preload/";

  static String paymentHistory = "/api/v1/payments/history/";

  static String examResults(int? examId) => "/api/exam_result/$examId/";
  static String questionCounters = "/api/get_user_counters/";
  static String examHistory(String? courseId,
          {int page = 1, int pageSize = 20}) =>
      "/api/all_exam_results/?user_course_id=$courseId&page=$page&page_size=$pageSize";
  static String examHistoryDetails(String? testId) =>
      "/api/get_exam_result/$testId/";

  // -------- Sports APIs --------
  static String sportsBase = "/api/sports";
  static String liveMatches({String sport = "all", String format = "all"}) =>
      "$sportsBase/live-matches?sport=$sport&format=$format";
  static String matchDetails(String matchId) => "$sportsBase/matches/$matchId/";
  static String liveScorecard(String matchId) =>
      "$sportsBase/matches/$matchId/scorecard/";
  static String matchCommentary(String matchId) =>
      "$sportsBase/matches/$matchId/commentary/";
  static String matchStatistics(String matchId) =>
      "$sportsBase/matches/$matchId/statistics/";
  static String matchStreaming(String matchId) =>
      "$sportsBase/matches/$matchId/streaming/";
  static String upcomingMatches({String sport = "all", int days = 7}) =>
      "$sportsBase/upcoming-matches?sport=$sport&days=$days";
  static String recentMatches({String sport = "all", int limit = 20}) =>
      "$sportsBase/recent-matches?sport=$sport&limit=$limit";
  static String sportsCategories = "$sportsBase/categories/";
  static String sportsLeagues(String sport) =>
      "$sportsBase/leagues?sport=$sport";
  static String teamDetails(String teamId) => "$sportsBase/teams/$teamId/";
  static String teamSquad(String teamId, String tournamentId) =>
      "$sportsBase/teams/$teamId/squad?tournament=$tournamentId";
  static String playerProfile(String playerId) =>
      "$sportsBase/players/$playerId/";
  static String playerStats(String playerId, {String format = "all"}) =>
      "$sportsBase/players/$playerId/stats?format=$format";
  static String tournamentDetails(String tournamentId) =>
      "$sportsBase/tournaments/$tournamentId/";
  static String tournamentStandings(String tournamentId) =>
      "$sportsBase/tournaments/$tournamentId/standings/";
  static String tournamentSchedule(String tournamentId) =>
      "$sportsBase/tournaments/$tournamentId/schedule/";
  static String matchAlerts = "$sportsBase/alerts/";
  static String subscribeAlerts = "$sportsBase/alerts/subscribe/";
  static String unsubscribeAlerts = "$sportsBase/alerts/unsubscribe/";
  static String sportsNews({String sport = "all", int limit = 20}) =>
      "$sportsBase/news?sport=$sport&limit=$limit";
  static String venueDetails(String venueId) => "$sportsBase/venues/$venueId/";
  static String matchHighlights(String matchId) =>
      "$sportsBase/matches/$matchId/highlights/";
  static String matchVideos(String matchId) =>
      "$sportsBase/matches/$matchId/videos/";
  static String matchPredictions(String matchId) =>
      "$sportsBase/matches/$matchId/predictions/";
  static String headToHead(String team1Id, String team2Id) =>
      "$sportsBase/head-to-head?team1=$team1Id&team2=$team2Id";
  static String fantasyPlayers(String matchId) =>
      "$sportsBase/fantasy/matches/$matchId/players/";
  static String fantasyPoints(String playerId, String matchId) =>
      "$sportsBase/fantasy/players/$playerId/matches/$matchId/points/";

  // -------- Performance APIs --------
  static String coursePerformance = "/api/course_performance/";
  static String pyqCoursePerformance =
      "/api/previous-exams/course-performance/";
  static String coursePerformanceCompare = '/api/course_performance/compare/';
  static String pyqCoursePerformanceCompare =
      '/api/previous-exams/course-performance/compare/';

  // -------- Profile APIs --------
  static String userProfile = "/api/profile_details/";
  static String userProfileUpdate = "/api/profile_details/";

  // -------- Previous Exams APIs --------
  static String previousCourses({
    required int courseSubscriptionId,
    required int page,
    required int totalItems,
  }) =>
      "/api/previous-exams/?course_subscription_id=$courseSubscriptionId&page=$page&total_items=$totalItems";
  static String previousExamResults(int examId,
          {int page = 0, int totalItems = 20}) =>
      "/api/previous-exam-results/?exam_id=$examId&page=$page&total_items=$totalItems";
  static String flashcardCounters(int courseSubscriptionId) =>
      "/api/flashcards/counters/?course_subscription_id=$courseSubscriptionId";
  static const String previousExamStart = '/api/previous-exams/start/';
  static String submitPreviousExam = "/api/previous-exams/submit/";
  static String pyqResults(int? examId) =>
      "/api/previous-exam-results/$examId/";

  // -------- Flashcards APIs --------
  static String flashCardList(
    int? examId,
    int? courseSubscriptionId,
    int? subjectId,
    int? chapterId,
    String? type,
    int? page,
    int? pageSize,
  ) {
    final params = <String, String>{};
    if (courseSubscriptionId != null)
      params['course_subscription_id'] = '$courseSubscriptionId';
    if (subjectId != null) params['subject_id'] = '$subjectId';
    if (chapterId != null) params['chapter_id'] = '$chapterId';
    if (type != null && type.isNotEmpty) params['type'] = type;
    if (page != null) params['page'] = '$page';
    if (pageSize != null) params['page_size'] = '$pageSize';
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return "/api/flashcards/cards/${query.isNotEmpty ? '?$query' : ''}";
  }

  static String flashCardAnswers = "/api/flashcards/answer/";

  // -------- Feedback APIs --------
  static String feedbackReasons = "/api/feedback/reasons/";
  static String sendFeedback = "/api/feedback/";

  // -------- Images Helper --------
  static String parseImage(String? url) {
    if (url == null || url.isEmpty) return "";
    if (url.startsWith('http')) return url;
    return "$baseUrl$url";
  }

  // -------- Config & Cricket APIs --------
  static String appConfig = "/api/app/config";
  static String cricketHome = "/api/sports/cricket/home";
  static String cricketMatches({String status = "live"}) =>
      "/api/sports/cricket/matches?status=$status";

  // -------- AI APIs --------
  static const String AI_MODELS = "/api/ai/models";
  static const String AI_DATASETS = "/api/ai/datasets";
  static const String AI_PAPERS = "/api/ai/papers";
  static const String AI_NEWS = "/api/ai/news";
  static const String AI_COMMUNITY = "/api/ai/community";
  static const String AI_REPOS = "/api/ai/repos";
  static const String AI_DASHBOARD = "/api/ai/dashboard";
  static const String AI_ALL = "/api/ai/all";

  // -------- Builder --------
  static String buildUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return "$baseUrl$path";
  }

  // ===================== NEW FEATURE APIs (from Routes) =====================
  static String splashConfig = "/api/app/splash/";
  static String learningSession = "/api/learning/session/";
  static String studySchedule = "/api/study/schedule/";
  static String homeDashboard = "/api/home/dashboard/";
  static String profileSettings = "/api/profile/settings/";
  static String voiceOnboarding = "/api/voice/onboarding/";
  static String voiceAssistantChat = "/api/voice/chat/";
  static String progressAnalytics = "/api/progress/analytics/";
  static String registrationFlow = "/api/auth/registration-flow/";
  static String voiceDashboard = "/api/voice/dashboard/";
  static String scheduleManager = "/api/schedule/manager/";
  static String courseDetail = "/api/courses/detail/";
  static String courseCatalog = "/api/courses/catalog/";

  // Sports feature APIs (Crex)
  static String crexHub = "/api/sports/crex/";
  static String crexMatch(String matchId) => "/api/sports/crex/match/$matchId/";
  static String crexSeries(String seriesKey) =>
      "/api/sports/crex/series/$seriesKey/";
}
