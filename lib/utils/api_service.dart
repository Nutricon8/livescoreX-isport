import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:livescorex/utils/models/league.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/utils/models/match_event.dart';
import 'package:livescorex/utils/models/match_statistics.dart';
import 'package:livescorex/utils/models/player.dart';
import 'package:livescorex/utils/models/standing.dart';
import 'package:livescorex/utils/models/team.dart';

class ApiService {
  static const String _baseUrl = "https://api.isportsapi.com";
  static const String _apiKey = "ycOrrj2NLYdzuOBr";

  final int currentSeason = DateTime.now().year - 1;

  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: _baseUrl,
        queryParameters: {'api_key': _apiKey},
       // responseType: ResponseType.plain, // 👈 ADD THIS
    ),
  );

  // Generic response handler
  dynamic _handleResponse(Response response) {
    print('RAW API RESPONSE: ${response.data}'); // 👈 Add this line
    final raw = response.data;

    if (raw == null) {
      throw Exception('Empty response from API');
    }

    // Dio sometimes hands us a String (raw JSON) instead of a decoded Map.
    final Map<String, dynamic> body;
    if (raw is String) {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        throw Exception('Unexpected response body: ${decoded.runtimeType}');
      }
      body = Map<String, dynamic>.from(decoded);
    } else if (raw is Map) {
      body = Map<String, dynamic>.from(raw);
    } else {
      throw Exception('Unexpected response type: ${raw.runtimeType}');
    }

    // Tolerate code as int OR String (iSportsAPI returns both).
    final code = _asInt(body['code']);
    if (code != 0) {
      throw Exception(
        body['message']?.toString() ?? 'Unknown API Error (code: $code)',
      );
    }

    return body['data'];
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  // Fetch Leagues - CORRECTED PATH
  Future<List<League>> getLeagues() async {
    try {
      final response = await _dio.get('/sport/football/league/basic');
      final data = _handleResponse(response);
      return (data as List).map((json) => League.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error fetching leagues: $e");
    }
  }

  // Fetch Matches - CORRECTED PATH
  Future<List<Match>> getLiveMatches(bool live) async {
    try {
      final response = await _dio.get('/sport/football/livescores');
      final data = _handleResponse(response);
      return (data as List).map((json) => Match.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error fetching live matches: $e");
    }
  }

  Future<List<Match>> getDateFixtures(String date) async {
    try {
      final response = await _dio.get(
        '/sport/football/schedule',
        queryParameters: {'date': date},
      );
      final data = _handleResponse(response);
      return (data as List).map((json) => Match.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error fetching live matches: $e");
    }
  }

  Future<List<Team>> getAllTeams() async {
    try {
      final response = await _dio.get('/sport/football/team');
      final data = _handleResponse(response);

      // data is already the list of teams
      if (data is! List) {
        throw Exception("Unexpected data format: expected a List, got ${data.runtimeType}");
      }

      return data.map((json) => Team.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception("Error fetching teams: $e");
    }
  }

  Future<List<Standing>> getStandings(String leagueId) async {
    try {
      final response = await _dio.get(
        '/sport/football/standing/league',
        queryParameters: {'leagueId': leagueId},
      );
      final data = _handleResponse(response);

      if (data is! Map) {
        throw Exception('Expected Map, got ${data.runtimeType}');
      }

      // Build teamId -> teamInfo lookup from data['teamInfos'].
      final teamInfos = (data['teamInfos'] as List?) ?? const [];
      final Map<String, Map<String, dynamic>> teamsById = {
        for (final t in teamInfos.whereType<Map>())
          t['teamId'].toString(): Map<String, dynamic>.from(t),
      };

      // Parse data['totalStandings'] using the lookup.
      final standingsRaw = (data['totalStandings'] as List?) ?? const [];
      return standingsRaw
          .whereType<Map>()
          .map((e) => Standing.fromJson(Map<String, dynamic>.from(e), teamsById))
          .toList();
    } catch (e, st) {
      debugPrint('getStandings error: $e\n$st');
      throw Exception('Error fetching standings: $e');
    }
  }
  Future<List<Player>> getLineups(String matchId) async {
    try {
      final response = await _dio.get(
        '/sport/football/lineups',
        queryParameters: {'matchId': matchId},
      );
      final data = _handleResponse(response);

      final List<Player> players = [];

      if (data is List) {
        for (final matchData in data.whereType<Map>()) {
          final homeFormation = matchData['homeFormation']?.toString();
          final awayFormation = matchData['awayFormation']?.toString();

          // We don't know the teamId from the lineup entry itself —
          // iSportsAPI returns homeLineup / awayLineup as separate arrays,
          // so we tag them when constructing the Player.
          _appendLineupPlayers(
            players,
            matchData['homeLineup'],
            teamId: 'home',          // placeholder; LineupTab re-groups by these tags
            formation: homeFormation,
            isSubstitute: false,
          );
          _appendLineupPlayers(
            players,
            matchData['awayLineup'],
            teamId: 'away',
            formation: awayFormation,
            isSubstitute: false,
          );
          _appendLineupPlayers(
            players,
            matchData['homeBackup'],
            teamId: 'home',
            formation: homeFormation,
            isSubstitute: true,
          );
          _appendLineupPlayers(
            players,
            matchData['awayBackup'],
            teamId: 'away',
            formation: awayFormation,
            isSubstitute: true,
          );
        }
      }

      return players;
    } catch (e, st) {
      debugPrint('getLineups error: $e\n$st');
      throw Exception('Error fetching lineups: $e');
    }
  }

  /// Converts raw lineup entries into [Player] objects using the constructor
  /// directly (bypassing [Player.fromJson] because the lineup response only
  /// contains a subset of the fields the model requires).
  void _appendLineupPlayers(
      List<Player> out,
      dynamic lineupRaw, {
        required String teamId,
        String? formation,
        required bool isSubstitute,
      }) {
    if (lineupRaw is! List) return;

    for (final entry in lineupRaw.whereType<Map>()) {
      final playerId = entry['playerId']?.toString() ?? '';
      final name = entry['name']?.toString() ?? '';
      final number = _asInt(entry['number']) ?? 0;
      final position = _asInt(entry['position']) ?? 0;

      out.add(
        Player(
          // --- fields provided by the lineup endpoint ---
          recordId: playerId,       // no separate recordId — reuse playerId
          playerId: playerId,
          name: name,
          number: number,
          teamId: teamId,           // 'home' or 'away' — see LineupTab below
          position: _positionLabel(position),

          // --- required fields we don't have; use safe defaults ---
          birthday: '',
          height: 0,
          country: '',
          feet: '',
          weight: 0,
          photo: '',
          value: 0,
          introduce: '',
          contractEndDate: '',

          // Optional fields
          pac: null,
          sho: null,
          pas: null,
          dri: null,
          def: null,
          phy: null,
          isFavorite: false,
        ),
      );
    }
  }

  String _positionLabel(int p) {
    switch (p) {
      case 0:
        return 'GK';
      case 1:
        return 'DEF';
      case 2:
        return 'MID';
      case 3:
        return 'FWD';
      default:
        return '';
    }
  }

  // Fetch Match Statistics - CORRECTED path
  Future<List<MatchStatistics>> getMatchStatistics(String matchId) async {
    try {
      final response = await _dio.get(
        '/sport/football/events/stats',
        queryParameters: {'matchId': matchId},
      );
      final data = _handleResponse(response);

      if (data is! List || data.length < 2) {
        throw Exception("Incomplete statistics data");
      }

      List<MatchStatistics> stats = [];
      final homeStats = data[0]['statistics'] as List? ?? [];
      final awayStats = data[1]['statistics'] as List? ?? [];

      for (int i = 0; i < homeStats.length; i++) {
        stats.add(
          MatchStatistics(
            type: homeStats[i]['type'] as int?,
            home: homeStats[i]['value']?.toString(),
            away:
                awayStats.length > i ? awayStats[i]['value']?.toString() : null,
          ),
        );
      }
      return stats;
    } catch (e) {
      throw Exception("Error fetching match statistics: $e");
    }
  }

  // Fetch Match Events - CORRECTED path and mapping
  Future<List<MatchEvent>> getMatchEvents(String matchId) async {
    try {
      final response = await _dio.get(
        '/sport/football/events',
        queryParameters: {'matchId': matchId},
      );
      final data = _handleResponse(response);

      return (data as List).map((event) {
        return MatchEvent(
          eventId: event['eventId']?.toString() ?? '',
          minute: event['time']?['elapsed']?.toString(),
          type: event['type'] as int?,
          playerId: event['player']?['id']?.toString(),
          playerName: event['player']?['name'] as String?,
          assistPlayerId: event['assist']?['id']?.toString(),
          homeEvent: false, // Determine from teamId comparison if needed
          isFavorite: false,
        );
      }).toList();
    } catch (e) {
      throw Exception("Error fetching match events: $e");
    }
  }
}
