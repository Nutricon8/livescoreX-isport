import 'package:flutter/material.dart';
import 'package:livescorex/utils/colors.dart';
import 'package:livescorex/utils/format_date_time.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/widgets/custom_image.dart';

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
            match.leagueName ?? '',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            match.matchTime != null
                ? formatFullDateTime(
                  DateTime.fromMillisecondsSinceEpoch(
                    match.matchTime! * 1000,
                    isUtc: true,
                  ).toIso8601String(),
                )
                : '-',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Text(
            match.status != null
                ? "${match.status}’${match.injuryTime != null ? "+${match.injuryTime}’" : ""}"
                : '-',
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
                        imageString: match.homeId ?? '',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.homeName ?? '',
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
                        "${match.homeScore ?? '-'}-${match.awayScore ?? '-'}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.homeHalfScore != null &&
                                match.awayHalfScore != null
                            ? 'HT ${match.homeHalfScore}-${match.awayHalfScore}'
                            : (match.status?.toString() ?? '-'),
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
                        imageString: match.awayId ?? '',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.awayName ?? '',
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
