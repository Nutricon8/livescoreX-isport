import 'dart:convert';
import 'package:livescorex/utils/models/match.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveMatches(List<Match> matches) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String matchesJson = jsonEncode(
    matches.map((m) => m.toJson()).toList(),
  );
  await prefs.setString('matches_list', matchesJson);
}

Future<List<Match>> getMatches() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? matchesJson = prefs.getString('matches_list');
  if (matchesJson == null) return [];
  final List<dynamic> decoded = jsonDecode(matchesJson);
  return decoded
      .map((json) => Match.fromJson(json as Map<String, dynamic>))
      .toList();
}

Future<void> addMatch(Match newMatch) async {
  List<Match> matches = await getMatches();
  matches.removeWhere((m) => m.matchId == newMatch.matchId);
  matches.add(newMatch);
  await saveMatches(matches);
}

Future<void> updateMatch(String matchId, Match updatedMatch) async {
  List<Match> matches = await getMatches();
  int index = matches.indexWhere((match) => match.matchId == matchId);
  if (index != -1) {
    matches[index] = updatedMatch;
    await saveMatches(matches);
  }
}

Future<void> deleteMatch(String matchId) async {
  List<Match> matches = await getMatches();
  matches.removeWhere((match) => match.matchId == matchId);
  await saveMatches(matches);
}
