import 'dart:convert';
import 'package:scorecast/utils/models/league.dart';
import 'package:scorecast/utils/models/match.dart';
import 'package:scorecast/utils/models/team.dart';

class MatchConverter {
  // Convert a list of Match objects to JSON String
  static String encode(List<Match> matches) {
    return jsonEncode(
      matches
          .map(
            (match) => {
              'league': {
                'id': match.league.id,
                'name': match.league.name,
                'image': match.league.image,
                'country': match.league.country,
                'countryFlag': match.league.countryFlag,
              },
              'id': match.id,
              'home': {
                'id': match.home.id,
                'name': match.home.name,
                'image': match.home.image,
              },
              'away': {
                'id': match.away.id,
                'name': match.away.name,
                'image': match.away.image,
              },
              'homeScore': match.homeScore,
              'awayScore': match.awayScore,
              'date': match.date,
              'elapsed': match.elapsed,
              'short': match.short,
              'halftimeScore': match.halftimeScore,
              'extra': match.extra, // Include extra field
            },
          )
          .toList(),
    );
  }

  // Convert JSON String back to List<Match>
  static List<Match> decode(String matchesJson) {
    return (jsonDecode(matchesJson) as List<dynamic>)
        .map(
          (matchMap) => Match(
            league: League(
              id: matchMap['league']['id'],
              name: matchMap['league']['name'],
              image: matchMap['league']['image'],
              country: matchMap['league']['country'],
              countryFlag: matchMap['league']['countryFlag'],
            ),
            id: matchMap['id'],
            home: Team(
              id: matchMap['home']['id'],
              name: matchMap['home']['name'],
              image: matchMap['home']['image'],
            ),
            away: Team(
              id: matchMap['away']['id'],
              name: matchMap['away']['name'],
              image: matchMap['away']['image'],
            ),
            homeScore: matchMap['homeScore'],
            awayScore: matchMap['awayScore'],
            date: matchMap['date'],
            elapsed: matchMap['elapsed'],
            short: matchMap['short'],
            halftimeScore: matchMap['halftimeScore'],
            extra: matchMap['extra'], // Include extra field
          ),
        )
        .toList();
  }
}
