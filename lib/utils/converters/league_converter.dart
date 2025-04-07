import 'dart:convert';
import 'package:pulsescore/utils/models/league.dart';

class LeagueConverter {
  static String encode(List<League> leagues) {
    return jsonEncode(
      leagues
          .map(
            (league) => {
              'id': league.id,
              'name': league.name,
              'image': league.image,
              'country': league.country,
              'countryFlag': league.countryFlag,
            },
          )
          .toList(),
    );
  }

  static List<League> decode(String leaguesJson) {
    return (jsonDecode(leaguesJson) as List<dynamic>)
        .map(
          (leagueMap) => League(
            id: leagueMap['id'],
            name: leagueMap['name'],
            image: leagueMap['image'],
            country: leagueMap['country'],
            countryFlag: leagueMap['countryFlag'],
          ),
        )
        .toList();
  }
}
