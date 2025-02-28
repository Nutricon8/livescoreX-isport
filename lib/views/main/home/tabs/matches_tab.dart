import 'package:flutter/material.dart';

class MatchesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        MatchCard('Premier League', '5 Dec 2023', 'Aston Villa', 'Liverpool', '0', '5'),
        MatchCard('Premier League', '5 Dec 2023', 'Aston Villa', 'Liverpool', '0', '5'),
        MatchCard('Premier League', '5 Dec 2023', 'Aston Villa', 'Liverpool', '0', '5'),
      ],
    );
  }
}

class MatchCard extends StatelessWidget {
  final String competition;
  final String date;
  final String homeTeam;
  final String awayTeam;
  final String homeScore;
  final String awayScore;

  const MatchCard(
    this.competition,
    this.date,
    this.homeTeam,
    this.awayTeam,
    this.homeScore,
    this.awayScore, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 117, // Set the custom height here
      child: Card(
        //margin: EdgeInsets.zero, // Remove spacing between cards
        margin: EdgeInsets.symmetric(vertical: 6),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // First Row (Competition and Date)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/liverpool.png', width: 20, height: 16),
                      const SizedBox(width: 10),
                      Text(
                        competition,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    date,
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/liverpool.png', width: 20, height: 20),
                      const SizedBox(width: 10),
                      Text(
                        homeTeam,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    homeScore,
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/liverpool.png', width: 20, height: 20),
                      const SizedBox(width: 10),
                      Text(
                        awayTeam,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    awayScore,
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
    );
  }
}
