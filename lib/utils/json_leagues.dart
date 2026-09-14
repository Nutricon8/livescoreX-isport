import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> loadLeagueIds() async {
  // Load the JSON file
  String jsonString = await rootBundle.loadString('assets/leagues.json');

  // Decode the JSON
  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // Extract IDs
  List<String> priorityLeagueIds =
      (jsonData['leagues'] as List)
          .map((league) => league['leagueId'] as String)
          .toList();

  return priorityLeagueIds;
}
