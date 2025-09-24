import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../models/sports_match_model.dart';
import '../../../widgets/urls.dart';

/// Comprehensive sports service handling all sports data
/// with real-time WebSocket connections and 3D animation triggers
class SportsService {
  static final SportsService _instance = SportsService._internal();
  factory SportsService() => _instance;
  SportsService._internal();

  // HTTP client for REST API calls
  final http.Client _httpClient = http.Client();

  // WebSocket connections for real-time updates
  WebSocketChannel? _liveMatchesChannel;
  WebSocketChannel? _matchDetailsChannel;
  WebSocketChannel? _scoreUpdatesChannel;

  // Stream controllers for real-time data
  final StreamController<List<SportsMatch>> _liveMatchesController =
      StreamController<List<SportsMatch>>.broadcast();
  final StreamController<SportsMatch> _matchUpdatesController =
      StreamController<SportsMatch>.broadcast();
  final StreamController<SportsEvent> _matchEventsController =
      StreamController<SportsEvent>.broadcast();
  final StreamController<SportsScore> _scoreUpdatesController =
      StreamController<SportsScore>.broadcast();

  // Getters for streams
  Stream<List<SportsMatch>> get liveMatchesStream =>
      _liveMatchesController.stream;
  Stream<SportsMatch> get matchUpdatesStream => _matchUpdatesController.stream;
  Stream<SportsEvent> get matchEventsStream => _matchEventsController.stream;
  Stream<SportsScore> get scoreUpdatesStream => _scoreUpdatesController.stream;

  /// Fetch live matches across all sports with enhanced filtering
  Future<List<SportsMatch>> fetchLiveMatches({
    String sport = 'all',
    String format = 'all',
    String priority = 'all',
    int limit = 20,
  }) async {
    try {
      final url = Uri.parse(URLS.liveMatches(
        sport: sport,
        format: format,
      ));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final matches = (data['matches'] as List<dynamic>?)
                ?.map((match) => SportsMatch.fromJson(match))
                .toList() ??
            [];

        // Filter by priority if specified
        if (priority != 'all') {
          return matches.where((match) => match.priority == priority).toList();
        }

        return matches.take(limit).toList();
      } else {
        throw Exception('Failed to fetch live matches: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching live matches: $e');
      rethrow;
    }
  }

  /// Fetch upcoming matches with enhanced scheduling
  Future<List<SportsMatch>> fetchUpcomingMatches({
    String sport = 'all',
    int days = 7,
    String priority = 'all',
    int limit = 50,
  }) async {
    try {
      final url = Uri.parse(URLS.upcomingMatches(
        sport: sport,
        days: days,
      ));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final matches = (data['matches'] as List<dynamic>?)
                ?.map((match) => SportsMatch.fromJson(match))
                .toList() ??
            [];

        // Sort by start time and priority
        matches.sort((a, b) {
          // High priority matches first
          if (a.isHighPriority && !b.isHighPriority) return -1;
          if (!a.isHighPriority && b.isHighPriority) return 1;

          // Then by start time
          return a.startTime.compareTo(b.startTime);
        });

        // Filter by priority if specified
        if (priority != 'all') {
          return matches.where((match) => match.priority == priority).toList();
        }

        return matches.take(limit).toList();
      } else {
        throw Exception(
            'Failed to fetch upcoming matches: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching upcoming matches: $e');
      rethrow;
    }
  }

