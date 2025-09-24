import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Comprehensive sports match model supporting all sports
/// with 3D animation support and real-time updates
class SportsMatch extends Equatable {
  final String id;
  final String sport; // cricket, football, basketball, tennis, etc.
  final String league;
  final String tournament;
  final String format; // T20, ODI, Test, Premier League, NBA, etc.
  final String status; // live, upcoming, completed, delayed
  final DateTime startTime;
  final DateTime? endTime;
  final String venue;
  final String city;
  final String country;
  final List<SportsTeam> teams;
  final SportsScore? currentScore;
  final List<SportsInning> innings; // For cricket, periods for other sports
  final List<SportsEvent> events; // Goals, wickets, fouls, etc.
  final String? result;
  final String? manOfTheMatch;
  final String? tossWinner;
  final String? tossDecision; // bat, field, etc.
  final Map<String, dynamic> metadata;
  final bool isLive;
  final int live_viewers;
  final String? streamingUrl;
  final List<String> highlights;
  final SportsOdds? odds;
  final DateTime lastUpdated;
  final String priority; // high, medium, low for animation priority

  const SportsMatch({
    required this.id,
    required this.sport,
    required this.league,
    required this.tournament,
    required this.format,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.venue,
    required this.city,
    required this.country,
    required this.teams,
    this.currentScore,
    this.innings = const [],
    this.events = const [],
    this.result,
    this.manOfTheMatch,
    this.tossWinner,
    this.tossDecision,
    this.metadata = const {},
    this.isLive = false,
    this.live_viewers = 0,
    this.streamingUrl,
    this.highlights = const [],
    this.odds,
    required this.lastUpdated,
    this.priority = 'medium',
  });

