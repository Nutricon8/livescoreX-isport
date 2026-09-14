import 'dart:convert';
import 'package:livescorex/utils/models/team.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTeams(List<Team> teams) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String teamsJson = jsonEncode(teams.map((t) => t.toJson()).toList());
  await prefs.setString('teams_list', teamsJson);
}

Future<List<Team>> getTeams() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? teamsJson = prefs.getString('teams_list');
  if (teamsJson == null) return [];
  final List<dynamic> decoded = jsonDecode(teamsJson);
  return decoded
      .map((json) => Team.fromJson(json as Map<String, dynamic>))
      .toList();
}

Future<void> addTeam(Team newTeam) async {
  List<Team> teams = await getTeams();
  teams.removeWhere((t) => t.teamId == newTeam.teamId);
  teams.add(newTeam);
  await saveTeams(teams);
}

Future<void> updateTeam(String teamId, Team updatedTeam) async {
  List<Team> teams = await getTeams();
  int index = teams.indexWhere((team) => team.teamId == teamId);
  if (index != -1) {
    teams[index] = updatedTeam;
    await saveTeams(teams);
  }
}

Future<void> deleteTeam(String teamId) async {
  List<Team> teams = await getTeams();
  teams.removeWhere((team) => team.teamId == teamId);
  await saveTeams(teams);
}
