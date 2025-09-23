import 'package:flutter/material.dart';
import '../../presentation/crex/crex_hub_screen.dart';
import '../../presentation/crex/home_screen.dart';
import '../../presentation/crex/matches_screen.dart';
import '../../presentation/crex/fixtures_screen.dart';
import '../../presentation/crex/series_hub_screen.dart';
import '../../presentation/crex/series_screen.dart';
import '../../presentation/crex/videos_screen.dart';
import '../../presentation/crex/match_detail_screen.dart';

class AppRoutes {
  static const String initial = '/crex';
  static const String crexHub = '/crex';
  static const String crexHome = '/crex/home';
  static const String crexMatches = '/crex/matches';
  static const String crexFixtures = '/crex/fixtures';
  static const String crexSeriesHub = '/crex/series-hub';
  static const String crexSeries = '/crex/series';
  static const String crexVideos = '/crex/videos';
  static const String crexMatchDetail = '/crex/match-detail';

  static Map<String, WidgetBuilder> get routes {
    return {
      crexHub: (context) => const CrexHubScreen(),
      crexHome: (context) => const CrexHomeScreen(),
      crexMatches: (context) => const CrexMatchesScreen(),
      crexFixtures: (context) => const CrexFixturesScreen(),
      crexSeriesHub: (context) => const CrexSeriesHubScreen(),
      crexSeries: (context) => const CrexSeriesScreen(seriesKey: '',),
      crexVideos: (context) => const CrexVideosScreen(),
      crexMatchDetail: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return CrexMatchDetailScreen(
          matchId: args['matchId'] as String,
        );
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