  /// Fetch match details with comprehensive data
  Future<SportsMatch> fetchMatchDetails(String matchId) async {
    try {
      final url = Uri.parse(URLS.matchDetails(matchId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SportsMatch.fromJson(data['match']);
      } else {
        throw Exception(
            'Failed to fetch match details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching match details: $e');
      rethrow;
    }
  }

  /// Fetch live scorecard with real-time updates
  Future<SportsScore> fetchLiveScorecard(String matchId) async {
    try {
      final url = Uri.parse(URLS.liveScorecard(matchId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SportsScore.fromJson(data['scorecard']);
      } else {
        throw Exception('Failed to fetch scorecard: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching scorecard: $e');
      rethrow;
    }
  }

  /// Fetch match commentary with events
  Future<List<SportsEvent>> fetchMatchCommentary(String matchId) async {
    try {
      final url = Uri.parse(URLS.matchCommentary(matchId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['commentary'] as List<dynamic>?)
                ?.map((event) => SportsEvent.fromJson(event))
                .toList() ??
            [];
      } else {
        throw Exception('Failed to fetch commentary: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching commentary: $e');
      rethrow;
    }
  }

  /// Fetch match statistics and analytics
  Future<Map<String, dynamic>> fetchMatchStatistics(String matchId) async {
    try {
      final url = Uri.parse(URLS.matchStatistics(matchId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['statistics'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch statistics: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching statistics: $e');
      rethrow;
    }
  }

  /// Fetch streaming information for live matches
  Future<Map<String, dynamic>> fetchStreamingInfo(String matchId) async {
    try {
      final url = Uri.parse(URLS.matchStreaming(matchId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['streaming'] as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch streaming info: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching streaming info: $e');
      rethrow;
    }
  }

  /// Fetch team details with squad information
  Future<SportsTeam> fetchTeamDetails(String teamId) async {
    try {
      final url = Uri.parse(URLS.teamDetails(teamId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SportsTeam.fromJson(data['team']);
      } else {
        throw Exception('Failed to fetch team details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching team details: $e');
      rethrow;
    }
  }

  /// Fetch player profile and statistics
  Future<SportsPlayer> fetchPlayerProfile(String playerId) async {
    try {
      final url = Uri.parse(URLS.playerProfile(playerId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SportsPlayer.fromJson(data['player']);
      } else {
        throw Exception(
            'Failed to fetch player profile: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching player profile: $e');
      rethrow;
    }
  }

  /// Fetch tournament details with standings
  Future<Map<String, dynamic>> fetchTournamentDetails(
      String tournamentId) async {
    try {
      final url = Uri.parse(URLS.tournamentDetails(tournamentId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['tournament'] as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch tournament details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching tournament details: $e');
      rethrow;
    }
  }

  /// Fetch sports news and updates
  Future<List<Map<String, dynamic>>> fetchSportsNews({
    String sport = 'all',
    int limit = 20,
  }) async {
    try {
      final url = Uri.parse(URLS.sportsNews(
        sport: sport,
        limit: limit,
      ));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['news'] as List<dynamic>?)
                ?.map((news) => news as Map<String, dynamic>)
                .toList() ??
            [];
      } else {
        throw Exception('Failed to fetch sports news: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching sports news: $e');
      rethrow;
    }
  }

  /// Fetch recent matches
  Future<List<SportsMatch>> fetchRecentMatches({
    String sport = 'all',
    int limit = 20,
  }) async {
    try {
      final url = Uri.parse(URLS.recentMatches(sport: sport, limit: limit));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final matches = (data['matches'] as List<dynamic>?)
                ?.map((match) => SportsMatch.fromJson(match))
                .toList() ??
            [];

        return matches.take(limit).toList();
      } else {
        throw Exception(
            'Failed to fetch recent matches: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching recent matches: $e');
      rethrow;
    }
  }

  /// Fetch sports categories
  Future<List<String>> fetchSportsCategories() async {
    try {
      final url = Uri.parse(URLS.sportsCategories);

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categories = (data['categories'] as List<dynamic>?)
                ?.map((c) => c.toString())
                .toList() ??
            [];
        return categories;
      } else {
        throw Exception(
            'Failed to fetch sports categories: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching sports categories: $e');
      rethrow;
    }
  }

  /// Fetch sports standings (generic)
  Future<List<dynamic>> fetchSportsStandings({String tournamentId = ''}) async {
    try {
      final path = tournamentId.isNotEmpty
          ? URLS.tournamentStandings(tournamentId)
          : '${URLS.sportsBase}/standings/';
      final url = Uri.parse(URLS.buildUrl(path));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['standings'] as List<dynamic>? ?? [];
      } else {
        throw Exception(
            'Failed to fetch sports standings: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching sports standings: $e');
      rethrow;
    }
  }

  /// Convenience wrappers to match provider API
  Future<SportsMatch> getMatchDetails(String matchId) async {
    return fetchMatchDetails(matchId);
  }

  Future<SportsScore> getMatchScorecard(String matchId) async {
    return fetchLiveScorecard(matchId);
  }

  Future<List<SportsEvent>> getMatchCommentary(String matchId) async {
    return fetchMatchCommentary(matchId);
  }

  /// Connect to live matches WebSocket for real-time updates
  void connectToLiveMatches({String sport = 'all'}) {
    try {
      // Close existing connection
      _liveMatchesChannel?.sink.close();

      // Create new WebSocket connection
      final wsUrl =
          Uri.parse('ws://your-websocket-server/live-matches?sport=$sport');
      _liveMatchesChannel = IOWebSocketChannel.connect(wsUrl);

      _liveMatchesChannel!.stream.listen(
        (message) {
          try {
            final data = json.decode(message);
            if (data['type'] == 'live_matches_update') {
              final matches = (data['matches'] as List<dynamic>?)
                      ?.map((match) => SportsMatch.fromJson(match))
                      .toList() ??
                  [];
              _liveMatchesController.add(matches);
            }
          } catch (e) {
            debugPrint('Error processing live matches update: $e');
          }
        },
        onError: (error) {
          debugPrint('Live matches WebSocket error: $error');
        },
        onDone: () {
          debugPrint('Live matches WebSocket connection closed');
          // Attempt to reconnect after delay
          Future.delayed(const Duration(seconds: 5), () {
            connectToLiveMatches(sport: sport);
          });
        },
      );
    } catch (e) {
      debugPrint('Error connecting to live matches WebSocket: $e');
    }
  }

  /// Connect to specific match WebSocket for detailed updates
  void connectToMatchDetails(String matchId) {
    try {
      // Close existing connection
      _matchDetailsChannel?.sink.close();

      // Create new WebSocket connection
      final wsUrl = Uri.parse('ws://your-websocket-server/match/$matchId');
      _matchDetailsChannel = IOWebSocketChannel.connect(wsUrl);

      _matchDetailsChannel!.stream.listen(
        (message) {
          try {
            final data = json.decode(message);

            switch (data['type']) {
              case 'match_update':
                final match = SportsMatch.fromJson(data['match']);
                _matchUpdatesController.add(match);
                break;

              case 'match_event':
                final event = SportsEvent.fromJson(data['event']);
                _matchEventsController.add(event);
                break;

              case 'score_update':
                final score = SportsScore.fromJson(data['score']);
                _scoreUpdatesController.add(score);
                break;
            }
          } catch (e) {
            debugPrint('Error processing match update: $e');
          }
        },
        onError: (error) {
          debugPrint('Match details WebSocket error: $error');
        },
        onDone: () {
          debugPrint('Match details WebSocket connection closed');
          // Attempt to reconnect after delay
          Future.delayed(const Duration(seconds: 3), () {
            connectToMatchDetails(matchId);
          });
        },
      );
    } catch (e) {
      debugPrint('Error connecting to match details WebSocket: $e');
    }
  }

  /// Subscribe to match alerts and notifications
  Future<bool> subscribeToMatchAlerts(
      String matchId, List<String> alertTypes) async {
    try {
      final url = Uri.parse(URLS.subscribeAlerts);

      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'match_id': matchId,
          'alert_types': alertTypes,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error subscribing to match alerts: $e');
      return false;
    }
  }

  /// Unsubscribe from match alerts
  Future<bool> unsubscribeFromMatchAlerts(String matchId) async {
    try {
      final url = Uri.parse(URLS.unsubscribeAlerts);

      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'match_id': matchId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error unsubscribing from match alerts: $e');
      return false;
    }
  }

  /// Get match predictions and analytics
  Future<Map<String, dynamic>> fetchMatchPredictions(String matchId) async {
    try {
      final url = Uri.parse(URLS.matchPredictions(matchId));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['predictions'] as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch match predictions: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching match predictions: $e');
      rethrow;
    }
  }

  /// Get head-to-head statistics between two teams
  Future<Map<String, dynamic>> fetchHeadToHead(
      String team1Id, String team2Id) async {
    try {
      final url = Uri.parse(URLS.headToHead(team1Id, team2Id));

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['head_to_head'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch head-to-head: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching head-to-head: $e');
      rethrow;
    }
  }

  /// Clean up resources
  void dispose() {
    _liveMatchesChannel?.sink.close();
    _matchDetailsChannel?.sink.close();
    _scoreUpdatesChannel?.sink.close();

    _liveMatchesController.close();
    _matchUpdatesController.close();
    _matchEventsController.close();
    _scoreUpdatesController.close();

    _httpClient.close();
  }
}
