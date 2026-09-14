class MatchEvent {
  final String eventId;
  final String? minute;
  final int? type;
  final String? playerId;
  final String? playerName;
  final String? assistPlayerId;
  final bool homeEvent;
  final bool isFavorite;

  MatchEvent({
    required this.eventId,
    this.minute,
    this.type,
    this.playerId,
    this.playerName,
    this.assistPlayerId,
    this.homeEvent = false,
    this.isFavorite = false,
  });

  // Factory constructor to handle data mapping from your API response
  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      eventId: json['eventId']?.toString() ?? '',
      minute: json['minute']?.toString(),
      type: json['type'] as int?,
      playerId: json['playerId']?.toString(),
      playerName: json['playerName'] as String?,
      assistPlayerId: json['assistPlayerId']?.toString(),
      homeEvent: json['homeEvent'] as bool? ?? false,
      isFavorite: false, // Defaulting to false until user toggles it favorite
    );
  }
}
