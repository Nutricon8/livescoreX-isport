class MatchEvent {
  final String time;
  final int teamId;
  final String playerName;
  final String eventType;
  final String eventDetail;
  final String assistPlayer;

  MatchEvent({
    required this.time,
    required this.teamId,
    required this.playerName,
    required this.eventType,
    required this.eventDetail,
    required this.assistPlayer,
  });
}
