import 'package:flutter/material.dart';
import 'package:pulsescore/utils/api_service.dart';
import 'package:pulsescore/utils/models/match_statistics.dart';
import 'package:pulsescore/utils/models/match.dart';
import 'package:pulsescore/widgets/custom_image.dart';

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
        widget.match.id,
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
                    imageString: widget.match.home.image,
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
                    imageString: widget.match.away.image,
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
                      homeTeam: stats.home,
                      title: stats.type,
                      awayTeam: stats.away,
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
  final int homeTeam;
  final String title;
  final int awayTeam;

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
      // Use padding instead of margin
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            homeTeam.toString(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Text(
            awayTeam.toString(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
