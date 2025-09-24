import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import '../models/sports_match_model.dart';
import '../services/sports_service.dart';

/// Main sports provider that manages all sports data and state
final sportsProvider =
    StateNotifierProvider<SportsNotifier, SportsState>((ref) {
  return SportsNotifier(ref.read(sportsServiceProvider));
});

/// Provider for sports service
final sportsServiceProvider = Provider<SportsService>((ref) {
  return SportsService();
});

/// Provider for live matches only
final liveMatchesProvider = Provider<List<SportsMatch>>((ref) {
  return ref.watch(sportsProvider).filteredLiveMatches;
});

/// Provider for upcoming matches only
final upcomingMatchesProvider = Provider<List<SportsMatch>>((ref) {
  return ref.watch(sportsProvider).filteredUpcomingMatches;
});

/// Provider for recent matches only
final recentMatchesProvider = Provider<List<SportsMatch>>((ref) {
  return ref.watch(sportsProvider).filteredRecentMatches;
});

/// Provider for sports categories
final sportsCategoriesProvider = Provider<List<String>>((ref) {
  return ref.watch(sportsProvider).sportsCategories;
});

/// Provider for selected sport filter
final selectedSportProvider = StateProvider<String>((ref) {
  return 'all';
});

/// Provider for selected format filter
final selectedFormatProvider = StateProvider<String>((ref) {
  return 'all';
});

/// Provider for selected priority filter
final selectedPriorityProvider = StateProvider<String>((ref) {
  return 'all';
});

/// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) {
  return '';
});

/// Provider for WebSocket connection state
final websocketStateProvider = StateProvider<WebsocketState>((ref) {
  return WebsocketState.disconnected;
});

/// Provider for real-time match updates
final matchUpdatesProvider = StreamProvider<SportsMatch>((ref) {
  final sportsService = ref.read(sportsServiceProvider);
  return sportsService.matchUpdatesStream;
});

/// Provider for match alerts
final matchAlertsProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});

/// Sports notifier that manages all sports data and business logic
class SportsNotifier extends StateNotifier<SportsState> {
  final SportsService _sportsService;
  WebSocketChannel? _webSocketChannel;
  Timer? _refreshTimer;
  Timer? _websocketReconnectTimer;

  SportsNotifier(this._sportsService) : super(SportsState.initial()) {
    _initializeSportsData();
  }

