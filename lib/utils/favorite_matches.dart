import 'package:pulsescore/utils/converters/match_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulsescore/utils/models/match.dart';

Future<void> saveMatches(List<Match> matches) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String matchesJson = MatchConverter.encode(matches);
  await prefs.setString('matches_list', matchesJson);
}

Future<List<Match>> getMatches() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? matchesJson = prefs.getString('matches_list');
  if (matchesJson == null) return [];
  return MatchConverter.decode(matchesJson);
}

Future<void> addMatch(Match newMatch) async {
  List<Match> matches = await getMatches();
  matches.add(newMatch);
  await saveMatches(matches);
}

Future<void> updateMatch(int matchId, Match updatedMatch) async {
  List<Match> matches = await getMatches();
  int index = matches.indexWhere((match) => match.id == matchId);
  if (index != -1) {
    matches[index] = updatedMatch;
    await saveMatches(matches);
  }
}

Future<void> deleteMatch(int matchId) async {
  List<Match> matches = await getMatches();
  matches.removeWhere((match) => match.id == matchId);
  await saveMatches(matches);
}
