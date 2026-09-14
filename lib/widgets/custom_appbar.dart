import 'package:flutter/material.dart';
import 'package:livescorex/utils/colors.dart';
import 'package:livescorex/utils/favorite_leagues.dart';
import 'package:livescorex/utils/favorite_teams.dart';
import 'package:livescorex/utils/format_date_time.dart';
import 'package:livescorex/utils/models/league.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/utils/models/team.dart';
import 'package:livescorex/widgets/custom_image.dart';

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
  bool isFavoriteLeague = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    List<Team> favoriteTeams = await getTeams();
    List<League> favoriteLeagues = await getLeagues();

    setState(() {
      isHomeFavorite = favoriteTeams.any(
        (team) => team.teamId == widget.match.homeId,
      );
      isAwayFavorite = favoriteTeams.any(
        (team) => team.teamId == widget.match.awayId,
      );

      isFavoriteLeague = favoriteLeagues.any(
        (league) => league.leagueId == widget.match.leagueId,
      );
    });
  }

  Future<void> _toggleFavorite(Team team, bool isHome) async {
    List<Team> favoriteTeams = await getTeams();
    bool isFav = favoriteTeams.any((t) => t.teamId == team.teamId);

    if (isFav) {
      await deleteTeam(team.teamId);
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

  Future<void> _toggleFavoriteLeague(League league) async {
    List<League> favoriteLagues = await getLeagues();
    bool isFav = favoriteLagues.any((l) => l.leagueId == league.leagueId);

    if (isFav) {
      await deleteLeague(league.leagueId);
    } else {
      await addLeague(league);
    }

    setState(() {
      isFavoriteLeague = !isFav;
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
            widget.match.leagueName ?? '',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            widget.match.matchTime != null
                ? formatFullDateTime(
                  DateTime.fromMillisecondsSinceEpoch(
                    widget.match.matchTime! * 1000,
                    isUtc: true,
                  ).toIso8601String(),
                )
                : '-',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          padding: EdgeInsets.all(8),
          onPressed: () {
            final league = League(
              leagueId: widget.match.leagueId,
              subLeagueId: widget.match.subLeagueId,
              name: widget.match.leagueName,
              logo: widget.match.leagueColor, // Best available substitute
              shortName: widget.match.leagueShortName,
            );
            _toggleFavoriteLeague(league);
          },
          icon: Icon(
            Icons.star_rounded,
            color: isFavoriteLeague ? yellowColor : Colors.grey,
            size: 16,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeam(
                    Team(
                      teamId: widget.match.homeId ?? '',
                      leagueId: widget.match.leagueId,
                      name: widget.match.homeName ?? '',
                    ),
                    isHomeFavorite,
                    true,
                  ),
                  Column(
                    children: [
                      Text(
                        widget.match.matchTime != null
                            ? formatTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                widget.match.matchTime! * 1000,
                                isUtc: true,
                              ).toIso8601String(),
                            )
                            : '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.match.matchTime != null
                            ? formatMatchDate(
                              DateTime.fromMillisecondsSinceEpoch(
                                widget.match.matchTime! * 1000,
                                isUtc: true,
                              ).toIso8601String(),
                            )
                            : '-',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  _buildTeam(
                    Team(
                      teamId: widget.match.awayId ?? '',
                      leagueId: widget.match.leagueId,
                      name: widget.match.awayName,
                    ),
                    isAwayFavorite,
                    false,
                  ),
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
                CustomImage(
                  imageString: team.logo ?? '',
                  height: 40,
                  width: 40,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 80, // Set your preferred width here
                  child: Text(
                    team.name ?? '',
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
                CustomImage(
                  imageString: team.logo ?? '',
                  height: 40,
                  width: 40,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 80, // Set your preferred width here
                  child: Text(
                    team.name ?? '',
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
