import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scorecast/utils/ads/banner.dart';
import 'package:scorecast/utils/ads/rewarded.dart';
import 'package:scorecast/utils/api_service.dart';
import 'package:scorecast/utils/favorite_matches.dart';
import 'package:scorecast/utils/json_leagues.dart';
import 'package:scorecast/utils/models/league.dart';
import 'package:scorecast/utils/models/match.dart';
import 'package:scorecast/utils/notification_manager.dart';
import 'package:scorecast/widgets/custom_drawer.dart';
import 'package:scorecast/widgets/league_card.dart';
import 'package:scorecast/widgets/live_item.dart';

class LivePage extends StatefulWidget {
  final Function(int) onItemTapped;
  const LivePage({super.key, required this.onItemTapped});

  @override
  LivePageState createState() => LivePageState();
}

class LivePageState extends State<LivePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<int> favoriteMatchIds = [];
  late Timer _timer;
  final ValueNotifier<List<Match>> liveMatchesNotifier = ValueNotifier([]);
  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (mounted) {
        _fetchAndUpdateMatches(); // Call an async function
      }
    });
  }

  Future<void> _fetchAndUpdateMatches() async {
    try {
      List<Match> matches = await ApiService().getLiveMatches();
      liveMatchesNotifier.value = matches; // Updating ValueNotifier
      groupMatchesByLeague(liveMatchesNotifier.value);
      checkMatchUpdates(liveMatchesNotifier.value);
    } catch (e) {
      throw Exception("Error fetching matches: $e");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    liveMatchesNotifier.dispose();
    super.dispose();
  }

  final RewardedAdHelper rewardedAdHelper = RewardedAdHelper();
  Map<int, List<Match>> groupedMatches = {}; // Group matches by league ID
  bool isLoading = true;

  int? selectedLeague; // Store selected league
  List<League> leagues = []; // Store all leagues
  List<int> priorityLeagueIds = [];

  @override
  void initState() {
    super.initState();
    loadLeagueIds().then((ids) {
      setState(() {
        priorityLeagueIds = ids;
      });
    });
    fetchMatches();
    loadFavoriteMatches();
    Future.microtask(() async {
      rewardedAdHelper.loadAd();
    });
    _startAutoRefresh();
  }

  void updateLeagues() {
    setState(() {
      leagues =
          groupedMatches.keys
              .map((leagueId) => groupedMatches[leagueId]!.first.league)
              .toList();
    });
  }

  Future<void> loadFavoriteMatches() async {
    List<Match> matches = await getMatches();
    setState(() {
      favoriteMatchIds = matches.map((match) => match.id).toList();
    });
  }

  Future<void> toggleFavorite(Match match) async {
    // Load all saved favorites
    List<Match> matches = await getMatches();

    // Toggle favorite
    bool isFavorite = favoriteMatchIds.contains(match.id);
    if (isFavorite) {
      matches.removeWhere((m) => m.id == match.id);
    } else {
      matches.add(match);
    }

    // Save updated favorites
    await saveMatches(matches);

    // Ensure favoriteMatchIds is updated with all saved favorites
    setState(() {
      favoriteMatchIds = [...matches.map((m) => m.id)];
    });
  }

  void filterMatchesByLeague(int? leagueId) {
    setState(() {
      selectedLeague = leagueId;
    });
  }

  Future<void> fetchMatches() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Match> matches = (await ApiService().getLiveMatches()).cast<Match>();
      groupMatchesByLeague(matches);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void groupMatchesByLeague(List<Match> matches) {
    Map<int, List<Match>> tempGroupedMatches = {};

    for (var match in matches) {
      int leagueId = match.league.id;

      if (!tempGroupedMatches.containsKey(leagueId)) {
        tempGroupedMatches[leagueId] = [];
      }
      tempGroupedMatches[leagueId]!.add(match);
    }

    // Extract leagues and sort them first by country name, then by priority
    List<League> sortedLeagues =
        tempGroupedMatches.keys
            .map(
              (id) => tempGroupedMatches[id]![0].league,
            ) // Get league from matches
            .toList()
          ..sort((a, b) {
            bool aIsPriority = priorityLeagueIds.contains(a.id);
            bool bIsPriority = priorityLeagueIds.contains(b.id);

            if (aIsPriority && bIsPriority) {
              // Sort by the order in priorityLeagueIds
              return priorityLeagueIds.indexOf(a.id) -
                  priorityLeagueIds.indexOf(b.id);
            }
            if (aIsPriority) return -1; // a comes first
            if (bIsPriority) return 1; // b comes first

            // If both are not in priorityLeagueIds, sort by country name alphabetically
            return a.country.compareTo(b.country);
          });

    // Reconstruct the sorted map
    Map<int, List<Match>> sortedGroupedMatches = {
      for (var league in sortedLeagues)
        league.id: tempGroupedMatches[league.id]!,
    };

    setState(() {
      groupedMatches = sortedGroupedMatches;
      isLoading = false;
      updateLeagues(); // Update available leagues
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Since we're using AutomaticKeepAliveClientMixin

    var filteredMatches =
        selectedLeague == null
            ? groupedMatches.entries
            : groupedMatches.entries.where(
              (entry) => entry.key == selectedLeague,
            );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            PopupMenuButton<int>(
              icon: Icon(Icons.filter_list_outlined), // Only the icon is shown
              onSelected: (int newLeagueId) {
                filterMatchesByLeague(newLeagueId); // Pass int
              },
              itemBuilder: (BuildContext context) {
                return groupedMatches.keys.map((int leagueId) {
                  return PopupMenuItem<int>(
                    value: leagueId,
                    child: Text(
                      "${groupedMatches[leagueId]![0].league.country} - ${groupedMatches[leagueId]![0].league.name}",
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),

        actions: [
          Container(
            width: 41.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: Colors.red, // Set the background color to red
              borderRadius: BorderRadius.circular(
                20.0,
              ), // Set the border radius
            ),
            child: Center(
              child: Text(
                "LIVE",
                style: TextStyle(
                  color:
                      Colors
                          .white, // Text color to contrast with the red background
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0, // Adjust font size if needed
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              widget.onItemTapped(3);
            },
            icon: const Icon(Icons.person_pin),
          ),
        ],
      ),
      drawer: CustomDrawer(onItemTapped: widget.onItemTapped),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers:
                    filteredMatches.isEmpty
                        ? [
                          SliverFillRemaining(
                            child: Center(child: Text("No matches available")),
                          ),
                        ]
                        : [
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              var entry = filteredMatches.elementAt(index);

                              final adIndex = index ~/ 6;
                              if (index > 0 && index % 6 == 0) {
                                return BannerAdWidget();
                              }
                              final matchIndex = index - adIndex;
                              if (matchIndex >= groupedMatches.length) {
                                return SizedBox.shrink();
                              }

                              return _buildMatchesTab(
                                context,
                                entry.value,
                                favoriteMatchIds,
                                toggleFavorite,
                                rewardedAdHelper,
                              );
                            }, childCount: filteredMatches.length),
                          ),
                        ],
              ),
    );
  }
}

Widget _buildMatchesTab(
  BuildContext context,
  List<Match> matches,
  List<int> favoriteMatchIds,
  Function(Match) toggleFavorite,
  RewardedAdHelper rewardedAdHelper,
) {
  if (matches.isEmpty) return SizedBox();
  Match firstMatch = matches.first;
  League league = firstMatch.league;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LeagueCard(league: league),

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            Match match = matches[index];
            return LiveItem(
              match: match,
              isFavorite: favoriteMatchIds.contains(matches[index].id),
              onFavoriteToggle: toggleFavorite,
              rewardedAdHelper: rewardedAdHelper,
            );
          },
        ),
      ],
    ),
  );
}
