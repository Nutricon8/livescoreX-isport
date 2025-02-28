import 'package:flutter/material.dart';
import 'package:live_score_ke/views/main/home/tabs/standings_tab.dart';
import 'package:live_score_ke/widgets/league_appbar.dart';

class LeagueDetailsScreen extends StatefulWidget {
  const LeagueDetailsScreen({super.key});

  @override
  State<LeagueDetailsScreen> createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends State<LeagueDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: PremierLeagueAppBar(), body: StandingsTab());
  }
}
