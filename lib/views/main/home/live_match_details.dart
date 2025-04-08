import 'package:flutter/material.dart';
import 'package:livescorex/views/main/home/tabs/standings_tab.dart';
import 'package:livescorex/views/main/home/tabs/lineup_tab.dart';
import 'package:livescorex/views/main/home/tabs/statistics_tab.dart';
import 'package:livescorex/views/main/home/tabs/summary_tab.dart';
import 'package:livescorex/widgets/live_appbar.dart';
import 'package:livescorex/utils/models/match.dart';

class LiveMatchDetails extends StatelessWidget {
  final Match match;
  const LiveMatchDetails({super.key, required this.match});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiveAppBar(match: match),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            /*Row(
              children: [
                Text("HomeId: ${match.home.id}"),
                Text("MatchId: ${match.id}"),
                Text("AwayId: ${match.away.id}"),
              ],
            ),*/
            TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Text(
                    "Summary",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),

                  //text: 'Overview',
                ),
                Tab(
                  child: Text(
                    'Statistics',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
                Tab(
                  child: Text(
                    'Lineup',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
                Tab(
                  child: Text(
                    'Standings',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0), //8.0
                child: TabBarView(
                  children: [
                    SummaryTab(liveMatch: match),
                    StatisticsTab(match: match),
                    LineupTab(match: match),
                    StandingsTab(
                      leagueId: match.league.id,
                      homeTeamId: match.home.id,
                      awayTeamId: match.away.id,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
