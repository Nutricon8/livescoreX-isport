class Team {
  final String teamId;
  final String leagueId;
  final String? name;
  final String? logo;
  final String? foundingDate;
  final String? address;
  final String? area;
  final String? venue;
  final int? capacity;
  final String? coach;
  final String? website;
  final bool isNational;
  final bool isFavorite;

  Team({
    required this.teamId,
    required this.leagueId,
    this.name,
    this.logo,
    this.foundingDate,
    this.address,
    this.area,
    this.venue,
    this.capacity,
    this.coach,
    this.website,
    this.isNational = false,
    this.isFavorite = false,
  });

  // Factory constructor to handle data mapping from your API response
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['teamId']?.toString() ?? '',
      leagueId: json['leagueId']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      foundingDate: json['foundingDate'].toString(),
      address: json['address'] as String? ?? '',
      area: json['area'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      capacity: json['capacity'] as int?,
      coach: json['coach'] as String? ?? '',
      website: json['website'] as String? ?? '',
      isNational: json['isNational'] as bool? ?? false,
      isFavorite: false, // Defaulting to false until user toggles it favorite
    );
  }

  Map<String, dynamic> toJson() => {
    'teamId': teamId,
    'leagueId': leagueId,
    'name': name,
    'logo': logo,
    'foundingDate': foundingDate,
    'address': address,
    'area': area,
    'venue': venue,
    'capacity': capacity,
    'coach': coach,
    'website': website,
    'isNational': isNational,
    'isFavorite': isFavorite,
  };
}
