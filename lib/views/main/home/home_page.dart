import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pulsescore/utils/ads/banner.dart';
import 'package:pulsescore/utils/ads/interstitial.dart';
import 'package:pulsescore/utils/api_service.dart';
import 'package:pulsescore/utils/favorite_matches.dart';
import 'package:pulsescore/utils/json_leagues.dart';
import 'package:pulsescore/utils/models/league.dart';
import 'package:pulsescore/utils/models/match.dart';
import 'package:pulsescore/widgets/custom_drawer.dart';
import 'package:pulsescore/widgets/fixture_item.dart';
import 'package:pulsescore/widgets/league_card.dart';
import '../../../widgets/DateScrollWidget.dart';

class HomePage extends StatefulWidget {
  final Function(int) onItemTapped;
  const HomePage({super.key, required this.onItemTapped});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final InterstitialAdHelper adHelper = InterstitialAdHelper();
  late Map<int, List<Match>> groupedMatches = {};

  int? selectedLeague;
  List<League> leagues = [];
  List<int> priorityLeagueIds = [];
  List<int> favoriteMatchIds = [];

  bool isLoading = true;
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    loadLeagueIds().then((ids) {
      setState(() {
        priorityLeagueIds = ids;
      });
    });
    Future.microtask(() async {
      await fetchMatches();
      adHelper.loadAd();
    });
    loadFavoriteMatches();
  }

  Future<void> loadFavoriteMatches() async {
    List<Match> matches = await getMatches();
    setState(() {
      favoriteMatchIds = matches.map((match) => match.id).toList();
    });
  }

  Future<void> toggleFavorite(Match match) async {
    List<Match> matches = await getMatches();
    bool isFavorite = favoriteMatchIds.contains(match.id);

    if (isFavorite) {
      matches.removeWhere((m) => m.id == match.id);
    } else {
      matches.add(match);
    }

    await saveMatches(matches);
    setState(() {
      favoriteMatchIds = matches.map((m) => m.id).toList();
    });
  }

  void updateLeagues() {
    setState(() {
      leagues =
          groupedMatches.keys
              .map((leagueId) => groupedMatches[leagueId]!.first.league)
              .toList();
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
      List<Match> matches =
          (await ApiService().getDateFixtures(selectedDate)).cast<Match>();
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
          /*..sort((a, b) {
            bool aIsPriority = priorityLeagueIds.contains(a.id);
            bool bIsPriority = priorityLeagueIds.contains(b.id);

            if (aIsPriority && !bIsPriority) return -1; // a comes first
            if (!aIsPriority && bIsPriority) return 1; // b comes first

            // If both are priority or neither is, sort by country name alphabetically
            return a.country.compareTo(b.country);
          });*/
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
      updateLeagues();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              icon: Icon(Icons.filter_list_outlined),
              onSelected: (int newLeagueId) {
                filterMatchesByLeague(newLeagueId);
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

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: DateScrollWidget(
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
                selectedLeague = null;
              });
              fetchMatches();
            },
          ),
        ),
      ),
      drawer: CustomDrawer(onItemTapped: widget.onItemTapped),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchMatches,
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers:
                      filteredMatches.isEmpty
                          ? [
                            SliverFillRemaining(
                              child: Center(
                                child: Text("No matches available"),
                              ),
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
                                  adHelper,
                                );
                              }, childCount: filteredMatches.length),
                            ),
                          ],
                ),
              ),
    );
  }
}

Widget _buildMatchesTab(
  BuildContext context,
  List<Match> matches,
  List<int> favoriteMatchIds,
  Function(Match) toggleFavorite,
  InterstitialAdHelper adHelper,
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
            return FixtureItem(
              match: match,
              isFavorite: favoriteMatchIds.contains(matches[index].id),
              onFavoriteToggle: toggleFavorite,
              adHelper: adHelper,
            );
          },
        ),
      ],
    ),
  );
}
