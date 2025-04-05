import 'package:livescore_x/utils/models/league.dart';
import 'package:livescore_x/utils/models/team.dart';

class Match {
  final League league;
  final int id;
  final Team home;
  final Team away;
  double? homeScore;
  double? awayScore;
  final String date;
  final int? elapsed;
  final String short;
  final String? halftimeScore;
  final int? extra; // Extra can be null

  Match({
    required this.league,
    required this.id,
    required this.home,
    required this.away,
    this.homeScore,
    this.awayScore,
    required this.date,
    this.elapsed,
    required this.short,
    this.halftimeScore,
    this.extra,
  });
}
