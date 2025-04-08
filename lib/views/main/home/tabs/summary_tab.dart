import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livescorex/utils/api_service.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/utils/models/match_event.dart';

class SummaryTab extends StatelessWidget {
  final Match liveMatch;
  const SummaryTab({super.key, required this.liveMatch});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MatchEvent>>(
      future: ApiService().getMatchSummary(liveMatch.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text("An error occurred while trying to fetch match events"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No match events available"));
        }

        List<MatchEvent> events = snapshot.data!;

        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: events.length,
              itemBuilder: (context, index) {
                MatchEvent event = events[index];
                return SummaryEvent(liveMatch: liveMatch, matchEvent: event);
              },
            ),
          ),
        );
      },
    );
  }
}

class SummaryEvent extends StatelessWidget {
  final Match liveMatch;
  final MatchEvent matchEvent;

  const SummaryEvent({
    super.key,
    required this.liveMatch,
    required this.matchEvent,
  });

  @override
  Widget build(BuildContext context) {
    bool isHomeTeam = matchEvent.teamId == liveMatch.home.id;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          /// **Home Team Event (Left Side)**
          Expanded(
            flex: 2,
            child: isHomeTeam ? _buildEventDetailsHome() : const SizedBox(),
          ),

          /// **Match Time & Score (Center)**
          Expanded(
            flex: 1, // Keeps time column centered
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${matchEvent.time}'",
                  style: const TextStyle(fontSize: 14),
                ),
                if (matchEvent.eventType == "Goal")
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "${liveMatch.homeScore?.toInt()} - ${liveMatch.awayScore?.toInt()}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// **Away Team Event (Right Side)**
          Expanded(
            flex: 2,
            child: !isHomeTeam ? _buildEventDetailsAway() : const SizedBox(),
          ),
        ],
      ),
    );
  }

  /// **Event Details with Icon & Player Names**
  Widget _buildEventDetailsHome() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centers event details
      mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
      children: [
        /// **Player Name & Assist (Prevents Overflow)**
        Expanded(
          // Ensures text adapts to available space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                matchEvent.playerName,
                style: const TextStyle(fontSize: 14),
                maxLines: 1, // Limits text to one line
                overflow:
                    TextOverflow.ellipsis, // Adds "..." if text is too long
              ),
              if (matchEvent.assistPlayer.isNotEmpty)
                Text(
                  matchEvent.assistPlayer,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),

        /// **Event Icon**
        if (matchEvent.eventType == "Card")
          Icon(
            FontAwesomeIcons.solidSquare,
            color:
                matchEvent.eventDetail == "Yellow Card"
                    ? Colors.yellow
                    : Colors.red,
            size: 14,
          )
        else if (matchEvent.eventType == "subst")
          const Icon(FontAwesomeIcons.arrowRightArrowLeft, size: 14)
        else if (matchEvent.eventType == "Goal")
          const Icon(FontAwesomeIcons.futbol, size: 14)
        else
          const Icon(FontAwesomeIcons.circleDot),

        const SizedBox(width: 6),
      ],
    );
  }

  /// **Event Details with Icon & Player Names**
  Widget _buildEventDetailsAway() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centers event details
      mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
      children: [
        /// **Event Icon**
        if (matchEvent.eventType == "Card")
          Icon(
            FontAwesomeIcons.solidSquare,
            color:
                matchEvent.eventDetail == "Yellow Card"
                    ? Colors.yellow
                    : Colors.red,
            size: 14,
          )
        else if (matchEvent.eventType == "subst")
          const Icon(FontAwesomeIcons.arrowRightArrowLeft, size: 14)
        else if (matchEvent.eventType == "Goal")
          const Icon(FontAwesomeIcons.futbol, size: 14)
        else
          const Icon(FontAwesomeIcons.circleDot, size: 14),

        const SizedBox(width: 6),

        /// **Player Name & Assist (Prevents Overflow)**
        Expanded(
          // Ensures text adapts to available space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                matchEvent.playerName,
                style: const TextStyle(fontSize: 14),
                maxLines: 1, // Limits text to one line
                overflow:
                    TextOverflow.ellipsis, // Adds "..." if text is too long
              ),
              if (matchEvent.assistPlayer.isNotEmpty)
                Text(
                  matchEvent.assistPlayer,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
