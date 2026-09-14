import 'package:flutter/material.dart';
import 'package:livescorex/utils/api_service.dart';
import 'package:livescorex/utils/models/standing.dart';

import '../../../../widgets/standing_card.dart';

class StandingsTab extends StatefulWidget {
  final String homeTeamId;
  final String awayTeamId;
  final String leagueId;
  final String subLeagueId;

  const StandingsTab({
    required this.homeTeamId,
    required this.awayTeamId,
    required this.leagueId,
    required this.subLeagueId,
    super.key,
  });

  @override
  _StandingsTabState createState() => _StandingsTabState();
}

class _StandingsTabState extends State<StandingsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<Standing>> futureStandings;

  @override
  void initState() {
    super.initState();
    futureStandings = ApiService().getStandings(widget.leagueId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header row ----
          ListTile(
            horizontalTitleGap: 8,
            minLeadingWidth: 0,
            contentPadding: const EdgeInsets.only(left: 12.0, right: 4),
            leading: const Text(
              '#',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            title: const Text(
              'Team',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatText('M'),
                _buildStatText('W'),
                _buildStatText('D'),
                _buildStatText('L'),
                const SizedBox(width: 4),
                _buildStatText('GD'),
                const SizedBox(width: 4),
                const SizedBox(
                  width: 20,
                  child: Text(
                    'PTS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---- Standings list ----
          Expanded(
            child: FutureBuilder<List<Standing>>(
              future: futureStandings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No standings available'));
                }

                final standingsList = snapshot.data!;
                return ListView.builder(
                  itemCount: standingsList.length,
                  itemBuilder: (context, index) {
                    final standing = standingsList[index];
                    return StandingsCard(standing: standing);
                  },
                );
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
    width: 20,
    child: Text(
      value,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),
  );
}