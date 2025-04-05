import 'package:flutter/material.dart';
import 'package:livescore_x/utils/ads/banner.dart';
import 'package:livescore_x/utils/api_service.dart';
import 'package:livescore_x/utils/models/match.dart';
import 'package:livescore_x/widgets/match_card.dart';

class MatchesTab extends StatefulWidget {
  final Match match;

  const MatchesTab({required this.match, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MatchesTabState createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  List<Match> matches = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchHeadToHeadMatches();
  }

  Future<void> fetchHeadToHeadMatches() async {
    try {
      List<Match> fetchedMatches = await ApiService().getHeadToHeadMatches(
        '${widget.match.home.id}-${widget.match.away.id}',
      );

      setState(() {
        matches = fetchedMatches;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching matches: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (matches.isEmpty) {
      return Center(child: Text("No Head To Head matches Available"));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        var match = matches[index];
        // Show an ad after every 3 matches
        if (index > 0 && index % 3 == 0) {
          return BannerAdWidget();
        }
        return MatchCard(match: match);
      },
    );
  }
}
