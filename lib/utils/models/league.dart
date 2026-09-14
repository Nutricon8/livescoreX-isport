class League {
  final String leagueId;
  final subLeagueId;
  final int? type; // Changed from Int to int
  final String? color;
  final String? logo;
  final String? name;
  final String? shortName;
  final String? subLeagueName;
  final int? totalRound; // Changed from Int to int
  final int? currentRound; // Changed from Int to int
  final String? currentSeason;
  final String? countryId;
  final String? country;
  final String? countryLogo;
  final int? areaId; // Changed from Int to int
  final bool isFavorite; // Changed from Bool to bool

  League({
    required this.leagueId,
    required this.subLeagueId,
    this.type,
    this.name,
    this.logo,
    this.country,
    this.countryLogo,
    this.color,
    this.shortName,
    this.subLeagueName,
    this.totalRound,
    this.currentRound,
    this.currentSeason,
    this.countryId,
    this.areaId,
    this.isFavorite = false, // Set default value
  });

  // Factory constructor to handle data mapping from your API response
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      leagueId: json['leagueId']?.toString() ?? '',
      subLeagueId: json['subLeagueId'].toString(),
      type: json['type'] as int?,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      country: json['country'] as String?,
      countryLogo: json['countryLogo'] as String?,
      color: json['color'] as String?,
      shortName: json['shortName'] as String?,
      subLeagueName: json['subLeagueName'] as String?,
      totalRound: json['totalRound'] as int?,
      currentRound: json['currentRound'] as int?,
      currentSeason:
          json['season']?.toString() ?? json['currentSeason']?.toString(),
      countryId: json['countryId']?.toString(),
      areaId: json['areaId'] as int?,
      isFavorite: false, // Defaulting to false until user toggles it favorite
    );
  }

  Map<String, dynamic> toJson() => {
    'leagueId': leagueId,
    'subLeagueId':subLeagueId,
    'type': type,
    'color': color,
    'logo': logo,
    'name': name,
    'shortName': shortName,
    'subLeagueName': subLeagueName,
    'totalRound': totalRound,
    'currentRound': currentRound,
    'currentSeason': currentSeason,
    'countryId': countryId,
    'country': country,
    'countryLogo': countryLogo,
    'areaId': areaId,
    'isFavorite': isFavorite,
  };

}
