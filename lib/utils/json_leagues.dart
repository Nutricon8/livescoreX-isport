import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<int>> loadLeagueIds() async {
  // Load the JSON file
  String jsonString = await rootBundle.loadString('assets/leagues.json');

  // Decode the JSON
  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // Extract IDs
  List<int> priorityLeagueIds =
      (jsonData['leagues'] as List)
          .map((league) => league['id'] as int)
          .toList();

  return priorityLeagueIds;
}
