import 'package:pulsescore/utils/converters/league_converter.dart';
import 'package:pulsescore/utils/models/league.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLeagues(List<League> leagues) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String leaguesJson = LeagueConverter.encode(leagues);
  await prefs.setString('leagues_list', leaguesJson);
}

Future<List<League>> getLeagues() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? leaguesJson = prefs.getString('leagues_list');
  if (leaguesJson == null) return [];
  return LeagueConverter.decode(leaguesJson);
}

Future<void> addLeague(League newLeague) async {
  List<League> leagues = await getLeagues();
  leagues.add(newLeague);
  await saveLeagues(leagues);
}

Future<void> updateLeague(int leagueId, League updatedLeague) async {
  List<League> leagues = await getLeagues();
  int index = leagues.indexWhere((team) => team.id == leagueId);
  if (index != -1) {
    leagues[index] = updatedLeague;
    await saveLeagues(leagues);
  }
}

Future<void> deleteLeague(int leagueId) async {
  List<League> leagues = await getLeagues();
  leagues.removeWhere((league) => league.id == leagueId);
  await saveLeagues(leagues);
}
