import 'package:flutter/material.dart';

class StandingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
      child: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: StandingsCard(
              index + 1,
              'Team ${index + 1}',
              30,
              18,
              6,
              6,
              60,
            ),
          );
        },
      ),
    );
  }
}

Widget StandingsCard(int position, String team, int played, int won, int drawn, int lost, int points) {
  return Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: ListTile(
        horizontalTitleGap: 16,
        minLeadingWidth: 1,
        leading: Text('$position'),
        title: Row(
          children: [
            Image.asset(
              "assets/liverpool.png",
              height: 30,
              width: 30,
            ),
            SizedBox(width: 4),
            Text(
              team,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: Text(
          '$played $won $drawn $lost $points',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
