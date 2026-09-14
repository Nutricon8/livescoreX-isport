import 'package:flutter/material.dart';
import 'package:livescorex/utils/models/standing.dart';
import 'package:livescorex/widgets/custom_image.dart';

class StandingsCard extends StatelessWidget {
  final Standing standing;

  const StandingsCard({required this.standing, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      color: standing.played == 0 ? Colors.grey.withOpacity(0.4) : null, //
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
            standing.rank.toString(),
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
                  CustomImage(
                    imageString: standing.teamLogo,
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(width: 8), // Adds spacing
                  Flexible(
                    child: Text(
                      standing.teamName,
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
                  _buildStatText('${standing.played}'),
                  _buildStatText('${standing.won}'),
                  _buildStatText('${standing.drawn}'),
                  _buildStatText('${standing.lost}'),
                ],
              ),
              const SizedBox(width: 4), // Adds spacing
              SizedBox(
                width: 20, // Set a fixed width for consistency
                child: Text(
                  '${standing.goalDifference}', //+12
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${standing.points}',
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
