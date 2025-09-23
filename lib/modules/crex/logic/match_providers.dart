import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/cricket_repository.dart';
import '../data/models/match_item.dart';
import '../../../core/network/crex_api_client.dart';

// Provider for match type selection
final matchTypeProvider = StateProvider<String>((ref) => 'international');

class MatchProviders with ChangeNotifier {
  final CricketRepository _repository;

  MatchProviders(this._repository);

  // Live Matches
  List<MatchItem> _liveMatches = [];
  bool _isLoadingLiveMatches = false;
  String? _liveMatchesError;

  List<MatchItem> get liveMatches => _liveMatches;
  bool get isLoadingLiveMatches => _isLoadingLiveMatches;
  String? get liveMatchesError => _liveMatchesError;

  // Upcoming Matches
  List<MatchItem> _upcomingMatches = [];
  bool _isLoadingUpcomingMatches = false;
  String? _upcomingMatchesError;

  List<MatchItem> get upcomingMatches => _upcomingMatches;
  bool get isLoadingUpcomingMatches => _isLoadingUpcomingMatches;
  String? get upcomingMatchesError => _upcomingMatchesError;

  // Recent Matches
  List<MatchItem> _recentMatches = [];
  bool _isLoadingRecentMatches = false;
  String? _recentMatchesError;

  List<MatchItem> get recentMatches => _recentMatches;
  bool get isLoadingRecentMatches => _isLoadingRecentMatches;
  String? get recentMatchesError => _recentMatchesError;

  // Selected Match
  MatchItem? _selectedMatch;
  bool _isLoadingMatchDetails = false;
  String? _matchDetailsError;

  MatchItem? get selectedMatch => _selectedMatch;
  bool get isLoadingMatchDetails => _isLoadingMatchDetails;
  String? get matchDetailsError => _matchDetailsError;

  // Fetch Live Matches
  Future<void> fetchLiveMatches() async {
    _isLoadingLiveMatches = true;
    _liveMatchesError = null;
    notifyListeners();

    try {
      _liveMatches = await _repository.fetchMatches(MatchFeed.live);
      _liveMatchesError = null;
    } catch (e) {
      _liveMatchesError = e.toString();
      _liveMatches = [];
    } finally {
      _isLoadingLiveMatches = false;
      notifyListeners();
    }
  }

  // Fetch Upcoming Matches
  Future<void> fetchUpcomingMatches() async {
    _isLoadingUpcomingMatches = true;
    _upcomingMatchesError = null;
    notifyListeners();

    try {
      _upcomingMatches = await _repository.fetchMatches(MatchFeed.upcoming);
      _upcomingMatchesError = null;
    } catch (e) {
      _upcomingMatchesError = e.toString();
      _upcomingMatches = [];
    } finally {
      _isLoadingUpcomingMatches = false;
      notifyListeners();
    }
  }

  // Fetch Recent Matches
  Future<void> fetchRecentMatches() async {
    _isLoadingRecentMatches = true;
    _recentMatchesError = null;
    notifyListeners();

    try {
      _recentMatches = await _repository.fetchMatches(MatchFeed.recent);
      _recentMatchesError = null;
    } catch (e) {
      _recentMatchesError = e.toString();
      _recentMatches = [];
    } finally {
      _isLoadingRecentMatches = false;
      notifyListeners();
    }
  }

  // Fetch Match Details
  Future<void> fetchMatchDetails(String matchId) async {
    _isLoadingMatchDetails = true;
    _matchDetailsError = null;
    notifyListeners();

    try {
      final scoreData = await _repository.fetchScore(matchId);
      _selectedMatch = MatchItem.fromJson(scoreData);
      _matchDetailsError = null;
    } catch (e) {
      _matchDetailsError = e.toString();
      _selectedMatch = null;
    } finally {
      _isLoadingMatchDetails = false;
      notifyListeners();
    }
  }

  // Fetch Matches by Format
  Future<List<MatchItem>> fetchMatchesByFormat(String format) async {
    try {
      return await _repository.fetchMatches(MatchFeed.upcoming, type: format);
    } catch (e) {
      throw Exception('Failed to fetch matches by format: $e');
    }
  }

  // Refresh All Matches
  Future<void> refreshAllMatches() async {
    await Future.wait([
      fetchLiveMatches(),
      fetchUpcomingMatches(),
      fetchRecentMatches(),
    ]);
  }

  // Clear Errors
  void clearErrors() {
    _liveMatchesError = null;
    _upcomingMatchesError = null;
    _recentMatchesError = null;
    _matchDetailsError = null;
    notifyListeners();
  }
}
