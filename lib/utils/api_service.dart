import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:livescorex/utils/models/league.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/utils/models/match_event.dart';
import 'package:livescorex/utils/models/match_statistics.dart';
import 'package:livescorex/utils/models/player.dart';
import 'package:livescorex/utils/models/standing.dart';
import 'package:livescorex/utils/models/team.dart';

class ApiService {
  static const String _baseUrl = "https://v3.football.api-sports.io";
  static const String _apiKey = "9fcbc3799412e82de6dfe23d2b967f8b";
  final int currentSeason = DateTime.now().year - 1;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': 'v3.football.api-sports.io',
      },
    ),
  );

  Future<List<League>> getLeagues() async {
    try {
      // Load JSON file
      String jsonString = await rootBundle.loadString('assets/leagues.json');

      // Decode JSON
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> leaguesData = jsonData['leagues'];

      // Map JSON data to League objects
      return leaguesData.map((league) {
        return League(
          id: league['id'],
          name: league['name'],
          image: league['logo'] ?? '',
          country:
              league['country'] ?? 'Unknown', // Adjust based on data structure
          countryFlag: league['countryFlag'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception("Error loading leagues from JSON: $e");
    }
  }

  // Fetch Premier League Teams
  Future<List<Team>> getPremierLeagueTeams() async {
    try {
      final response = await _dio.get(
        '/teams',
        queryParameters: {'league': 39, 'season': currentSeason},
      );
      List<dynamic> teamsData = response.data['response'];

      return teamsData.map((team) {
        return Team(
          id: team['team']['id'],
          name: team['team']['name'],
          image: team['team']['logo'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception("Error fetching Premier League teams: $e");
    }
  }

  // Fetch Standings for a given league
  Future<List<Standing>> getStandings(int leagueId) async {
    try {
      final response = await _dio.get(
        '/standings',
        queryParameters: {
          'league': leagueId.toString(),
          'season': currentSeason,
        },
      );
      List<dynamic> standingsData =
          response.data['response'][0]['league']['standings'][0];

      return standingsData.map((standing) {
        return Standing(
          id: standing['team']['id'],
          position: standing['rank'],
          team: standing['team']['name'],
          crest: standing['team']['logo'],
          played: standing['all']['played'],
          won: standing['all']['win'],
          drawn: standing['all']['draw'],
          lost: standing['all']['lose'],
          goalDifference: standing['goalsDiff'],
          points: standing['points'],
        );
      }).toList();
    } catch (e) {
      throw Exception("Error fetching standings: $e");
    }
  }

  Future<List<Match>> getDateFixtures(String date) async {
    try {
      // Fetch Fixtures
      final fixturesResponse = await _dio.get(
        '/fixtures',
        queryParameters: {
          'date': date,
          'timezone': 'Africa/Addis_Ababa', // Fixed space issue
        },
      );
      List<dynamic> matchesData = fixturesResponse.data['response'];

      // Initialize Match list
      List<Match> matches =
          matchesData.map((match) {
            League league = League(
              id: match['league']['id'],
              name: match['league']['name'],
              image: match['league']['logo'],
              country: match['league']['country'],
              countryFlag: match['league']['flag'] ?? '',
            );

            Team home = Team(
              id: match['teams']['home']['id'],
              name: match['teams']['home']['name'],
              image: match['teams']['home']['logo'],
            );
            Team away = Team(
              id: match['teams']['away']['id'],
              name: match['teams']['away']['name'],
              image: match['teams']['away']['logo'],
            );

            return Match(
              league: league,
              id: match['fixture']['id'],
              home: home,
              away: away,
              date: match['fixture']['date'],
              elapsed: match['fixture']['status']['elapsed'],
              short: match['fixture']['status']['short'],
              halftimeScore:
                  (match['score']['halftime']['home'] == null &&
                          match['score']['halftime']['away'] == null)
                      ? null
                      : '${match['score']['halftime']['home'] ?? ''}-${match['score']['halftime']['away'] ?? ''}',
              extra: match['fixture']['status']['extra'],
              homeScore: null, // Placeholder, we will update it with odds below
              awayScore: null, // Placeholder, we will update it with odds below
            );
          }).toList();

      // Fetch Odds
      final oddsResponse = await _dio.get(
        '/odds',
        queryParameters: {'date': date, 'timezone': 'Africa/Addis_Ababa'},
      );
      List<dynamic> oddsData = oddsResponse.data['response'];

      // Process odds and merge into matches
      for (var odd in oddsData) {
        var fixtureId = odd['fixture']['id'];
        var bookmakers = odd['bookmakers'];

        if (bookmakers.isEmpty) continue; // Skip if no bookmakers

        Map<String, dynamic>? matchWinnerBet;

        // Iterate over all bookmakers until we find a valid "Home/Away" bet
        for (var bookmaker in bookmakers) {
          var bets = bookmaker['bets'];

          matchWinnerBet = bets.firstWhere(
            (bet) => bet['name'] == 'Home/Away' || bet['id'] == 2,
            orElse: () => null,
          );

          if (matchWinnerBet != null) break; // Stop searching if found
        }

        if (matchWinnerBet == null) continue; // Skip if no Match Winner odds

        var values = matchWinnerBet['values'];
        String homeOdd =
            values.firstWhere(
              (v) => v['value'] == 'Home',
              orElse: () => {'odd': '-'},
            )['odd'];
        String awayOdd =
            values.firstWhere(
              (v) => v['value'] == 'Away',
              orElse: () => {'odd': '-'},
            )['odd'];

        // Find the corresponding match and update its scores (homeScore and awayScore)
        for (var match in matches) {
          if (match.id == fixtureId) {
            match.homeScore = double.tryParse(
              homeOdd,
            ); // Assign the homeOdd as homeScore
            match.awayScore = double.tryParse(
              awayOdd,
            ); // Assign the awayOdd as awayScore
            break;
          }
        }
      }

      return matches;
    } catch (e) {
      throw Exception("Error fetching matches with odds: $e");
    }
  }

  Future<List<Match>> getLiveMatches() async {
    try {
      final response = await _dio.get(
        '/fixtures',
        queryParameters: {'live': 'all', 'timezone': 'Africa/Addis_Ababa'},
      );
      List<dynamic> matchesData = response.data['response'];

      return matchesData.map((match) {
        League league = League(
          id: match['league']['id'],
          name: match['league']['name'],
          image: match['league']['logo'],
          country: match['league']['country'],
          countryFlag: match['league']['flag'] ?? '',
        );

        Team home = Team(
          id: match['teams']['home']['id'],
          name: match['teams']['home']['name'],
          image: match['teams']['home']['logo'],
        );
        Team away = Team(
          id: match['teams']['away']['id'],
          name: match['teams']['away']['name'],
          image: match['teams']['away']['logo'],
        );

        return Match(
          league: league,
          id: match['fixture']['id'],
          home: home,
          away: away,

          //homeScore: match['goals']['home'], // Can be null
          //awayScore: match['goals']['away'], // Can be null
          homeScore:
              (match['goals']['home'] != null)
                  ? match['goals']['home'].toDouble()
                  : null, // Default to null if no score
          awayScore:
              (match['goals']['away'] != null)
                  ? match['goals']['away'].toDouble()
                  : null, // Default to null if no score
          date: match['fixture']['date'],
          elapsed: match['fixture']['status']['elapsed'], // Can be null
          short: match['fixture']['status']['short'],
          halftimeScore:
              match['score']['halftime']['home'] != null &&
                      match['score']['halftime']['away'] != null
                  ? '${match['score']['halftime']['home']}-${match['score']['halftime']['away']}'
                  : null, // Can be null if no halftime score
          extra: match['fixture']['status']['extra'], // Can be null
        );
      }).toList();
    } catch (e) {
      throw Exception("Error fetching live matches: $e");
    }
  }

  Future<List<Match>> getHeadToHeadMatches(String headToHead) async {
    try {
      final response = await _dio.get(
        '/fixtures/headtohead',
        queryParameters: {'h2h': headToHead, 'last': '6'},
      );

      List<dynamic> matchesData = response.data['response'];

      return matchesData.map((match) {
        League league = League(
          id: match['league']['id'],
          name: match['league']['name'],
          image: match['league']['logo'],
          country: match['league']['country'],
          countryFlag: match['league']['flag'] ?? '',
        );

        Team home = Team(
          id: match['teams']['home']['id'],
          name: match['teams']['home']['name'],
          image: match['teams']['home']['logo'],
        );
        Team away = Team(
          id: match['teams']['away']['id'],
          name: match['teams']['away']['name'],
          image: match['teams']['away']['logo'],
        );

        return Match(
          league: league,
          id: match['fixture']['id'],
          home: home,
          away: away,

          //homeScore: match['goals']['home'], // Can be null
          //awayScore: match['goals']['away'], // Can be null
          homeScore:
              (match['goals']['home'] != null)
                  ? match['goals']['home'].toDouble()
                  : null, // Default to null if no score
          awayScore:
              (match['goals']['away'] != null)
                  ? match['goals']['away'].toDouble()
                  : null, // Default to null if no score
          date: match['fixture']['date'],
          elapsed: match['fixture']['status']['elapsed'], // Can be null
          short: match['fixture']['status']['short'],
          halftimeScore:
              match['score']['halftime']['home'] != null &&
                      match['score']['halftime']['away'] != null
                  ? '${match['score']['halftime']['home']}-${match['score']['halftime']['away']}'
                  : null, // Can be null if no halftime score
          extra: match['fixture']['status']['extra'], // Can be null
        );
      }).toList();
    } catch (e) {
      throw Exception("Error fetching head-to-head matches: $e");
    }
  }

  /*Future<List<Player>> getLineups(int fixtureId) async {
    try {
      final response = await _dio.get(
        '/fixtures/lineups',
        queryParameters: {'fixture': fixtureId},
      );

      List<dynamic> lineupsData = response.data['response'];
      List<Player> players = [];

      // Predefined positions for two teams
      final List<Offset> firstTeamPositions = [
        // Red Team (Top Half)
        Offset(0.5, 0.07),

        Offset(0.1, 0.2),
        Offset(0.4, 0.2),
        Offset(0.6, 0.2),
        Offset(0.9, 0.2),

        Offset(0.2, 0.35),
        Offset(0.4, 0.35),
        Offset(0.6, 0.35),
        Offset(0.8, 0.35),

        Offset(0.4, 0.45),
        Offset(0.6, 0.45),
      ];

      final List<Offset> secondTeamPositions = [
        Offset(0.5, 0.95),
        Offset(0.1, 0.8),
        Offset(0.4, 0.8),
        Offset(0.6, 0.8),
        Offset(0.9, 0.8),
        Offset(0.2, 0.65),
        Offset(0.4, 0.65),
        Offset(0.6, 0.65),
        Offset(0.8, 0.65),
        Offset(0.35, 0.55),

        Offset(0.6, 0.55),
      ];

      int firstTeamIndex = 0, secondTeamIndex = 0;
      Team? firstTeam, secondTeam;

      for (var lineup in lineupsData) {
        var teamData = lineup['team'];

        // Create Team object
        Team team = Team(
          id: teamData['id'],
          name: teamData['name'],
          image: teamData['logo'],
        );

        // Identify the first and second team (without using team names)
        if (firstTeam == null) {
          firstTeam = team;
        } else if (secondTeam == null && team.id != firstTeam.id) {
          secondTeam = team;
        }

        for (var playerEntry in lineup['startXI']) {
          var player = playerEntry['player'];

          // Extract first letter of first name and full last name
          String formattedName = player['name'];
          List<String> nameParts = formattedName.split(" ");
          if (nameParts.length > 1) {
            formattedName = "${nameParts.first[0]}. ${nameParts.last}";
          }

          // Assign predefined position based on team
          Offset gridOffset = Offset.zero;
          if (team.id == firstTeam?.id &&
              firstTeamIndex < firstTeamPositions.length) {
            gridOffset = firstTeamPositions[firstTeamIndex++];
          } else if (team.id == secondTeam?.id &&
              secondTeamIndex < secondTeamPositions.length) {
            gridOffset = secondTeamPositions[secondTeamIndex++];
          }

          players.add(
            Player(
              name: formattedName,
              position: player['pos'],
              shirtNumber: player['number'],
              team: team, // Now correctly passing the Team object
              grid: gridOffset,
            ),
          );
        }
      }

      return players;
    } catch (e) {
      throw Exception("Error fetching lineups: $e");
    }
  }*/

  Future<List<Player>> getLineups(int fixtureId) async {
    try {
      final response = await _dio.get(
        '/fixtures/lineups',
        queryParameters: {'fixture': fixtureId},
      );

      List<dynamic> lineupsData = response.data['response'];
      List<Player> players = [];

      // Predefined positions for two teams
      final List<Offset> firstTeamPositions = [
        // Red Team (Top Half)
        Offset(0.5, 0.07),
        Offset(0.1, 0.2),
        Offset(0.4, 0.2),
        Offset(0.6, 0.2),
        Offset(0.9, 0.2),
        Offset(0.2, 0.35),
        Offset(0.4, 0.35),
        Offset(0.6, 0.35),
        Offset(0.8, 0.35),
        Offset(0.4, 0.45),
        Offset(0.6, 0.45),
      ];

      final List<Offset> secondTeamPositions = [
        Offset(0.5, 0.95),
        Offset(0.1, 0.8),
        Offset(0.4, 0.8),
        Offset(0.6, 0.8),
        Offset(0.9, 0.8),
        Offset(0.2, 0.65),
        Offset(0.4, 0.65),
        Offset(0.6, 0.65),
        Offset(0.8, 0.65),
        Offset(0.35, 0.55),
        Offset(0.6, 0.55),
      ];

      int firstTeamIndex = 0, secondTeamIndex = 0;
      Team? firstTeam, secondTeam;

      for (var lineup in lineupsData) {
        var teamData = lineup['team'];

        // Create Team object
        Team team = Team(
          id: teamData['id'],
          name: teamData['name'],
          image: teamData['logo'],
        );

        // Identify the first and second team (without using team names)
        if (firstTeam == null) {
          firstTeam = team;
        } else if (secondTeam == null && team.id != firstTeam.id) {
          secondTeam = team;
        }

        for (var playerEntry in lineup['startXI']) {
          var player = playerEntry['player'];

          // Extract first letter of first name and full last name
          String formattedName = player['name'];
          List<String> nameParts = formattedName.split(" ");
          if (nameParts.length > 1) {
            formattedName = "${nameParts.first[0]}. ${nameParts.last}";
          }

          // Assign predefined position based on team
          Offset gridOffset = Offset.zero;
          if (team.id == firstTeam.id &&
              firstTeamIndex < firstTeamPositions.length) {
            gridOffset = firstTeamPositions[firstTeamIndex++];
          } else if (team.id == secondTeam?.id &&
              secondTeamIndex < secondTeamPositions.length) {
            gridOffset = secondTeamPositions[secondTeamIndex++];
          }

          players.add(
            Player(
              name: formattedName,
              position: player['pos'],
              shirtNumber: player['number'],
              team: team,
              grid: gridOffset,
            ),
          );
        }

        // Add substitutes (without grid positions)
        for (var subEntry in lineup['substitutes']) {
          var player = subEntry['player'];

          // Extract first letter of first name and full last name
          String formattedName = player['name'];
          List<String> nameParts = formattedName.split(" ");
          if (nameParts.length > 1) {
            formattedName = "${nameParts.first[0]}. ${nameParts.last}";
          }

          players.add(
            Player(
              name: formattedName,
              position: player['pos'],
              shirtNumber: player['number'],
              team: team,
              grid: Offset.zero, // No predefined position for substitutes
            ),
          );
        }
      }

      return players;
    } catch (e) {
      throw Exception("Error fetching lineups: $e");
    }
  }

  Future<List<MatchStatistics>> getMatchStatistics(int fixtureId) async {
    try {
      final response = await _dio.get(
        '/fixtures/statistics',
        queryParameters: {'fixture': fixtureId},
      );

      if (response.data == null ||
          response.data['response'] == null ||
          response.data['response'].isEmpty) {
        throw Exception("No statistics data found for fixture $fixtureId");
      }

      List<dynamic> statisticsData = response.data['response'];

      if (statisticsData.length < 2) {
        throw Exception("Incomplete statistics data for fixture $fixtureId");
      }

      Map<String, dynamic> homeTeamStats = statisticsData[0];
      Map<String, dynamic> awayTeamStats = statisticsData[1];

      List<MatchStatistics> matchStats = [];

      for (int i = 0; i < homeTeamStats['statistics'].length; i++) {
        matchStats.add(
          MatchStatistics(
            type: homeTeamStats['statistics'][i]['type'],
            home: homeTeamStats['statistics'][i]['value'],
            away: awayTeamStats['statistics'][i]['value'],
          ),
        );
      }

      return matchStats;
    } catch (e) {
      throw Exception("Error fetching match statistics: $e");
    }
  }

  // Fetch Match Summary (Events)
  Future<List<MatchEvent>> getMatchSummary(int fixtureId) async {
    try {
      final response = await _dio.get(
        '/fixtures/events',
        queryParameters: {'fixture': fixtureId},
      );
      List<dynamic> eventsData = response.data['response'];

      return eventsData.map((event) {
        return MatchEvent(
          time: event['time']['elapsed'].toString(),
          teamId: event['team']['id'] ?? 0,
          playerName: event['player'] != null ? event['player']['name'] : '',
          eventType: event['type'] ?? 'Unknown',
          eventDetail: event['detail'] ?? '',
          assistPlayer:
              event['assist'] != null ? event['assist']['name'] ?? '' : '',
        );
      }).toList();
    } catch (e) {
      throw Exception("Error fetching match summary: $e");
    }
  }
}
