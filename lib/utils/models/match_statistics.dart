class MatchStatistics {
  final int? type;
  final String? home;
  final String? away;

  MatchStatistics({this.type, this.home, this.away});

  // Factory constructor to handle data mapping from your API response
  factory MatchStatistics.fromJson(Map<String, dynamic> json) {
    return MatchStatistics(
      type: json['type'] as int?,
      home: json['home']?.toString(),
      away: json['away']?.toString(),
    );
  }
}
