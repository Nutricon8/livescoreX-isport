import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livescorex/utils/ads/banner.dart';
import 'package:livescorex/utils/ads/interstitial.dart';
import 'package:livescorex/utils/ads/rewarded.dart';
import 'package:livescorex/utils/api_service.dart';
import 'package:livescorex/utils/favorite_matches.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/widgets/custom_drawer.dart';
import 'package:livescorex/widgets/fixture_item.dart';
import 'package:livescorex/widgets/live_item.dart';
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
  final RewardedAdHelper rewardedAdHelper = RewardedAdHelper();

  /// leagueId -> matches, in the order chosen by [groupMatchesByLeague].
  Map<String, List<Match>> groupedMatches = {};

  String? selectedLeague;
  List<String> priorityLeagueIds = [];
  List<String> favoriteMatchIds = [];

  bool isLoading = true;
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();

    loadLeagueIds().then((ids) {
      if (!mounted) return;
      setState(() => priorityLeagueIds = ids);
      // If matches already arrived before priorities, re-sort.
      if (groupedMatches.isNotEmpty) {
        final flat = groupedMatches.values.expand((e) => e).toList();
        groupMatchesByLeague(flat);
      }
    });

    Future.microtask(() async {
      await fetchMatches();
      adHelper.loadAd();
      rewardedAdHelper.loadAd();
    });

    loadFavoriteMatches();
  }

  // --- Priority leagues ----------------------------------------------------

  Future<List<String>> loadLeagueIds() async {
    // TODO: plug in your real source. Must return league IDs as strings.
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getStringList('priorityLeagueIds') ?? <String>[];
    return <String>[];
  }

  // --- Favorites -----------------------------------------------------------

  Future<void> loadFavoriteMatches() async {
    final matches = await getMatches();
    if (!mounted) return;
    setState(() {
      favoriteMatchIds = matches.map((m) => m.matchId).toList();
    });
  }

  Future<void> toggleFavorite(Match match) async {
    final matches = await getMatches();
    final isFavorite = favoriteMatchIds.contains(match.matchId);

    if (isFavorite) {
      matches.removeWhere((m) => m.matchId == match.matchId);
    } else {
      matches.add(match);
    }

    await saveMatches(matches);
    if (!mounted) return;
    setState(() {
      favoriteMatchIds = matches.map((m) => m.matchId).toList();
    });
  }

  // --- Filtering -----------------------------------------------------------

  void filterMatchesByLeague(String? leagueId) {
    setState(() => selectedLeague = leagueId);
  }

  // --- Fetch ---------------------------------------------------------------

  Future<void> fetchMatches() async {
    setState(() => isLoading = true);

    try {
      final matches = await ApiService().getDateFixtures(selectedDate);
      debugPrint('FETCH: got ${matches.length} matches for $selectedDate');
      groupMatchesByLeague(matches);
    } catch (e, st) {
      debugPrint('fetchMatches error: $e\n$st');
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- Grouping + sorting (Match-only, no League reconstruction) ----------

  /// Groups matches by leagueId and sorts the league groups:
  ///   1. Priority leagues first, in the order they appear in
  ///      [priorityLeagueIds].
  ///   2. Remaining leagues alphabetically by `location` (country),
  ///      then by `leagueName` as a tie-breaker.
  void groupMatchesByLeague(List<Match> matches) {
    debugPrint('GROUP input: ${matches.length}');

    // 1. Group by leagueId
    final Map<String, List<Match>> tempGroupedMatches = {};
    for (final match in matches) {
      tempGroupedMatches.putIfAbsent(match.leagueId, () => []).add(match);
    }

    // 2. Sort the league IDs using a representative Match from each group
    final List<String> sortedLeagueIds = tempGroupedMatches.keys.toList();
    sortedLeagueIds.sort((aId, bId) {
      final aMatch = tempGroupedMatches[aId]!.first;
      final bMatch = tempGroupedMatches[bId]!.first;

      final aIndex = priorityLeagueIds.indexOf(aId);
      final bIndex = priorityLeagueIds.indexOf(bId);
      final aIsPriority = aIndex != -1;
      final bIsPriority = bIndex != -1;

      if (aIsPriority && bIsPriority) return aIndex.compareTo(bIndex);
      if (aIsPriority) return -1;
      if (bIsPriority) return 1;

      // Alphabetical by country (Match.location), then league name.
      final countryCompare =
      (aMatch.location ?? '').compareTo(bMatch.location ?? '');
      if (countryCompare != 0) return countryCompare;

      return (aMatch.leagueName ?? '').compareTo(bMatch.leagueName ?? '');
    });

    // 3. Rebuild the map in sorted order
    final Map<String, List<Match>> sortedGroupedMatches = {
      for (final id in sortedLeagueIds) id: tempGroupedMatches[id]!,
    };

    debugPrint('GROUP output: ${sortedGroupedMatches.length} leagues');

    // 4. Commit to state
    if (!mounted) return;
    setState(() {
      groupedMatches = sortedGroupedMatches;
      isLoading = false;

      // Drop a stale filter if the league disappeared from this date.
      if (selectedLeague != null &&
          !groupedMatches.containsKey(selectedLeague)) {
        selectedLeague = null;
      }
    });
  }

  // --- Build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin

    final entries = selectedLeague == null
        ? groupedMatches.entries
        : groupedMatches.entries.where((e) => e.key == selectedLeague);

    debugPrint(
      'BUILD: loading=$isLoading grouped=${groupedMatches.length} '
          'selected=$selectedLeague entries=${entries.length}',
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list_outlined),
              onSelected: filterMatchesByLeague,
              itemBuilder: (BuildContext context) {
                return groupedMatches.entries.map((entry) {
                  final first = entry.value.first;
                  return PopupMenuItem<String>(
                    value: entry.key,
                    child: Text(
                      '${first.location ?? ''} - ${first.leagueName ?? ''}',
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () => widget.onItemTapped(3),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchMatches,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: entries.isEmpty
              ? [
            const SliverFillRemaining(
              child: Center(child: Text('No matches available')),
            ),
          ]
              : [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  // Insert a banner ad every 6 league groups.
                  if (index > 0 && index % 6 == 0) {
                    return BannerAdWidget();
                  }

                  // Skip ad slots when mapping back to entry index.
                  final adCount = index ~/ 6;
                  final realIndex = index - adCount;
                  if (realIndex >= entries.length) {
                    return const SizedBox.shrink();
                  }

                  final entry = entries.elementAt(realIndex);

                  return _buildMatchesTab(
                    context,
                    entry.value,
                    favoriteMatchIds,
                    toggleFavorite,
                    adHelper,
                    rewardedAdHelper,
                  );
                },
                childCount:
                entries.length + (entries.length ~/ 6),
              ),
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
    List<String> favoriteMatchIds,
    Function(Match) toggleFavorite,
    InterstitialAdHelper adHelper,
    RewardedAdHelper rewardedAdHelper,
    ) {
  if (matches.isEmpty) return const SizedBox.shrink();

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];

            // Live status codes 1..5 → LiveItem, otherwise FixtureItem.
            if ([1, 2, 3, 4, 5].contains(match.status)) {
              return LiveItem(
                match: match,
                isFavorite: favoriteMatchIds.contains(match.matchId),
                onFavoriteToggle: toggleFavorite,
                rewardedAdHelper: rewardedAdHelper,
              );
            } else {
              return FixtureItem(
                match: match,
                isFavorite: favoriteMatchIds.contains(match.matchId),
                onFavoriteToggle: toggleFavorite,
                adHelper: adHelper,
              );
            }
          },
        ),
      ],
    ),
  );
}