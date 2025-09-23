class MatchItem {
  final String id;
  final String title;
  final String status;
  final String format;
  final String team1;
  final String team2;
  final String team1Score;
  final String team2Score;
  final String team1Overs;
  final String team2Overs;
  final String venue;
  final DateTime startTime;
  final bool isLive;
  final String? result;
  final String seriesName;
  final String matchNumber;

  MatchItem({
    required this.id,
    required this.title,
    required this.status,
    required this.format,
    required this.team1,
    required this.team2,
    required this.team1Score,
    required this.team2Score,
    required this.team1Overs,
    required this.team2Overs,
    required this.venue,
    required this.startTime,
    required this.isLive,
    this.result,
    required this.seriesName,
    required this.matchNumber,
  });

  factory MatchItem.fromJson(Map<String, dynamic> json) {
    return MatchItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      format: json['format'] ?? '',
      team1: json['team1'] ?? '',
      team2: json['team2'] ?? '',
      team1Score: json['team1Score'] ?? '',
      team2Score: json['team2Score'] ?? '',
      team1Overs: json['team1Overs'] ?? '',
      team2Overs: json['team2Overs'] ?? '',
      venue: json['venue'] ?? '',
      startTime:
          DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      isLive: json['isLive'] ?? false,
      result: json['result'],
      seriesName: json['seriesName'] ?? '',
      matchNumber: json['matchNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'format': format,
      'team1': team1,
      'team2': team2,
      'team1Score': team1Score,
      'team2Score': team2Score,
      'team1Overs': team1Overs,
      'team2Overs': team2Overs,
      'venue': venue,
      'startTime': startTime.toIso8601String(),
      'isLive': isLive,
      'result': result,
      'seriesName': seriesName,
      'matchNumber': matchNumber,
    };
  }
}
