import 'package:flutter/material.dart';
import 'package:livescorex/utils/api_service.dart';
import 'package:livescorex/utils/models/match_statistics.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/widgets/custom_image.dart';

class StatisticsTab extends StatefulWidget {
  final Match match; // Accept fixture ID

  const StatisticsTab({super.key, required this.match});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep widget alive
  final ApiService _apiService = ApiService();
  List<MatchStatistics> _statistics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    //Future.microtask(() => _fetchMatchStatistics());
    _fetchMatchStatistics();
  }

  Future<void> _fetchMatchStatistics() async {
    try {
      List<MatchStatistics> stats = await _apiService.getMatchStatistics(
        widget.match.matchId,
      );
      setState(() {
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface, // Border color
          width: 1, // Border thickness
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align title to the left
          children: [
            Container(
              width: double.infinity,
              //padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(
                    imageString: /*widget.match.logo*/ '',
                    height: 20,
                    width: 20,
                  ),
                  Text(
                    'TEAM STATS',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  CustomImage(
                    imageString: /*widget.match.away.image*/ '',
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
            ),

            // Loading Indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            else if (_statistics.isEmpty)
              const Center(
                child: Text(
                  "No statistics available",
                  style: TextStyle(fontSize: 16),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _statistics.length,
                  itemBuilder: (context, index) {
                    MatchStatistics stats = _statistics[index];
                    return StatsCard(
                      homeTeam: stats.home ?? '',
                      title: matchStatTypeTitle(stats.type),
                      awayTeam: stats.away ?? '',
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String homeTeam;
  final String title;
  final String awayTeam;

  const StatsCard({
    Key? key,
    required this.homeTeam,
    required this.title,
    required this.awayTeam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            homeTeam,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Text(
            awayTeam,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

/// Returns "Unknown" for codes outside the defined range.
String matchStatTypeTitle(int? type) {
  if (type == null) return 'Unknown';
  switch (type) {
    case 0:
      return 'Kick-off';
    case 1:
      return 'First corner';
    case 2:
      return 'First yellow card';
    case 3:
      return 'Shots';
    case 4:
      return 'Shots on target';
    case 5:
      return 'Fouls';
    case 6:
      return 'Corner Kicks';
    case 7:
      return 'Corner kicks (extra time)';
    case 8:
      return 'Free kicks';
    case 9:
      return 'Offsides';
    case 10:
      return 'Own goals';
    case 11:
      return 'Yellow cards';
    case 12:
      return 'Yellow cards (extra time)';
    case 13:
      return 'Red cards';
    case 14:
      return 'Possession (%)';
    case 15:
      return 'Aerial duels';
    case 16:
      return 'Saves';
    case 17:
      return 'Goalkeeper claims';
    case 18:
      return 'Dispossessed';
    case 19:
      return 'Successful tackles';
    case 20:
      return 'Interceptions';
    case 21:
      return 'Long passes';
    case 22:
      return 'Short passes';
    case 23:
      return 'Assists';
    case 24:
      return 'Successful crosses';
    case 25:
      return 'First substitution';
    case 26:
      return 'Last substitution';
    case 27:
      return 'First offside';
    case 28:
      return 'Last offside';
    case 29:
      return 'Substitutions';
    case 30:
      return 'Last corner';
    case 31:
      return 'Last yellow card';
    case 32:
      return 'Substitution (extra time)';
    case 33:
      return 'Offside (extra time)';
    case 34:
      return 'Shots off target';
    case 35:
      return 'Hit the post';
    case 36:
      return 'Successful headers';
    case 37:
      return 'Blocked shots';
    case 38:
      return 'Tackles';
    case 39:
      return 'Dribbles';
    case 40:
      return 'Throw-ins';
    case 41:
      return 'Passes';
    case 42:
      return 'Pass accuracy (%)';
    case 43:
      return 'Attacks';
    case 44:
      return 'Dangerous attacks';
    case 45:
      return 'Corner kicks — first half';
    case 46:
      return 'Possession (%) — first half';
    case 47:
      return 'Big chances created';
    case 48:
      return 'Big chances missed';
    case 49:
      return 'Shots inside box';
    case 50:
      return 'Shots outside box';
    case 51:
      return 'Duels won';
    case 52:
      return 'Expected goals — xG';
    case 53:
      return 'xG from open play';
    case 54:
      return 'xG from set pieces';
    case 55:
      return 'xG non-penalty';
    case 56:
      return 'xG on target — xGOT';
    case 57:
      return 'Touches in opposition box';
    case 58:
      return 'Accurate crosses';
    case 59:
      return 'Ground duels won';
    case 60:
      return 'Aerial duels won';
    case 61:
      return 'Clearances';
    default:
      return 'Unknown';
  }
}
