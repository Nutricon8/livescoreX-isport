import 'package:flutter/material.dart';
import 'package:livescore_x/utils/colors.dart';
import 'package:livescore_x/utils/format_date_time.dart';
import 'package:livescore_x/utils/models/match.dart';
import 'package:livescore_x/widgets/custom_image.dart';

class LiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Match match;
  @override
  final Size preferredSize;

  LiveAppBar({required this.match, Key? key})
    : preferredSize = const Size.fromHeight(120.0),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Column(
        children: [
          Text(
            match.league.name,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            formatFullDateTime(match.date),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0), // Adjust spacing as needed
          child: Text(
            (match.short == "1H" || match.short == "2H")
                ? (match.elapsed != null
                    ? "${match.elapsed}${match.extra != null ? "+${match.extra}’" : "’"}"
                    : match.short)
                : match.short,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.0,
              color: lightGreenColor,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CustomImage(
                        imageString: match.home.image,
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.home.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 4.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${match.homeScore?.toInt() ?? '-'}-${match.awayScore?.toInt() ?? '-'}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.halftimeScore != null
                            ? 'HT ${match.halftimeScore!}'
                            : match.short,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 4.0),
                  Column(
                    children: [
                      CustomImage(
                        imageString: match.away.image,
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.away.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
