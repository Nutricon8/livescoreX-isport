class Match {
  final String matchId;

  final int? leagueType;
  final String leagueId;
  final String? leagueName;
  final String? leagueShortName;
  final String? leagueColor;
  final String? subLeagueId;
  final String? subLeagueName;
  final int? matchTime;
  final int? halfStartTime;
  final int? status;
  final String? homeId;
  final String? homeName;
  final String? awayId;
  final String? awayName;
  final int? homeScore;
  final int? awayScore;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final int? homeHalfScore;
  final int? awayHalfScore;
  final int? homeRed;
  final int? awayRed;
  final int? homeYellow;
  final int? awayYellow;
  final int? homeCorner;
  final int? awayCorner;
  final String? homeRank;
  final String? awayRank;
  final String? season;
  final String? round;
  final String? group;
  final String? location;
  final String? weather;
  final String? temperature;
  final String? explain;
  // final ExtraExplain? extraExplain;
  final bool hasLineup;
  final bool neutral;
  final int? injuryTime;
  // final String? var;
  final int? updateTime;
  final bool isFavorite;

  Match({
    required this.matchId,
    this.leagueType,
    required this.leagueId,
    this.leagueName,
    this.leagueShortName,
    this.leagueColor,
    this.subLeagueId,
    this.subLeagueName,
    this.matchTime,
    this.halfStartTime,
    this.status,
    this.homeId,
    this.homeName,
    this.awayId,
    this.awayName,
    this.homeScore,
    this.awayScore,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.homeHalfScore,
    this.awayHalfScore,
    this.homeRed,
    this.awayRed,
    this.homeYellow,
    this.awayYellow,
    this.homeCorner,
    this.awayCorner,
    this.homeRank,
    this.awayRank,
    this.season,
    this.round,
    this.group,
    this.location,
    this.weather,
    this.temperature,
    this.explain,
    this.hasLineup = false,
    this.neutral = false,
    this.injuryTime,
    this.updateTime,
    this.isFavorite = false,
  });

  static const String _proxyOrigin =
      'https://isport-api-production.up.railway.app';

  static String? _resolveLogo(String? logo) {
    if (logo == null || logo.isEmpty) return null;
    if (logo.startsWith('http://') || logo.startsWith('https://')) return logo;
    return '$_proxyOrigin$logo';
  }

  // Factory constructor to handle data mapping from your API response
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchId: json['matchId']?.toString() ?? '',
      leagueType: json['leagueType'] as int?,
      leagueId: json['leagueId']?.toString() ?? '',
      leagueName: json['leagueName'] as String?,
      leagueShortName: json['leagueShortName'] as String?,
      leagueColor: json['leagueColor'] as String?,
      subLeagueId: json['subLeagueId']?.toString(),
      subLeagueName: json['subLeagueName'] as String?,
      matchTime: json['matchTime'] as int?,
      halfStartTime: json['halfStartTime'] as int?,
      status: json['status'] as int?,
      homeId: json['homeId']?.toString(),
      homeName: json['homeName'] as String?,
      awayId: json['awayId']?.toString(),
      awayName: json['awayName'] as String?,
      homeScore: json['homeScore'] as int?,
      awayScore: json['awayScore'] as int?,
      homeTeamLogo: _resolveLogo(json['homeTeamLogo'] as String?),
      awayTeamLogo: _resolveLogo(json['awayTeamLogo'] as String?),
      homeHalfScore: json['homeHalfScore'] as int?,
      awayHalfScore: json['awayHalfScore'] as int?,
      homeRed: json['homeRed'] as int?,
      awayRed: json['awayRed'] as int?,
      homeYellow: json['homeYellow'] as int?,
      awayYellow: json['awayYellow'] as int?,
      homeCorner: json['homeCorner'] as int?,
      awayCorner: json['awayCorner'] as int?,
      homeRank: json['homeRank'] as String?,
      awayRank: json['awayRank'] as String?,
      season: json['season']?.toString(),
      round: json['round']?.toString(),
      group: json['group'] as String?,
      location: json['location'] as String?,
      weather: json['weather'] as String?,
      temperature: json['temperature']?.toString(),
      explain: json['explain'] as String?,
      hasLineup: json['hasLineup'] as bool? ?? false,
      neutral: json['neutral'] as bool? ?? false,
      injuryTime: json['injuryTime'] as int?,
      updateTime: json['updateTime'] as int?,
      isFavorite: false, // Defaulting to false until user toggles it favorite
    );
  }

  Map<String, dynamic> toJson() => {
        'matchId': matchId,
        'leagueType': leagueType,
        'leagueId': leagueId,
        'leagueName': leagueName,
        'leagueShortName': leagueShortName,
        'leagueColor': leagueColor,
        'subLeagueId': subLeagueId,
        'subLeagueName': subLeagueName,
        'matchTime': matchTime,
        'halfStartTime': halfStartTime,
        'status': status,
        'homeId': homeId,
        'homeName': homeName,
        'awayId': awayId,
        'awayName': awayName,
        'homeScore': homeScore,
        'awayScore': awayScore,
        'homeHalfScore': homeHalfScore,
        'awayHalfScore': awayHalfScore,
        'homeRed': homeRed,
        'awayRed': awayRed,
        'homeYellow': homeYellow,
        'awayYellow': awayYellow,
        'homeCorner': homeCorner,
        'awayCorner': awayCorner,
        'homeRank': homeRank,
        'awayRank': awayRank,
        'season': season,
        'round': round,
        'group': group,
        'location': location,
        'weather': weather,
        'temperature': temperature,
        'explain': explain,
        'hasLineup': hasLineup,
        'neutral': neutral,
        'injuryTime': injuryTime,
        'updateTime': updateTime,
        'isFavorite': isFavorite,
      };
}