  /// Initialize sports data and start background services
  Future<void> _initializeSportsData() async {
    try {
      // Load initial data
      await loadSportsCategories();
      await loadLiveMatches();
      await loadUpcomingMatches();
      await loadRecentMatches();
      await loadSportsNews();
      await loadSportsStandings();

      // Start WebSocket connection
      await connectWebSocket();

      // Start refresh timer
      _startRefreshTimer();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to initialize sports data: $e',
        isLoading: false,
      );
    }
  }

  /// Load live matches from API
  Future<void> loadLiveMatches() async {
    try {
      state = state.copyWith(isLoadingLiveMatches: true, error: null);

      final matches = await _sportsService.fetchLiveMatches();

      state = state.copyWith(
        liveMatches: matches,
        filteredLiveMatches: matches,
        isLoadingLiveMatches: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingLiveMatches: false,
        error: 'Failed to load live matches: $e',
      );
    }
  }

  /// Load upcoming matches from API
  Future<void> loadUpcomingMatches() async {
    try {
      state = state.copyWith(isLoadingUpcomingMatches: true, error: null);

      final matches = await _sportsService.fetchUpcomingMatches();

      state = state.copyWith(
        upcomingMatches: matches,
        filteredUpcomingMatches: matches,
        isLoadingUpcomingMatches: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingUpcomingMatches: false,
        error: 'Failed to load upcoming matches: $e',
      );
    }
  }

  /// Load recent matches from API
  Future<void> loadRecentMatches() async {
    try {
      state = state.copyWith(isLoadingRecentMatches: true, error: null);

      final matches = await _sportsService.fetchRecentMatches();

      state = state.copyWith(
        recentMatches: matches,
        filteredRecentMatches: matches,
        isLoadingRecentMatches: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingRecentMatches: false,
        error: 'Failed to load recent matches: $e',
      );
    }
  }

  /// Load sports categories
  Future<void> loadSportsCategories() async {
    try {
      final categories = await _sportsService.fetchSportsCategories();

      state = state.copyWith(
        sportsCategories: ['all', ...categories],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load sports categories: $e',
      );
    }
  }

  /// Load sports news
  Future<void> loadSportsNews() async {
    try {
      state = state.copyWith(isLoadingNews: true, error: null);

      final news = await _sportsService.fetchSportsNews();

      state = state.copyWith(
        sportsNews: news,
        isLoadingNews: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingNews: false,
        error: 'Failed to load sports news: $e',
      );
    }
  }

  /// Load sports standings
  Future<void> loadSportsStandings() async {
    try {
      state = state.copyWith(isLoadingStandings: true, error: null);

      final standings = await _sportsService.fetchSportsStandings();

      state = state.copyWith(
        sportsStandings: standings,
        isLoadingStandings: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingStandings: false,
        error: 'Failed to load sports standings: $e',
      );
    }
  }

  /// Filter matches based on sport, format, and priority
  void filterMatches({
    String? sport,
    String? format,
    String? priority,
  }) {
    // Filter live matches
    var filteredLive = state.liveMatches.where((match) {
      bool matches = true;

      if (sport != null && sport != 'all') {
        matches = matches && match.sport.toLowerCase() == sport.toLowerCase();
      }

      if (format != null && format != 'all') {
        matches = matches && match.format.toLowerCase() == format.toLowerCase();
      }

      if (priority != null && priority != 'all') {
        matches =
            matches && match.priority.toLowerCase() == priority.toLowerCase();
      }

      return matches;
    }).toList();

    // Filter upcoming matches
    var filteredUpcoming = state.upcomingMatches.where((match) {
      bool matches = true;

      if (sport != null && sport != 'all') {
        matches = matches && match.sport.toLowerCase() == sport.toLowerCase();
      }

      if (format != null && format != 'all') {
        matches = matches && match.format.toLowerCase() == format.toLowerCase();
      }

      if (priority != null && priority != 'all') {
        matches =
            matches && match.priority.toLowerCase() == priority.toLowerCase();
      }

      return matches;
    }).toList();

    // Filter recent matches
    var filteredRecent = state.recentMatches.where((match) {
      bool matches = true;

      if (sport != null && sport != 'all') {
        matches = matches && match.sport.toLowerCase() == sport.toLowerCase();
      }

      if (format != null && format != 'all') {
        matches = matches && match.format.toLowerCase() == format.toLowerCase();
      }

      if (priority != null && priority != 'all') {
        matches =
            matches && match.priority.toLowerCase() == priority.toLowerCase();
      }

      return matches;
    }).toList();

    state = state.copyWith(
      filteredLiveMatches: filteredLive,
      filteredUpcomingMatches: filteredUpcoming,
      filteredRecentMatches: filteredRecent,
    );
  }

  /// Search matches by title, teams, or venue
  void searchMatches(String query) {
    if (query.isEmpty) {
      // Reset filters
      filterMatches();
      return;
    }

    final searchQuery = query.toLowerCase();

    // Search live matches
    var filteredLive = state.liveMatches.where((match) {
      return match.tournament.toLowerCase().contains(searchQuery) ||
          match.teams
              .any((team) => team.name.toLowerCase().contains(searchQuery)) ||
          match.venue.toLowerCase().contains(searchQuery) ||
          match.league.toLowerCase().contains(searchQuery);
    }).toList();

    // Search upcoming matches
    var filteredUpcoming = state.upcomingMatches.where((match) {
      return match.tournament.toLowerCase().contains(searchQuery) ||
          match.teams
              .any((team) => team.name.toLowerCase().contains(searchQuery)) ||
          match.venue.toLowerCase().contains(searchQuery) ||
          match.league.toLowerCase().contains(searchQuery);
    }).toList();

    // Search recent matches
    var filteredRecent = state.recentMatches.where((match) {
      return match.tournament.toLowerCase().contains(searchQuery) ||
          match.teams
              .any((team) => team.name.toLowerCase().contains(searchQuery)) ||
          match.venue.toLowerCase().contains(searchQuery) ||
          match.league.toLowerCase().contains(searchQuery);
    }).toList();

    state = state.copyWith(
      filteredLiveMatches: filteredLive,
      filteredUpcomingMatches: filteredUpcoming,
      filteredRecentMatches: filteredRecent,
    );
  }

  /// Connect to WebSocket for real-time updates
  Future<void> connectWebSocket() async {
    try {
      state = state.copyWith(websocketState: WebsocketState.connecting);

      // Listen to match updates stream
      _sportsService.matchUpdatesStream.listen(
        (match) {
          _handleMatchUpdate(match);
        },
        onError: (error) {
          state = state.copyWith(
            websocketState: WebsocketState.error,
            error: 'WebSocket error: $error',
          );
          _scheduleWebSocketReconnect();
        },
      );

      // Listen to score updates stream
      _sportsService.scoreUpdatesStream.listen(
        (score) {
          _handleScoreUpdate(score);
        },
        onError: (error) {
          state = state.copyWith(
            websocketState: WebsocketState.error,
            error: 'WebSocket error: $error',
          );
        },
      );

      state = state.copyWith(websocketState: WebsocketState.connected);
    } catch (e) {
      state = state.copyWith(
        websocketState: WebsocketState.error,
        error: 'Failed to connect to WebSocket: $e',
      );
      _scheduleWebSocketReconnect();
    }
  }

  /// Handle match updates from stream
  void _handleMatchUpdate(SportsMatch updatedMatch) {
    // Update in live matches
    final updatedLiveMatches = state.liveMatches.map((match) {
      if (match.id == updatedMatch.id) {
        return updatedMatch;
      }
      return match;
    }).toList();

    // Update in filtered live matches
    final updatedFilteredLiveMatches = state.filteredLiveMatches.map((match) {
      if (match.id == updatedMatch.id) {
        return updatedMatch;
      }
      return match;
    }).toList();

    state = state.copyWith(
      liveMatches: updatedLiveMatches,
      filteredLiveMatches: updatedFilteredLiveMatches,
      lastUpdated: DateTime.now(),
    );
  }

  /// Handle score updates from stream
  void _handleScoreUpdate(SportsScore updatedScore) {
    // Update in live matches
    final updatedLiveMatches = state.liveMatches.map((match) {
      if (match.id == updatedScore.matchId) {
        return match.copyWith(currentScore: updatedScore);
      }
      return match;
    }).toList();

    // Update in filtered live matches
    final updatedFilteredLiveMatches = state.filteredLiveMatches.map((match) {
      if (match.id == updatedScore.matchId) {
        return match.copyWith(currentScore: updatedScore);
      }
      return match;
    }).toList();

    state = state.copyWith(
      liveMatches: updatedLiveMatches,
      filteredLiveMatches: updatedFilteredLiveMatches,
      lastUpdated: DateTime.now(),
    );
  }

  /// Handle match alerts
  void handleMatchAlert(Map<String, dynamic> alertData) {
    _handleMatchAlert(alertData);
  }

  /// Handle match alerts
  void _handleMatchAlert(Map<String, dynamic> alertData) {
    final currentAlerts = List<dynamic>.from(state.matchAlerts);
    currentAlerts.insert(0, alertData); // Add to beginning

    // Keep only last 10 alerts
    if (currentAlerts.length > 10) {
      currentAlerts.removeLast();
    }

    state = state.copyWith(matchAlerts: currentAlerts);
  }

  /// Schedule WebSocket reconnection
  void _scheduleWebSocketReconnect() {
    _websocketReconnectTimer?.cancel();
    _websocketReconnectTimer = Timer(const Duration(seconds: 5), () {
      connectWebSocket();
    });
  }

  /// Start refresh timer for periodic data updates
  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      refreshData();
    });
  }

  /// Refresh all sports data
  Future<void> refreshData() async {
    try {
      await Future.wait([
        loadLiveMatches(),
        loadUpcomingMatches(),
        loadRecentMatches(),
        loadSportsNews(),
        loadSportsStandings(),
      ]);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to refresh data: $e',
      );
    }
  }

  /// Subscribe to match alerts
  Future<void> subscribeToMatchAlerts(String matchId) async {
    try {
      if (_webSocketChannel != null &&
          state.websocketState == WebsocketState.connected) {
        _webSocketChannel!.sink.add(json.encode({
          'action': 'subscribe',
          'match_id': matchId,
        }));
      }
    } catch (e) {
      print('Error subscribing to match alerts: $e');
    }
  }

  /// Unsubscribe from match alerts
  Future<void> unsubscribeFromMatchAlerts(String matchId) async {
    try {
      if (_webSocketChannel != null &&
          state.websocketState == WebsocketState.connected) {
        _webSocketChannel!.sink.add(json.encode({
          'action': 'unsubscribe',
          'match_id': matchId,
        }));
      }
    } catch (e) {
      print('Error unsubscribing from match alerts: $e');
    }
  }

  /// Get match details
  Future<SportsMatch?> getMatchDetails(String matchId) async {
    try {
      return await _sportsService.getMatchDetails(matchId);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to get match details: $e',
      );
      return null;
    }
  }

  /// Get match scorecard
  Future<SportsScore?> getMatchScorecard(String matchId) async {
    try {
      return await _sportsService.getMatchScorecard(matchId);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to get match scorecard: $e',
      );
      return null;
    }
  }

  /// Get match commentary
  Future<List<dynamic>?> getMatchCommentary(String matchId) async {
    try {
      return await _sportsService.getMatchCommentary(matchId);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to get match commentary: $e',
      );
      return null;
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _websocketReconnectTimer?.cancel();
    _webSocketChannel?.sink.close();
    super.dispose();
  }
}

