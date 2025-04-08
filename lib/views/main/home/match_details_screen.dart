import 'package:flutter/material.dart';
import 'package:livescorex/utils/ads/banner.dart';
import 'package:livescorex/views/main/home/tabs/lineup_tab.dart';
import 'package:livescorex/views/main/home/tabs/matches_tab.dart';
import 'package:livescorex/views/main/home/tabs/standings_tab.dart';
import 'package:livescorex/widgets/custom_appbar.dart';
import 'package:livescorex/utils/models/match.dart';

class MatchDetailsScreen extends StatelessWidget {
  final Match match;
  MatchDetailsScreen({required this.match});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(match: match),
      body: DefaultTabController(
        length: 3,
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
                    "Overview",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),

                  //text: 'Overview',
                ),
                Tab(
                  child: Text(
                    'Matches',
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
              child: TabBarView(
                children: [
                  LineupTab(match: match),
                  MatchesTab(match: match),
                  StandingsTab(
                    homeTeamId: match.home.id,
                    awayTeamId: match.away.id,
                    leagueId: match.league.id,
                  ),
                ],
              ),
            ),
            BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