  factory SportsMatch.fromJson(Map<String, dynamic> json) {
    return SportsMatch(
      id: json['id'] ?? '',
      sport: json['sport'] ?? 'cricket',
      league: json['league'] ?? '',
      tournament: json['tournament'] ?? '',
      format: json['format'] ?? '',
      status: json['status'] ?? 'upcoming',
      startTime: DateTime.parse(
          json['start_time'] ?? DateTime.now().toIso8601String()),
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      venue: json['venue'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      teams: (json['teams'] as List<dynamic>?)
              ?.map((team) => SportsTeam.fromJson(team))
              .toList() ??
          [],
      currentScore: json['current_score'] != null
          ? SportsScore.fromJson(json['current_score'])
          : null,
      innings: (json['innings'] as List<dynamic>?)
              ?.map((inning) => SportsInning.fromJson(inning))
              .toList() ??
          [],
      events: (json['events'] as List<dynamic>?)
              ?.map((event) => SportsEvent.fromJson(event))
              .toList() ??
          [],
      result: json['result'],
      manOfTheMatch: json['man_of_the_match'],
      tossWinner: json['toss_winner'],
      tossDecision: json['toss_decision'],
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      isLive: json['is_live'] ?? false,
      live_viewers: json['live_viewers'] ?? 0,
      streamingUrl: json['streaming_url'],
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((highlight) => highlight.toString())
              .toList() ??
          [],
      odds: json['odds'] != null ? SportsOdds.fromJson(json['odds']) : null,
      lastUpdated: DateTime.parse(
          json['last_updated'] ?? DateTime.now().toIso8601String()),
      priority: json['priority'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sport': sport,
      'league': league,
      'tournament': tournament,
      'format': format,
      'status': status,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'venue': venue,
      'city': city,
      'country': country,
      'teams': teams.map((team) => team.toJson()).toList(),
      'current_score': currentScore?.toJson(),
      'innings': innings.map((inning) => inning.toJson()).toList(),
      'events': events.map((event) => event.toJson()).toList(),
      'result': result,
      'man_of_the_match': manOfTheMatch,
      'toss_winner': tossWinner,
      'toss_decision': tossDecision,
      'metadata': metadata,
      'is_live': isLive,
      'live_viewers': live_viewers,
      'streaming_url': streamingUrl,
      'highlights': highlights,
      'odds': odds?.toJson(),
      'last_updated': lastUpdated.toIso8601String(),
      'priority': priority,
    };
  }

  // Helper methods for UI animations
  bool get isHighPriority => priority == 'high';
  bool get isMediumPriority => priority == 'medium';
  bool get isLowPriority => priority == 'low';

  String get matchTitle {
    if (teams.length >= 2) {
      return '${teams[0].name} vs ${teams[1].name}';
    }
    return 'Match $id';
  }

  String get shortStatus {
    switch (status) {
      case 'live':
        return 'LIVE';
      case 'upcoming':
        return 'UPCOMING';
      case 'completed':
        return 'COMPLETED';
      case 'delayed':
        return 'DELAYED';
      default:
        return status.toUpperCase();
    }
  }

  Color get statusColor {
    switch (status) {
      case 'live':
        return const Color(0xFF00FF00);
      case 'upcoming':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF9E9E9E);
      case 'delayed':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Duration get timeUntilStart => startTime.difference(DateTime.now());
  bool get isStartingSoon =>
      timeUntilStart.inHours < 1 && timeUntilStart.isNegative == false;

  @override
  List<Object?> get props => [id, lastUpdated];

  @override
  bool get stringify => true;
}

/// Enhanced team model with 3D animation support
class SportsTeam extends Equatable {
  final String id;
  final String name;
  final String shortName;
  final String logo;
  final String country;
  final String? coach;
  final List<SportsPlayer> players;
  final Map<String, dynamic> statistics;
  final String? ranking;
  final Color primaryColor;
  final Color secondaryColor;
  final String? anthem;
  final int foundedYear;

  const SportsTeam({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logo,
    required this.country,
    this.coach,
    this.players = const [],
    this.statistics = const {},
    this.ranking,
    required this.primaryColor,
    required this.secondaryColor,
    this.anthem,
    this.foundedYear = 0,
  });

  factory SportsTeam.fromJson(Map<String, dynamic> json) {
    return SportsTeam(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
      logo: json['logo'] ?? '',
      country: json['country'] ?? '',
      coach: json['coach'],
      players: (json['players'] as List<dynamic>?)
              ?.map((player) => SportsPlayer.fromJson(player))
              .toList() ??
          [],
      statistics: json['statistics'] as Map<String, dynamic>? ?? {},
      ranking: json['ranking'],
      primaryColor: Color(json['primary_color'] ?? 0xFF2196F3),
      secondaryColor: Color(json['secondary_color'] ?? 0xFFFFFFFF),
      anthem: json['anthem'],
      foundedYear: json['founded_year'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_name': shortName,
      'logo': logo,
      'country': country,
      'coach': coach,
      'players': players.map((player) => player.toJson()).toList(),
      'statistics': statistics,
      'ranking': ranking,
      'primary_color': primaryColor.value,
      'secondary_color': secondaryColor.value,
      'anthem': anthem,
      'founded_year': foundedYear,
    };
  }

  @override
  List<Object?> get props => [id];
}

/// Enhanced player model with detailed statistics
class SportsPlayer extends Equatable {
  final String id;
  final String name;
  final String? jerseyNumber;
  final String position;
  final String role;
  final String? photo;
  final String country;
  final DateTime? dateOfBirth;
  final String? battingStyle; // For cricket
  final String? bowlingStyle; // For cricket
  final String? dominantHand; // For tennis, basketball
  final Map<String, dynamic> statistics;
  final bool isCaptain;
  final bool isWicketKeeper; // For cricket
  final double? currentRating;
  final int? ranking;

  const SportsPlayer({
    required this.id,
    required this.name,
    this.jerseyNumber,
    required this.position,
    required this.role,
    this.photo,
    required this.country,
    this.dateOfBirth,
    this.battingStyle,
    this.bowlingStyle,
    this.dominantHand,
    this.statistics = const {},
    this.isCaptain = false,
    this.isWicketKeeper = false,
    this.currentRating,
    this.ranking,
  });

  factory SportsPlayer.fromJson(Map<String, dynamic> json) {
    return SportsPlayer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      jerseyNumber: json['jersey_number'],
      position: json['position'] ?? '',
      role: json['role'] ?? '',
      photo: json['photo'],
      country: json['country'] ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      battingStyle: json['batting_style'],
      bowlingStyle: json['bowling_style'],
      dominantHand: json['dominant_hand'],
      statistics: json['statistics'] as Map<String, dynamic>? ?? {},
      isCaptain: json['is_captain'] ?? false,
      isWicketKeeper: json['is_wicket_keeper'] ?? false,
      currentRating: json['current_rating']?.toDouble(),
      ranking: json['ranking'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'jersey_number': jerseyNumber,
      'position': position,
      'role': role,
      'photo': photo,
      'country': country,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'batting_style': battingStyle,
      'bowling_style': bowlingStyle,
      'dominant_hand': dominantHand,
      'statistics': statistics,
      'is_captain': isCaptain,
      'is_wicket_keeper': isWicketKeeper,
      'current_rating': currentRating,
      'ranking': ranking,
    };
  }

  @override
  List<Object?> get props => [id];
}

/// Enhanced score model for all sports
class SportsScore extends Equatable {
  final String? currentInning; // For cricket
  final Map<String, dynamic> team1Score;
  final Map<String, dynamic> team2Score;
  final String? currentOver; // For cricket
  final int? currentBall; // For cricket
  final String? striker; // For cricket
  final String? nonStriker; // For cricket
  final String? bowler; // For cricket
  final String? currentServer; // For tennis
  final String? gameScore; // For tennis
  final String? setScore; // For tennis
  final int? quarter; // For basketball
  final int? minute; // For football
  final int? second; // For football
  final String? additionalInfo;

  const SportsScore({
    this.currentInning,
    required this.team1Score,
    required this.team2Score,
    this.currentOver,
    this.currentBall,
    this.striker,
    this.nonStriker,
    this.bowler,
    this.currentServer,
    this.gameScore,
    this.setScore,
    this.quarter,
    this.minute,
    this.second,
    this.additionalInfo,
  });

  factory SportsScore.fromJson(Map<String, dynamic> json) {
    return SportsScore(
      currentInning: json['current_inning'],
      team1Score: json['team1_score'] as Map<String, dynamic>? ?? {},
      team2Score: json['team2_score'] as Map<String, dynamic>? ?? {},
      currentOver: json['current_over'],
      currentBall: json['current_ball'],
      striker: json['striker'],
      nonStriker: json['non_striker'],
      bowler: json['bowler'],
      currentServer: json['current_server'],
      gameScore: json['game_score'],
      setScore: json['set_score'],
      quarter: json['quarter'],
      minute: json['minute'],
      second: json['second'],
      additionalInfo: json['additional_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_inning': currentInning,
      'team1_score': team1Score,
      'team2_score': team2Score,
      'current_over': currentOver,
      'current_ball': currentBall,
      'striker': striker,
      'non_striker': nonStriker,
      'bowler': bowler,
      'current_server': currentServer,
      'game_score': gameScore,
      'set_score': setScore,
      'quarter': quarter,
      'minute': minute,
      'second': second,
      'additional_info': additionalInfo,
    };
  }

  @override
  List<Object?> get props => [currentInning, team1Score, team2Score];
}

/// Sports inning/period model
class SportsInning extends Equatable {
  final String id;
  final String name; // 1st Innings, 2nd Half, Quarter 1, etc.
  final int number;
  final Map<String, dynamic> team1Stats;
  final Map<String, dynamic> team2Stats;
  final String status; // completed, current, upcoming
  final DateTime? startTime;
  final DateTime? endTime;

  const SportsInning({
    required this.id,
    required this.name,
    required this.number,
    required this.team1Stats,
    required this.team2Stats,
    required this.status,
    this.startTime,
    this.endTime,
  });

  factory SportsInning.fromJson(Map<String, dynamic> json) {
    return SportsInning(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? 0,
      team1Stats: json['team1_stats'] as Map<String, dynamic>? ?? {},
      team2Stats: json['team2_stats'] as Map<String, dynamic>? ?? {},
      status: json['status'] ?? '',
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'])
          : null,
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'team1_stats': team1Stats,
      'team2_stats': team2Stats,
      'status': status,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id];
}

/// Sports event model for real-time events
class SportsEvent extends Equatable {
  final String id;
  final String type; // goal, wicket, foul, penalty, etc.
  final String description;
  final String team;
  final String? player;
  final String? assistant; // For assists, partnerships
  final int minute; // For football, over for cricket
  final int? second;
  final String? additionalInfo;
  final DateTime timestamp;
  final bool isImportant; // For highlighting in animations
  final String? icon; // For 3D animation icons

  const SportsEvent({
    required this.id,
    required this.type,
    required this.description,
    required this.team,
    this.player,
    this.assistant,
    required this.minute,
    this.second,
    this.additionalInfo,
    required this.timestamp,
    this.isImportant = false,
    this.icon,
  });

  factory SportsEvent.fromJson(Map<String, dynamic> json) {
    return SportsEvent(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      team: json['team'] ?? '',
      player: json['player'],
      assistant: json['assistant'],
      minute: json['minute'] ?? 0,
      second: json['second'],
      additionalInfo: json['additional_info'],
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isImportant: json['is_important'] ?? false,
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'team': team,
      'player': player,
      'assistant': assistant,
      'minute': minute,
      'second': second,
      'additional_info': additionalInfo,
      'timestamp': timestamp.toIso8601String(),
      'is_important': isImportant,
      'icon': icon,
    };
  }

  @override
  List<Object?> get props => [id, timestamp];
}

/// Sports odds model for betting/ predictions
class SportsOdds extends Equatable {
  final double team1Win;
  final double team2Win;
  final double draw;
  final double overUnder;
  final Map<String, dynamic> additionalMarkets;
  final DateTime lastUpdated;

  const SportsOdds({
    required this.team1Win,
    required this.team2Win,
    required this.draw,
    required this.overUnder,
    this.additionalMarkets = const {},
    required this.lastUpdated,
  });

  factory SportsOdds.fromJson(Map<String, dynamic> json) {
    return SportsOdds(
      team1Win: json['team1_win']?.toDouble() ?? 0.0,
      team2Win: json['team2_win']?.toDouble() ?? 0.0,
      draw: json['draw']?.toDouble() ?? 0.0,
      overUnder: json['over_under']?.toDouble() ?? 0.0,
      additionalMarkets:
          json['additional_markets'] as Map<String, dynamic>? ?? {},
      lastUpdated: DateTime.parse(
          json['last_updated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team1_win': team1Win,
      'team2_win': team2Win,
      'draw': draw,
      'over_under': overUnder,
      'additional_markets': additionalMarkets,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [lastUpdated];
}
