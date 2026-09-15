import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:livescorex/utils/models/league.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/utils/models/match_event.dart';
import 'package:livescorex/utils/models/match_statistics.dart';
import 'package:livescorex/utils/models/player.dart';
import 'package:livescorex/utils/models/standing.dart';
import 'package:livescorex/utils/models/team.dart';

class ApiService {
  // Your Railway-deployed Express proxy. CORS is handled there — no key needed here.
  static const String _baseUrl = 'https://isport-api-production.up.railway.app';

  final int currentSeason = DateTime.now().year - 1;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // ---------------------------------------------------------------------------
  // Response handling — the PROXY envelope is {success, source, data, timestamp}
  // ---------------------------------------------------------------------------

  dynamic _handleResponse(Response response) {
    final raw = response.data;
    if (raw == null) {
      throw Exception('Empty response from proxy');
    }

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

    // Proxy envelope uses `success` (bool), not iSportsAPI's `code` (int).
    final success = body['success'];
    if (success != true) {
      throw Exception(
        body['error']?.toString() ?? 'Unknown proxy error',
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

  Never _logAndRethrow(String method, DioException e) {
    debugPrint(
      '$method DioException type=${e.type} '
      'status=${e.response?.statusCode} '
      'message=${e.message}',
    );
    throw Exception('$method failed: ${e.message ?? e.type.name}');
  }

  // ---------------------------------------------------------------------------
  // Leagues — proxy route: /api/isports/leagues
  // ---------------------------------------------------------------------------

  Future<List<League>> getLeagues() async {
    try {
      final response = await _dio.get('/api/isports/leagues');
      final data = _handleResponse(response);
      return (data as List)
          .map((json) => League.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logAndRethrow('getLeagues', e);
    } catch (e, st) {
      debugPrint('getLeagues error: $e\n$st');
      throw Exception('Error fetching leagues: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Matches — proxy route: /api/isports/livescores
  // ---------------------------------------------------------------------------

  Future<List<Match>> getLiveMatches(bool live) async {
    try {
      final response = await _dio.get('/api/isports/livescores');
      final data = _handleResponse(response);
      //print('$data');
      return (data as List)
          .map((json) => Match.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logAndRethrow('getLiveMatches', e);
    } catch (e, st) {
      debugPrint('getLiveMatches error: $e\n$st');
      throw Exception('Error fetching live matches: $e');
    }
  }

  Future<List<Match>> getDateFixtures(String date) async {
    try {
      final response = await _dio.get(
        '/api/isports/schedule',
        queryParameters: {'date': date},
      );
      final data = _handleResponse(response);
      return (data as List)
          .map((json) => Match.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logAndRethrow('getDateFixtures', e);
    } catch (e, st) {
      debugPrint('getDateFixtures error: $e\n$st');
      throw Exception('Error fetching fixtures for $date: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Teams — proxy route: /api/isports/teams
  // ---------------------------------------------------------------------------

  Future<List<Team>> getAllTeams({required String leagueId}) async {
    try {
      final response = await _dio.get(
        '/api/isports/teams',
        queryParameters: {'leagueId': leagueId},
      );
      final data = _handleResponse(response);

      if (data is! List) {
        throw Exception(
          'Unexpected data format: expected a List, '
          'got ${data.runtimeType}',
        );
      }

      return data
          .map((json) => Team.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logAndRethrow('getAllTeams', e);
    } catch (e, st) {
      debugPrint('getAllTeams error: $e\n$st');
      throw Exception('Error fetching teams for league $leagueId: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Standings — proxy route: /api/isports/standings
  //
  // The proxy already reshapes {teamInfos, totalStandings} into a flat list
  // of standing rows with teamName/teamLogo merged in. No lookup needed here.
  // ---------------------------------------------------------------------------

  Future<List<Standing>> getStandings(String leagueId) async {
    try {
      final response = await _dio.get(
        '/api/isports/standings',
        queryParameters: {'leagueId': leagueId},
      );
      final data = _handleResponse(response);

      if (data is! List) {
        throw Exception('Expected List, got ${data.runtimeType}');
      }

      // The proxy flattens each row, so we pass an empty lookup map.
      return data
          .whereType<Map>()
          .map(
            (e) => Standing.fromJson(
              Map<String, dynamic>.from(e),
              const {},
            ),
          )
          .toList();
    } on DioException catch (e) {
      _logAndRethrow('getStandings', e);
    } catch (e, st) {
      debugPrint('getStandings error: $e\n$st');
      throw Exception('Error fetching standings: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Lineups — proxy route: /api/isports/lineups
  //
  // The proxy returns {home, away, homeBackup, awayBackup, homeFormation, awayFormation}
  // instead of iSportsAPI's raw array. Simpler to consume here.
  // ---------------------------------------------------------------------------

  Future<List<Player>> getLineups(String matchId) async {
    try {
      final response = await _dio.get(
        '/api/isports/lineups',
        queryParameters: {'matchId': matchId},
      );
      final data = _handleResponse(response);

      if (data is! Map) {
        throw Exception('Expected Map, got ${data.runtimeType}');
      }

      final players = <Player>[];

      _appendLineupPlayers(
        players,
        data['home'],
        teamId: 'home',
        isSubstitute: false,
      );
      _appendLineupPlayers(
        players,
        data['away'],
        teamId: 'away',
        isSubstitute: false,
      );
      _appendLineupPlayers(
        players,
        data['homeBackup'],
        teamId: 'home',
        isSubstitute: true,
      );
      _appendLineupPlayers(
        players,
        data['awayBackup'],
        teamId: 'away',
        isSubstitute: true,
      );

      return players;
    } on DioException catch (e) {
      _logAndRethrow('getLineups', e);
    } catch (e, st) {
      debugPrint('getLineups error: $e\n$st');
      throw Exception('Error fetching lineups: $e');
    }
  }

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
          recordId: playerId,
          playerId: playerId,
          name: name,
          number: number,
          teamId: teamId,
          position: _positionLabel(position),
          birthday: '',
          height: 0,
          country: '',
          feet: '',
          weight: 0,
          photo: '',
          value: 0,
          introduce: '',
          contractEndDate: '',
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

  // ---------------------------------------------------------------------------
  // Match statistics — proxy route: /api/isports/stats
  //
  // The proxy already pairs home/away stats into rows of {type, home, away},
  // so we don't need the "length < 2" check anymore.
  // ---------------------------------------------------------------------------

  Future<List<MatchStatistics>> getMatchStatistics(String matchId) async {
    try {
      final response = await _dio.get(
        '/api/isports/stats',
        queryParameters: {'matchId': matchId},
      );
      final data = _handleResponse(response);

      if (data is! List) {
        throw Exception('Expected List, got ${data.runtimeType}');
      }

      return data
          .whereType<Map>()
          .map(
            (row) => MatchStatistics(
              type: _asInt(row['type']),
              home: row['home']?.toString(),
              away: row['away']?.toString(),
            ),
          )
          .toList();
    } on DioException catch (e) {
      _logAndRethrow('getMatchStatistics', e);
    } catch (e, st) {
      debugPrint('getMatchStatistics error: $e\n$st');
      throw Exception('Error fetching match statistics: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Match events — proxy route: /api/isports/events
  //
  // The proxy already flattens player/assist into top-level fields.
  // ---------------------------------------------------------------------------

  Future<List<MatchEvent>> getMatchEvents(String matchId) async {
    try {
      final response = await _dio.get(
        '/api/isports/events',
        queryParameters: {'matchId': matchId},
      );
      final data = _handleResponse(response);

      return (data as List).map((event) {
        return MatchEvent(
          eventId: event['eventId']?.toString() ?? '',
          minute: event['minute']?.toString(),
          type: _asInt(event['type']),
          playerId: event['playerId']?.toString(),
          playerName: event['playerName'] as String?,
          assistPlayerId: event['assistPlayerId']?.toString(),
          homeEvent: false,
          isFavorite: false,
        );
      }).toList();
    } on DioException catch (e) {
      _logAndRethrow('getMatchEvents', e);
    } catch (e, st) {
      debugPrint('getMatchEvents error: $e\n$st');
      throw Exception('Error fetching match events: $e');
    }
  }
}
