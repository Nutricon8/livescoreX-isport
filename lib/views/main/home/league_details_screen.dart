import 'package:flutter/material.dart';
import 'package:livescore_x/views/main/home/tabs/standings_tab.dart';
import 'package:livescore_x/widgets/league_appbar.dart';
import 'package:livescore_x/utils/models/league.dart';

class LeagueDetailsScreen extends StatefulWidget {
  final League league;

  const LeagueDetailsScreen({required this.league, super.key});

  @override
  State<LeagueDetailsScreen> createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends State<LeagueDetailsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep widget alive
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LeagueAppbar(league: widget.league),
      body: StandingsTab(leagueId: widget.league.id),
    );
  }
}
