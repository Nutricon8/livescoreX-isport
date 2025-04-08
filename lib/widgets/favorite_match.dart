import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livescorex/utils/colors.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/views/main/home/match_details_screen.dart';
import 'package:livescorex/widgets/custom_image.dart';

class FavoriteMatch extends StatelessWidget {
  final Match match;
  final VoidCallback onRemove; // New callback for remove action
  const FavoriteMatch({super.key, required this.match, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    // Parse the start_time string into a DateTime object
    DateTime dateTime = DateTime.parse(match.date).toLocal();
    // Format the DateTime object to extract only the date (e.g., "01 Apr")
    String formattedDate = DateFormat('dd MMM').format(dateTime);

    // Format the DateTime object to extract only the time (e.g., "21:25")
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
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
        child: Padding(
          padding: EdgeInsets.only(right: 6.0), // Adjust padding
          child: Row(
            children: [
              // Leading: Time Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.center, // Center time text vertically
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), // Adjust the radius as needed
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                constraints: BoxConstraints(minHeight: 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 8.0,
                        color: lightGreenColor,
                      ),
                    ),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8), // Spacing
              // Title & Subtitle (Teams)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          imageString: match.home.image,
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          match.home.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomImage(
                          imageString: match.away.image,
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          match.away.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Trailing: Icon + Odds
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onRemove, // Show bottom sheet on click
                    icon: Icon(Icons.star_rounded, color: lightGreenColor),
                    padding: EdgeInsets.zero, // Remove extra padding
                    constraints: BoxConstraints(), // Prevent extra space
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.end, // Align odds to right
                    children: [
                      Text(
                        match.homeScore != null
                            ? match.homeScore!.toString()
                            : "-",
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.awayScore != null
                            ? match.awayScore!.toString()
                            : "-",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
