class Standing {
  final int rank;
  final String teamId;
  final String teamName;
  final String teamLogo;

  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int points;

  const Standing({
    required this.rank,
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.points,
  });

  /// Parses one entry from `data['totalStandings']`.
  ///
  /// [teamsById] is built from `data['teamInfos']` and keyed by `teamId`.
  /// The standings entry itself contains only `teamId` — name and logo
  /// must be looked up separately.
  factory Standing.fromJson(
      Map<String, dynamic> json,
      Map<String, Map<String, dynamic>> teamsById,
      ) {
    final teamId = json['teamId']?.toString() ?? '';
    final team = teamsById[teamId];

    return Standing(
      rank: _asInt(json['rank']) ?? 0,
      teamId: teamId,
      teamName: (team?['name'] as String?) ?? '',
      teamLogo: (team?['logo'] as String?) ?? '',
      played: _asInt(json['totalCount']) ?? 0,
      won: _asInt(json['winCount']) ?? 0,
      drawn: _asInt(json['drawCount']) ?? 0,
      lost: _asInt(json['loseCount']) ?? 0,
      goalsFor: _asInt(json['getScore']) ?? 0,
      goalsAgainst: _asInt(json['loseScore']) ?? 0,
      goalDifference: _asInt(json['goalDifference']) ?? 0,
      points: _asInt(json['integral']) ?? 0,
    );
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}