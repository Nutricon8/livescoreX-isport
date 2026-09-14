import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livescorex/utils/ads/banner.dart';
import 'package:livescorex/utils/ads/rewarded.dart';
import 'package:livescorex/utils/api_service.dart';
import 'package:livescorex/utils/favorite_matches.dart';
import 'package:livescorex/utils/models/league.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/utils/notification_manager.dart';
import 'package:livescorex/widgets/custom_drawer.dart';
import 'package:livescorex/widgets/live_item.dart';

import 'league_details_screen.dart';

class LivePage extends StatefulWidget {
  final Function(int) onItemTapped;
  const LivePage({super.key, required this.onItemTapped});

  @override
  LivePageState createState() => LivePageState();
}

class LivePageState extends State<LivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> favoriteMatchIds = [];
  late Timer _timer;
  final ValueNotifier<List<Match>> liveMatchesNotifier = ValueNotifier([]);

  final RewardedAdHelper rewardedAdHelper = RewardedAdHelper();

  // leagueId -> list of matches (sorted by league order)
  Map<String, List<Match>> groupedMatches = {};

  bool isLoading = true;
  String? selectedLeague;
  List<String> priorityLeagueIds = [];

  // Cache the full League list once so we can look up logos etc. when tapped.
  List<League> _allLeagues = [];

  @override
  void initState() {
    super.initState();

    loadLeagueIds().then((ids) {
      if (!mounted) return;
      setState(() => priorityLeagueIds = ids);
      if (groupedMatches.isNotEmpty) {
        final flat = groupedMatches.values.expand((e) => e).toList();
        groupMatchesByLeague(flat);
      }
    });

    fetchMatches();
    loadFavoriteMatches();
    _preloadLeagues();

    Future.microtask(() async {
      rewardedAdHelper.loadAd();
    });

    _startAutoRefresh();
  }

  // --- Leagues (for the details screen lookup) -----------------------------

  Future<void> _preloadLeagues() async {
    try {
      final leagues = await ApiService().getLeagues();
      if (!mounted) return;
      _allLeagues = leagues;
    } catch (e, st) {
      debugPrint('preloadLeagues error: $e\n$st');
    }
  }

  /// Builds a [League] from the first [Match] in a group.
  /// Uses the cached [_allLeagues] when possible so the logo/name/country
  /// are the real ones; otherwise falls back to a partial League built
  /// straight from the match's flat fields.
  League _leagueFromMatch(Match match) {
    // Try the cache first.
    for (final l in _allLeagues) {
      if (l.leagueId == match.leagueId) return l;
    }

    // Fallback — build a partial League in-place.
    // Only the fields used by LeagueDetailsScreen / LeagueAppbar matter.
    return League(
      leagueId: match.leagueId,
      name: match.leagueName ?? match.leagueShortName ?? '',
      shortName: match.leagueShortName,
      logo: null,
      color: match.leagueColor,
      country: match.location,
      subLeagueId: match.subLeagueId,
      subLeagueName: match.subLeagueName,
    );
  }

  void _openLeagueDetails(Match first) {
    final league = _leagueFromMatch(first);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeagueDetailsScreen(league: league),
      ),
    );
  }

  // --- Priority leagues ----------------------------------------------------

  Future<List<String>> loadLeagueIds() async {
    // TODO: replace with your real source.
    return <String>[];
  }

  // --- Auto refresh --------------------------------------------------------

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) _fetchAndUpdateMatches();
    });
  }

  Future<void> _fetchAndUpdateMatches() async {
    try {
      final matches = await ApiService().getLiveMatches(true);
      liveMatchesNotifier.value = matches;
      groupMatchesByLeague(matches);
      checkMatchUpdates(matches);
    } catch (e, st) {
      debugPrint('auto-refresh error: $e\n$st');
    }
  }

  // --- Initial fetch -------------------------------------------------------

  Future<void> fetchMatches() async {
    setState(() => isLoading = true);
    try {
      final matches = await ApiService().getLiveMatches(true);
      debugPrint('fetchMatches: got ${matches.length} matches');
      groupMatchesByLeague(matches);
    } catch (e, st) {
      debugPrint('fetchMatches error: $e\n$st');
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- Grouping + sorting --------------------------------------------------

  void groupMatchesByLeague(List<Match> matches) {
    final Map<String, List<Match>> tempGroupedMatches = {};
    for (final match in matches) {
      tempGroupedMatches.putIfAbsent(match.leagueId, () => []).add(match);
    }

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

      final countryCompare =
      (aMatch.location ?? '').compareTo(bMatch.location ?? '');
      if (countryCompare != 0) return countryCompare;

      return (aMatch.leagueName ?? '').compareTo(bMatch.leagueName ?? '');
    });

    final Map<String, List<Match>> sortedGroupedMatches = {
      for (final id in sortedLeagueIds) id: tempGroupedMatches[id]!,
    };

    if (!mounted) return;
    setState(() {
      groupedMatches = sortedGroupedMatches;
      isLoading = false;
    });
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

  // --- Lifecycle -----------------------------------------------------------

  @override
  void dispose() {
    _timer.cancel();
    liveMatchesNotifier.dispose();
    super.dispose();
  }

  // --- Build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final entries = selectedLeague == null
        ? groupedMatches.entries
        : groupedMatches.entries.where((e) => e.key == selectedLeague);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list_outlined),
              onSelected: filterMatchesByLeague,
              itemBuilder: (context) {
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
          Container(
            width: 41.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Center(
              child: Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () => widget.onItemTapped(3),
            icon: const Icon(Icons.person_pin),
          ),
        ],
      ),
      drawer: CustomDrawer(onItemTapped: widget.onItemTapped),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
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
                if (index > 0 && index % 6 == 0) {
                  return BannerAdWidget();
                }

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
                  rewardedAdHelper,
                  _openLeagueDetails,
                );
              },
              childCount: entries.length + (entries.length ~/ 6),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMatchesTab(
    BuildContext context,
    List<Match> matches,
    List<String> favoriteMatchIds,
    Function(Match) toggleFavorite,
    RewardedAdHelper rewardedAdHelper,
    void Function(Match) onLeagueTap,
    ) {
  if (matches.isEmpty) return const SizedBox.shrink();

  final first = matches.first;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- Tappable league header ----
        InkWell(
          onTap: () => onLeagueTap(first),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
            child: Row(
              children: [
                if ((first.location ?? '').isNotEmpty) ...[
                  Text(
                    '${first.location} · ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
                Expanded(
                  child: Text(
                    first.leagueName ?? first.leagueShortName ?? 'League',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ],
            ),
          ),
        ),

        // ---- Matches ----
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return LiveItem(
              match: match,
              isFavorite: favoriteMatchIds.contains(match.matchId),
              onFavoriteToggle: toggleFavorite,
              rewardedAdHelper: rewardedAdHelper,
            );
          },
        ),
      ],
    ),
  );
}