/// Sports state class
class SportsState {
  final List<SportsMatch> liveMatches;
  final List<SportsMatch> filteredLiveMatches;
  final List<SportsMatch> upcomingMatches;
  final List<SportsMatch> filteredUpcomingMatches;
  final List<SportsMatch> recentMatches;
  final List<SportsMatch> filteredRecentMatches;
  final List<String> sportsCategories;
  final List<dynamic> sportsNews;
  final List<dynamic> sportsStandings;
  final List<dynamic> matchAlerts;
  final WebsocketState websocketState;
  final bool isLoading;
  final bool isLoadingLiveMatches;
  final bool isLoadingUpcomingMatches;
  final bool isLoadingRecentMatches;
  final bool isLoadingNews;
  final bool isLoadingStandings;
  final String? error;
  final DateTime? lastUpdated;

  const SportsState({
    required this.liveMatches,
    required this.filteredLiveMatches,
    required this.upcomingMatches,
    required this.filteredUpcomingMatches,
    required this.recentMatches,
    required this.filteredRecentMatches,
    required this.sportsCategories,
    required this.sportsNews,
    required this.sportsStandings,
    required this.matchAlerts,
    required this.websocketState,
    required this.isLoading,
    required this.isLoadingLiveMatches,
    required this.isLoadingUpcomingMatches,
    required this.isLoadingRecentMatches,
    required this.isLoadingNews,
    required this.isLoadingStandings,
    this.error,
    this.lastUpdated,
  });

