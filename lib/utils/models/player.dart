class Player {
  final String recordId;
  final String playerId;
  final String name;
  final String birthday;
  final int height;
  final String country;
  final String feet;
  final int weight;
  final String photo;
  final int value;
  final String teamId;
  final String position;
  final int number;
  final String introduce;
  final String contractEndDate;
  final String? pac;
  final String? sho;
  final String? pas;
  final String? dri;
  final String? def;
  final String? phy;
  final bool isFavorite;

  Player({
    required this.recordId,
    required this.playerId,
    required this.name,
    required this.birthday,
    required this.height,
    required this.country,
    required this.feet,
    required this.weight,
    required this.photo,
    required this.value,
    required this.teamId,
    required this.position,
    required this.number,
    required this.introduce,
    required this.contractEndDate,
    this.pac,
    this.sho,
    this.pas,
    this.dri,
    this.def,
    this.phy,
    this.isFavorite = false,
  });

  // Factory constructor to handle data mapping from your API response
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      recordId: json['recordId']?.toString() ?? '',
      playerId: json['playerId']?.toString() ?? '',
      name: json['name'] as String,
      birthday: json['birthday'].toString(),
      height: json['height'] as int,
      country: json['country'] as String,
      feet: json['feet'] as String,
      weight: json['weight'] as int,
      photo: json['photo'] as String,
      value: json['value'] as int,
      teamId: json['teamId'].toString(),
      position: json['position'] as String,
      number: json['number'] as int,
      introduce: json['introduce'] as String,
      contractEndDate: json['contractEndDate'].toString(),
      pac: json['pac']?.toString(),
      sho: json['sho']?.toString(),
      pas: json['pas']?.toString(),
      dri: json['dri']?.toString(),
      def: json['def']?.toString(),
      phy: json['phy']?.toString(),
      isFavorite: false, // Defaulting to false until user toggles it favorite
    );
  }
}
