import 'dart:convert';
import 'package:livescorex/utils/models/league.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLeagues(List<League> leagues) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String leaguesJson = jsonEncode(
    leagues.map((l) => l.toJson()).toList(),
  );
  await prefs.setString('leagues_list', leaguesJson);
}

Future<List<League>> getLeagues() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? leaguesJson = prefs.getString('leagues_list');
  if (leaguesJson == null) return [];
  final List<dynamic> decoded = jsonDecode(leaguesJson);
  return decoded
      .map((json) => League.fromJson(json as Map<String, dynamic>))
      .toList();
}

Future<void> addLeague(League newLeague) async {
  List<League> leagues = await getLeagues();
  leagues.removeWhere((l) => l.leagueId == newLeague.leagueId);
  leagues.add(newLeague);
  await saveLeagues(leagues);
}

Future<void> updateLeague(String leagueId, League updatedLeague) async {
  List<League> leagues = await getLeagues();
  int index = leagues.indexWhere((league) => league.leagueId == leagueId);
  if (index != -1) {
    leagues[index] = updatedLeague;
    await saveLeagues(leagues);
  }
}

Future<void> deleteLeague(String leagueId) async {
  List<League> leagues = await getLeagues();
  leagues.removeWhere((league) => league.leagueId == leagueId);
  await saveLeagues(leagues);
}
