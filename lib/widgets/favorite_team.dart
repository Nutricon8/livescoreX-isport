import 'package:flutter/material.dart';
import 'package:scorecast/utils/colors.dart';
import 'package:scorecast/utils/models/team.dart';
import 'package:scorecast/widgets/custom_image.dart';

class FavoriteTeam extends StatelessWidget {
  final Team team;
  final VoidCallback onRemove;
  const FavoriteTeam({super.key, required this.team, required this.onRemove});

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
            CustomImage(imageString: team.image, height: 16, width: 16),
            SizedBox(width: 4),
            Text(
              team.name,
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
