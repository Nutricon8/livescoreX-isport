import 'package:flutter/material.dart';
import 'package:livescore_x/widgets/custom_image.dart';

class StandingsCard extends StatelessWidget {
  final int position;
  final String team;
  final String crest;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalDifference;
  final int points;
  final bool playing;

  const StandingsCard({
    Key? key,
    required this.position,
    required this.team,
    required this.crest,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalDifference,
    required this.points,
    required this.playing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      color: playing ? Colors.grey.withOpacity(0.4) : null, //
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: ListTile(
          horizontalTitleGap: 8,
          minLeadingWidth: 8,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: Text(
            '$position',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4,
              ), // Limit width to 40% of screen
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Prevents Row from taking full width
                children: [
                  CustomImage(imageString: crest, height: 20, width: 20),
                  const SizedBox(width: 8), // Adds spacing
                  Flexible(
                    child: Text(
                      team,
                      overflow: TextOverflow.ellipsis, // Prevents overflow
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _buildStatText('$played'),
                  _buildStatText('$won'),
                  _buildStatText('$drawn'),
                  _buildStatText('$lost'),
                ],
              ),
              const SizedBox(width: 4), // Adds spacing
              SizedBox(
                width: 20, // Set a fixed width for consistency
                child: Text(
                  '$goalDifference', //+12
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$points',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
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
