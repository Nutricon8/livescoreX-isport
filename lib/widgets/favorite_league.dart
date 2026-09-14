import 'package:flutter/material.dart';
import 'package:livescorex/utils/colors.dart';
import 'package:livescorex/utils/models/league.dart';
import 'package:livescorex/widgets/custom_image.dart';

class FavoriteLeague extends StatelessWidget {
  final League league;
  final VoidCallback onRemove;
  const FavoriteLeague({
    super.key,
    required this.league,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        title: Row(
          children: [
            CustomImage(imageString: league.logo ?? '', height: 16, width: 16),
            SizedBox(width: 4),
            Text(
              league.name ?? '',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: IconButton(
          padding: EdgeInsets.all(8),
          onPressed: onRemove,
          icon: Icon(Icons.star_rounded, color: lightGreenColor, size: 28),
        ),
      ),
    );
  }
}