  factory SportsState.initial() {
    return const SportsState(
      liveMatches: [],
      filteredLiveMatches: [],
      upcomingMatches: [],
      filteredUpcomingMatches: [],
      recentMatches: [],
      filteredRecentMatches: [],
      sportsCategories: [],
      sportsNews: [],
      sportsStandings: [],
      matchAlerts: [],
      websocketState: WebsocketState.disconnected,
      isLoading: false,
      isLoadingLiveMatches: false,
      isLoadingUpcomingMatches: false,
      isLoadingRecentMatches: false,
      isLoadingNews: false,
      isLoadingStandings: false,
      error: null,
      lastUpdated: null,
    );
  }

  SportsState copyWith({
    List<SportsMatch>? liveMatches,
    List<SportsMatch>? filteredLiveMatches,
    List<SportsMatch>? upcomingMatches,
    List<SportsMatch>? filteredUpcomingMatches,
    List<SportsMatch>? recentMatches,
    List<SportsMatch>? filteredRecentMatches,
    List<String>? sportsCategories,
    List<dynamic>? sportsNews,
    List<dynamic>? sportsStandings,
    List<dynamic>? matchAlerts,
    WebsocketState? websocketState,
    bool? isLoading,
    bool? isLoadingLiveMatches,
    bool? isLoadingUpcomingMatches,
    bool? isLoadingRecentMatches,
    bool? isLoadingNews,
    bool? isLoadingStandings,
    String? error,
    DateTime? lastUpdated,
  }) {
    return SportsState(
      liveMatches: liveMatches ?? this.liveMatches,
      filteredLiveMatches: filteredLiveMatches ?? this.filteredLiveMatches,
      upcomingMatches: upcomingMatches ?? this.upcomingMatches,
      filteredUpcomingMatches:
          filteredUpcomingMatches ?? this.filteredUpcomingMatches,
      recentMatches: recentMatches ?? this.recentMatches,
      filteredRecentMatches:
          filteredRecentMatches ?? this.filteredRecentMatches,
      sportsCategories: sportsCategories ?? this.sportsCategories,
      sportsNews: sportsNews ?? this.sportsNews,
      sportsStandings: sportsStandings ?? this.sportsStandings,
      matchAlerts: matchAlerts ?? this.matchAlerts,
      websocketState: websocketState ?? this.websocketState,
      isLoading: isLoading ?? this.isLoading,
      isLoadingLiveMatches: isLoadingLiveMatches ?? this.isLoadingLiveMatches,
      isLoadingUpcomingMatches:
          isLoadingUpcomingMatches ?? this.isLoadingUpcomingMatches,
      isLoadingRecentMatches:
          isLoadingRecentMatches ?? this.isLoadingRecentMatches,
      isLoadingNews: isLoadingNews ?? this.isLoadingNews,
      isLoadingStandings: isLoadingStandings ?? this.isLoadingStandings,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// WebSocket connection states
enum WebsocketState {
  disconnected,
  connecting,
  connected,
  error,
  reconnecting,
}
