class CrexConstants {
  // API Endpoints
  static const String matchesEndpoint = '/matches';
  static const String seriesEndpoint = '/series';
  static const String fixturesEndpoint = '/fixtures';
  static const String videosEndpoint = '/videos';

  // Match Status
  static const String liveStatus = 'LIVE';
  static const String upcomingStatus = 'UPCOMING';
  static const String completedStatus = 'COMPLETED';

  // Match Types
  static const String testMatch = 'TEST';
  static const String odiMatch = 'ODI';
  static const String t20Match = 'T20';
  static const String iplMatch = 'IPL';

  // Cache Keys
  static const String matchesCacheKey = 'crex_matches';
  static const String seriesCacheKey = 'crex_series';
  static const String fixturesCacheKey = 'crex_fixtures';

  // Image Assets
  static const String asiaCupBanner = 'assets/crex/banner_asia_cup.jpg';

  // Default Values
  static const int defaultPageSize = 20;
  static const int defaultCacheDuration = 300; // 5 minutes in seconds
}
