import 'dart:convert';
import 'package:livescorex/utils/models/team.dart';

class TeamConverter {
  static String encode(List<Team> teams) {
    return jsonEncode(
      teams
          .map(
            (match) => {
              'id': match.id,
              'name': match.name,
              'image': match.image,
            },
          )
          .toList(),
    );
  }

  static List<Team> decode(String teamsJson) {
    return (jsonDecode(teamsJson) as List<dynamic>)
        .map(
          (matchMap) => Team(
            id: matchMap['id'],
            name: matchMap['name'],
            image: matchMap['image'],
          ),
        )
        .toList();
  }
}
