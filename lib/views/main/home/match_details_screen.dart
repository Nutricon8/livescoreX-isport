import 'package:flutter/material.dart';
import 'package:live_score_ke/views/main/home/tabs/matches_tab.dart';
import 'package:live_score_ke/views/main/home/tabs/overview_tab.dart';
import 'package:live_score_ke/views/main/home/tabs/standings_tab.dart';
import 'package:live_score_ke/widgets/custom_appbar.dart';

class MatchDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Matches'),
                Tab(text: 'Standings'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [OverviewTab(), MatchesTab(), StandingsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
