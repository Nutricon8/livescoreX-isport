import 'package:livescore_x/utils/converters/team_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:livescore_x/utils/models/team.dart';

Future<void> saveTeams(List<Team> teams) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String teamsJson = TeamConverter.encode(teams);
  await prefs.setString('teams_list', teamsJson);
}

Future<List<Team>> getTeams() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? teamsJson = prefs.getString('teams_list');
  if (teamsJson == null) return [];
  return TeamConverter.decode(teamsJson);
}

Future<void> addTeam(Team newTeam) async {
  List<Team> teams = await getTeams();
  teams.add(newTeam);
  await saveTeams(teams);
}

Future<void> updateTeam(int teamId, Team updatedTeam) async {
  List<Team> teams = await getTeams();
  int index = teams.indexWhere((team) => team.id == teamId);
  if (index != -1) {
    teams[index] = updatedTeam;
    await saveTeams(teams);
  }
}

Future<void> deleteTeam(int teamId) async {
  List<Team> teams = await getTeams();
  teams.removeWhere((team) => team.id == teamId);
  await saveTeams(teams);
}
