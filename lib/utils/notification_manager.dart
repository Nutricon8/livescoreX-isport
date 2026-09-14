import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:livescorex/utils/favorite_leagues.dart';
import 'package:livescorex/utils/favorite_matches.dart';
import 'package:livescorex/utils/favorite_teams.dart';
import 'package:livescorex/utils/models/league.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/team.dart';

/// iSports API status codes (adjust to your actual mapping).
/// Common mapping: 0=NotStarted, 1=FirstHalf, 2=HalfTime,
/// 3=SecondHalf, 4=Finished, etc. Verify against your API docs.
const int statusFirstHalf = 1;
const int statusHalfTime = 2;
const int statusSecondHalf = 3;
const int statusFullTime = 4;

Future<void> checkMatchUpdates(List<Match> liveMatches) async {
  List<Team> favoriteTeams = await getTeams();
  List<Match> favoriteMatches = await getMatches();
  List<League> favoriteLeagues = await getLeagues();

  if (favoriteTeams.isEmpty &&
      favoriteMatches.isEmpty &&
      favoriteLeagues.isEmpty) {
    return;
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? previousJson = prefs.getString('previous_matches');
  List<Match> previousMatches =
      previousJson != null
          ? (jsonDecode(previousJson) as List)
              .map((j) => Match.fromJson(j as Map<String, dynamic>))
              .toList()
          : [];

  for (var match in liveMatches) {
    bool isFavorite =
        favoriteTeams.any(
          (team) => team.teamId == match.homeId || team.teamId == match.awayId,
        ) ||
        favoriteMatches.any((fav) => fav.matchId == match.matchId) ||
        favoriteLeagues.any((fav) => fav.leagueId == match.leagueId);

    if (!isFavorite) continue;

    Match? previousMatch;
    try {
      previousMatch = previousMatches.firstWhere(
        (m) => m.matchId == match.matchId,
      );
    } catch (_) {
      previousMatch = null;
    }

    final prevHome = previousMatch?.homeScore;
    final prevAway = previousMatch?.awayScore;

    // Goal detection
    if (match.homeScore != null &&
        prevHome != null &&
        match.homeScore! > prevHome) {
      await _sendGoalNotification(
        "Goooal ⚽! ${match.homeName} 🆚 ${match.awayName}",
        "New score: ${match.homeName} ${match.homeScore} - ${match.awayScore} ${match.awayName}",
        match,
      );
    }
    if (match.awayScore != null &&
        prevAway != null &&
        match.awayScore! > prevAway) {
      await _sendGoalNotification(
        "Goooal ⚽! ${match.homeName} 🆚 ${match.awayName}",
        "New score: ${match.homeName} ${match.homeScore} - ${match.awayScore} ${match.awayName}",
        match,
      );
    }

    // Half time
    if (match.status == statusHalfTime &&
        previousMatch?.status != statusHalfTime) {
      await _sendGoalNotification(
        "Half Time!",
        "${match.homeName} ${match.homeScore}  🆚 ${match.awayScore} ${match.awayName}",
        match,
      );
    }

    // Second half started
    if (match.status == statusSecondHalf &&
        previousMatch?.status != statusSecondHalf) {
      await _sendGoalNotification(
        "Second Half Started!",
        "${match.homeName} 🆚 ${match.awayName}",
        match,
      );
    }

    // Full time
    if (match.status == statusFullTime &&
        previousMatch?.status != statusFullTime) {
      await _sendGoalNotification(
        "Match Finished!",
        "${match.homeName} ${match.homeScore}  🆚 ${match.awayScore} ${match.awayName}",
        match,
      );
    }
  }

  await prefs.setString(
    'previous_matches',
    jsonEncode(liveMatches.map((m) => m.toJson()).toList()),
  );

  // Remove stale favorite matches
  List<Match> updatedMatches = [];
  for (var match in favoriteMatches) {
    bool isFinished = match.status == statusFullTime;
    bool hasPassed =
        match.matchTime != null &&
        compareUtcToLocal(
          DateTime.fromMillisecondsSinceEpoch(
            match.matchTime! * 1000,
            isUtc: true,
          ).toIso8601String(),
        );

    if (isFinished || hasPassed) {
      await deleteMatch(match.matchId);
    } else {
      updatedMatches.add(match);
    }
  }
  await saveMatches(updatedMatches);
}

bool compareUtcToLocal(String utcDateString) {
  DateTime utcTime = DateTime.parse(utcDateString);
  DateTime localTime = utcTime.toLocal();
  DateTime now = DateTime.now();
  Duration difference = now.difference(localTime);

  if (difference.inDays > 0) return true;
  if (difference.inHours > 1) return true;
  return false;
}

Future<void> _sendGoalNotification(
  String title,
  String body,
  Match match,
) async {
  Map<String, dynamic> matchMap = match.toJson();

  String matchJson = jsonEncode(matchMap);

  await _playAlarm();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'notifications_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
      largeIcon:
          (match.leagueColor != null && match.leagueColor!.startsWith("http"))
              ? match.leagueColor
              : null,
      payload: {'match': matchJson},
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'open_app',
        label: 'Open App',
        autoDismissible: true,
      ),
      NotificationActionButton(
        key: 'view_match',
        label: 'View Match',
        autoDismissible: true,
      ),
    ],
  );
}

Future<void> _playAlarm() async {
  final ringtonePlayer = FlutterRingtonePlayer();
  await ringtonePlayer.play(
    fromAsset: "assets/goal_alert.aac",
    ios: IosSounds.alarm,
    looping: false,
    volume: 1.0,
    asAlarm: true,
  );
}
