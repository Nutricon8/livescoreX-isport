import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pulsescore/utils/models/league.dart';
import 'package:pulsescore/views/main/home/league_details_screen.dart';
import 'package:pulsescore/widgets/custom_image.dart';

class LeagueCard extends StatelessWidget {
  final League league;

  LeagueCard({required this.league});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeagueDetailsScreen(league: league),
          ),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero, // Ensure no extra padding
        dense: true, // Reduces height by tightening spacing
        visualDensity: VisualDensity(
          vertical: -4,
        ), // Further compress vertical space
        leading: Container(
          width: 24,
          height: 24,
          padding: EdgeInsets.symmetric(vertical: 4.14),
          child: SvgPicture.network(
            league.countryFlag,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
            placeholderBuilder:
                (BuildContext context) =>
                    const Center(child: Icon(Icons.sports_soccer, size: 24)),
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.sports_soccer, size: 24); // Fallback icon
            },
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              league.country,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
            ),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CustomImage(
                imageString: league.image,
                width: 16,
                height: 16,
                isCover: true,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                league.name,
                overflow: TextOverflow.ellipsis, // Prevents overflow
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
