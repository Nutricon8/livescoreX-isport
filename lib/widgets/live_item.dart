import 'package:flutter/material.dart';
import 'package:livescorex/utils/ads/rewarded.dart';
import 'package:livescorex/utils/colors.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/views/main/home/live_match_details.dart';
import 'package:livescorex/widgets/custom_image.dart';

class LiveItem extends StatelessWidget {
  final Match match;
  final bool isFavorite;
  final Function(Match) onFavoriteToggle;
  final RewardedAdHelper rewardedAdHelper;
  LiveItem({
    required this.match,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.rewardedAdHelper,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          rewardedAdHelper.showAd(
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveMatchDetails(match: match),
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
                constraints: BoxConstraints(
                  minHeight: 48,
                ), // Ensure a reasonable height
                alignment: Alignment.center, // Center time text vertically
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ), // Adjust padding
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), // Adjust the radius as needed
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Text(
                  match.status != null
                      ? "${match.status}’${match.injuryTime != null ? "+${match.injuryTime}’" : ""}"
                      : '-',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.0,
                    color: lightGreenColor,
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
                          imageString: match.homeTeamLogo ?? '',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          match.homeName ?? '',
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
                          imageString: match.awayId ?? '',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          match.awayName ?? '',
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

              // Trailing
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => onFavoriteToggle(match),
                      icon: Icon(
                        Icons.star_rounded,
                        color: isFavorite ? lightGreenColor : Colors.grey,
                      ),
                      padding: EdgeInsets.zero, // Remove extra padding
                      constraints:
                          const BoxConstraints(), // Prevent extra space
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          CrossAxisAlignment.end, // Align odds to right
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          "${match.homeScore ?? '-'}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                            color: lightGreenColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          textAlign: TextAlign.center,
                          "${match.awayScore ?? '-'}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                            color: lightGreenColor,
                          ),
                        ),
                      ],
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
