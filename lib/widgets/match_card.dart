import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livescore_x/utils/models/match.dart';
import 'package:livescore_x/views/main/home/match_details_screen.dart';
import 'package:livescore_x/widgets/custom_image.dart';

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({required this.match, super.key});

  @override
  Widget build(BuildContext context) {
    String formatUtcDate(String utcDate) {
      DateTime dateTime = DateTime.parse(utcDate).toLocal();
      return DateFormat("d MMM yyyy").format(dateTime);
    }

    return SizedBox(
      height: 117, // Set the custom height here
      child: Card(
        //margin: EdgeInsets.zero, // Remove spacing between cards
        margin: EdgeInsets.symmetric(vertical: 6),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchDetailsScreen(match: match),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // First Row (Competition and Date)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          imageString: match.league.image,
                          height: 20,
                          width: 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          match.league.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formatUtcDate(match.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Second Row (Home Team and Score)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          imageString: match.home.image,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          match.home.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${match.homeScore?.toInt() ?? '-'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Third Row (Away Team and Score)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          imageString: match.away.image,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          match.away.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${match.awayScore?.toInt() ?? '-'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
