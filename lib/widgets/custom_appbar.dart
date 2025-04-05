import 'package:flutter/material.dart';
import 'package:livescore_x/utils/colors.dart';
import 'package:livescore_x/utils/favorite_teams.dart';
import 'package:livescore_x/utils/format_date_time.dart';
import 'package:livescore_x/utils/models/match.dart';
import 'package:livescore_x/utils/models/team.dart';
import 'package:livescore_x/widgets/custom_image.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Match match;
  @override
  final Size preferredSize;

  const CustomAppBar({required this.match, super.key})
    : preferredSize = const Size.fromHeight(120.0);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isHomeFavorite = false;
  bool isAwayFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    List<Team> favoriteTeams = await getTeams();
    setState(() {
      isHomeFavorite = favoriteTeams.any(
        (team) => team.id == widget.match.home.id,
      );
      isAwayFavorite = favoriteTeams.any(
        (team) => team.id == widget.match.away.id,
      );
    });
  }

  Future<void> _toggleFavorite(Team team, bool isHome) async {
    List<Team> favoriteTeams = await getTeams();
    bool isFav = favoriteTeams.any((t) => t.id == team.id);

    if (isFav) {
      await deleteTeam(team.id);
    } else {
      await addTeam(team);
    }

    setState(() {
      if (isHome) {
        isHomeFavorite = !isFav;
      } else {
        isAwayFavorite = !isFav;
      }
    });
  }

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
            widget.match.league.name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            formatFullDateTime(widget.match.date),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeam(widget.match.home, isHomeFavorite, true),
                  Column(
                    children: [
                      Text(
                        formatTime(widget.match.date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatMatchDate(widget.match.date),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  _buildTeam(widget.match.away, isAwayFavorite, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeam(Team team, bool isFavorite, bool isHome) {
    return isHome
        ? Row(
          children: [
            GestureDetector(
              onTap: () => _toggleFavorite(team, isHome),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: white6Percent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: isFavorite ? yellowColor : Colors.grey,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(imageString: team.image, height: 40, width: 40),
                const SizedBox(height: 4),
                SizedBox(
                  width: 80, // Set your preferred width here
                  child: Text(
                    team.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Adds '...'
                    softWrap: false,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        )
        : Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(imageString: team.image, height: 40, width: 40),
                const SizedBox(height: 4),
                SizedBox(
                  width: 80, // Set your preferred width here
                  child: Text(
                    team.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Adds '...'
                    softWrap: false,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _toggleFavorite(team, isHome),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: white6Percent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: isFavorite ? yellowColor : Colors.grey,
                  size: 16,
                ),
              ),
            ),
          ],
        );
  }
}
