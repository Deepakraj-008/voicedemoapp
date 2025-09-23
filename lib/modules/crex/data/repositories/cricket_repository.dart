// lib/modules/crex/data/repositories/cricket_repository.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sweetyai_learning_assistant/core/network/crex_api_client.dart'
    show CrexApiClient;
import 'package:sweetyai_learning_assistant/core/constants.dart';

import '../models/match_item.dart';

enum MatchFeed { live, upcoming, recent }

class CricketRepository {
  CricketRepository(this._api);
  final CrexApiClient _api;

  Future<List<MatchItem>> fetchMatches(MatchFeed feed,
      {String type = 'international'}) async {
    final path = switch (feed) {
      MatchFeed.live => '/v1/matches/live',
      MatchFeed.upcoming => '/v1/matches/upcoming',
      MatchFeed.recent => '/v1/matches/recent',
    };
    final res = await _api.get(path, queryParameters: {'type': type});
    final data =
        (res['data']?['matches'] as List? ?? []).cast<Map<String, dynamic>>();
    return data.map(MatchItem.fromJson).toList();
  }

  Future<Map<String, dynamic>> fetchScore(String matchId) async {
    final res = await _api.get('/v1/score/$matchId');
    return Map<String, dynamic>.from(res['data'] ?? {});
  }

  Stream<List<MatchItem>> streamMatches(MatchFeed feed,
      {String type = 'international'}) async* {
    while (true) {
      try {
        yield await fetchMatches(feed, type: type);
      } catch (_) {}
      await Future.delayed(const Duration(seconds: CrexConst.pollSeconds));
    }
  }
}
