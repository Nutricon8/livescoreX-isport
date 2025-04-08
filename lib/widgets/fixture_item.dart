import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livescorex/utils/ads/interstitial.dart';
import 'package:livescorex/utils/colors.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/views/main/home/match_details_screen.dart';
import 'package:livescorex/widgets/custom_image.dart';

class FixtureItem extends StatelessWidget {
  final Match match;
  final bool isFavorite;
  final Function(Match) onFavoriteToggle;
  final InterstitialAdHelper adHelper;
  const FixtureItem({
    super.key,
    required this.match,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.adHelper,
  });
  @override
  Widget build(BuildContext context) {
    // Parse the start_time string into a DateTime object
    DateTime dateTime = DateTime.parse(match.date).toLocal();

    // Format the DateTime object to extract only the time in "HH:mm" format
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          adHelper.showAd(
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchDetailsScreen(match: match),
                ),
              ),
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.only(right: 6.0), // Adjust padding
          child: Row(
            children: [
              // Leading: Time Card
              Container(
                constraints: const BoxConstraints(
                  minHeight: 48,
                ), // Ensure a reasonable height
                alignment: Alignment.center, // Center time text vertically
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ), // Adjust padding
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), // Adjust the radius as needed
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Text(
                  formattedTime, // Use the formatted time here
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
              ),
              SizedBox(width: 8), // Spacing

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
                        Flexible(
                          child: Text(
                            match.home.name,
                            overflow:
                                TextOverflow.ellipsis, // Prevents overflow
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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
                        Flexible(
                          child: Text(
                            match.away.name,
                            overflow:
                                TextOverflow.ellipsis, // Prevents overflow
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onFavoriteToggle(match),
                    icon: Icon(
                      Icons.star_rounded,
                      color: isFavorite ? lightGreenColor : Colors.grey,
                    ),
                    padding: EdgeInsets.zero, // Remove extra padding
                    constraints: const BoxConstraints(), // Prevent extra space
                  ),
                  const SizedBox(width: 8),
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
                      const SizedBox(height: 4),
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
