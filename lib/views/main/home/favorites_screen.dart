import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livescore_x/utils/favorite_matches.dart';
import 'package:livescore_x/utils/favorite_teams.dart';
import 'package:livescore_x/utils/models/match.dart';
import 'package:livescore_x/utils/models/team.dart';
import 'package:livescore_x/views/main/bottom_nav.dart';
import 'package:livescore_x/widgets/favorite_match.dart';
import 'package:livescore_x/widgets/favorite_team.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  List<Match> _savedMatches = []; // Store matches in state
  List<Team> _savedTeams = [];

  @override
  void initState() {
    super.initState();
    _loadMatches(); // Load matches on screen startup
  }

  // Fetch matches and update state
  void _loadMatches() async {
    List<Match> matches = await getMatches();
    List<Team> teams = await getTeams();
    setState(() {
      _savedMatches = matches;
      _savedTeams = teams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () async {
              bool exitApp = await showExitConfirmationDialog(context);
              if (exitApp) {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              }
            },
          ),
          title: Text("Favorites"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                tabs: [Tab(text: 'Matches'), Tab(text: 'My Teams')],
                dividerColor: Colors.transparent,
                isScrollable: true,
              ),
            ),
          ),
        ),

        body: TabBarView(
          children: [_buildMatchesTab(context), _buildMyTeamsTab(context)],
        ),
      ),
    );
  }

  // Build matches tab with the latest list
  Widget _buildMatchesTab(BuildContext context) {
    if (_savedMatches.isEmpty) {
      return Center(child: Text('No saved matches yet'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        itemCount: _savedMatches.length,
        itemBuilder: (context, index) {
          Match match = _savedMatches[index];
          return FavoriteMatch(
            match: match,
            onRemove:
                () async => {
                  //Match match
                  await deleteMatch(match.id), // Remove from storage
                  setState(() {
                    _savedMatches.removeWhere(
                      (m) => m.id == match.id,
                    ); // Remove from UI
                  }),
                },
          );
        },
      ),
    );
  }

  Widget _buildMyTeamsTab(BuildContext context) {
    if (_savedTeams.isEmpty) {
      return Center(child: Text('No favorite teams yet'));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                'MY TEAMS',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            // Ensures ListView gets proper height
            child: ListView.builder(
              itemCount: _savedTeams.length,
              itemBuilder: (context, index) {
                Team team = _savedTeams[index];
                return FavoriteTeam(
                  team: team,
                  onRemove:
                      () async => {
                        await deleteTeam(team.id),
                        setState(() {
                          _savedTeams.removeWhere((m) => m.id == team.id);
                        }),
                      },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
