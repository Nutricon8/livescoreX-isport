import 'package:flutter/material.dart';
import 'package:pulsescore/utils/api_service.dart';
import 'package:pulsescore/utils/models/standing.dart';

import '../../../../widgets/standing_card.dart';

class StandingsTab extends StatefulWidget {
  final int homeTeamId;
  final int awayTeamId;
  final int leagueId;

  const StandingsTab({
    this.homeTeamId = 0,
    this.awayTeamId = 0,
    this.leagueId = 0,
    super.key,
  });

  @override
  _StandingsTabState createState() => _StandingsTabState();
}

class _StandingsTabState extends State<StandingsTab> {
  @override
  bool get wantKeepAlive => true; // Keep widget alive
  late Future<List<Standing>> futureStandings;
  @override
  void initState() {
    super.initState();
    futureStandings = ApiService().getStandings(widget.leagueId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align title to the left
        children: [
          ListTile(
            horizontalTitleGap: 8,
            minLeadingWidth: 0,
            contentPadding: const EdgeInsets.only(left: 12.0, right: 4),
            leading: Text(
              '#',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            title: Text(
              'Team',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _buildStatText('M'),
                    _buildStatText('W'),
                    _buildStatText('D'),
                    _buildStatText('L'),
                  ],
                ),
                const SizedBox(width: 4), // Adds spacing
                SizedBox(
                  width: 20, // Set a fixed width for consistency
                  child: Text(
                    'GD',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'PTS',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Standings ListView
          Expanded(
            child: FutureBuilder<List<Standing>>(
              future: futureStandings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('An error occured while fetching standings'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No standings available'));
                } else {
                  final standingsList = snapshot.data!;
                  return ListView.builder(
                    itemCount: standingsList.length,
                    itemBuilder: (context, index) {
                      final standing = standingsList[index];
                      return StandingsCard(
                        position: standing.position,
                        team: standing.team,
                        crest: standing.crest,
                        played: standing.played,
                        won: standing.won,
                        drawn: standing.drawn,
                        lost: standing.lost,
                        goalDifference: standing.goalDifference,
                        points: standing.points,
                        playing:
                            (standing.id == widget.homeTeamId) ||
                            (standing.id == widget.awayTeamId),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatText(String value) {
  return SizedBox(
    width: 20, // Set a fixed width for consistency
    child: Text(
      value,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),
  );
}
