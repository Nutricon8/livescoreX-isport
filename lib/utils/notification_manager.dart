import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:scorecast/utils/favorite_leagues.dart';
import 'package:scorecast/utils/favorite_matches.dart';
import 'package:scorecast/utils/favorite_teams.dart';
import 'package:scorecast/utils/models/league.dart';
import 'package:scorecast/utils/models/match.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'converters/match_converter.dart';
import 'models/team.dart';

Future<void> checkMatchUpdates(List<Match> liveMatches) async {
  List<Team> favoriteTeams = await getTeams(); // Get favorite teams
  List<Match> favoriteMatches = await getMatches(); // Get favorite matches
  List<League> favoriteLeagues = await getLeagues();

  if (favoriteTeams.isEmpty && favoriteMatches.isEmpty) return;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? previousJson = prefs.getString('previous_matches');
  List<Match> previousMatches =
      previousJson != null ? MatchConverter.decode(previousJson) : [];

  for (var match in liveMatches) {
    bool isFavorite =
        favoriteTeams.any(
          (team) => team.id == match.home.id || team.id == match.away.id,
        ) ||
        favoriteMatches.any((favMatch) => favMatch.id == match.id) ||
        favoriteLeagues.any((favLeague) => favLeague.id == match.league.id);

    var previousMatch = previousMatches.firstWhere(
      (m) => m.id == match.id,
      orElse: () => match,
    );

    if (isFavorite) {
      if (match.homeScore != null &&
              previousMatch.homeScore != null &&
              match.homeScore! > previousMatch.homeScore! ||
          match.awayScore != null &&
              previousMatch.awayScore != null &&
              match.awayScore! > previousMatch.awayScore!) {
        _sendGoalNotification(
          "Goooal ⚽! ${match.home.name} 🆚 ${match.away.name}",
          "New score: ${match.home.name} ${match.homeScore?.toInt()} - ${match.awayScore?.toInt()} ${match.away.name}",
          match,
        );
      }

      if (match.short == "HT" && previousMatch.short != "HT") {
        _sendGoalNotification(
          "Half Time!",
          "${match.home.name} 🆚 ${match.away.name}",
          match,
        );
      }

      if (match.short == "2H" &&
          (previousMatch.short == "HT" || previousMatch.short != "2H")) {
        _sendGoalNotification(
          "Second Half Started!",
          "${match.home.name} 🆚 ${match.away.name}",
          match,
        );
      }

      if ((match.short == "FT" || match.short == "AET") &&
          (previousMatch.short != "FT" || previousMatch.short != "AET")) {
        String message =
            match.short == "AET"
                ? "Match Finished After Extra Time!"
                : "Match Finished!";
        _sendGoalNotification(
          message,
          "${match.home.name} 🆚 ${match.away.name}",
          match,
        );
      }

      if (match.short == "LIVE" && match.elapsed! <= 1) {
        _sendGoalNotification(
          "Match started ${match.elapsed!.abs()} minutes ago",
          "${match.home.name} 🆚 ${match.away.name}",
          match,
        );
      }
    }
  }
  await prefs.setString('previous_matches', MatchConverter.encode(liveMatches));

  List<Match> updatedMatches = [];

  for (var match in favoriteMatches) {
    if (["FT", "CANC", "WO", "PEN", "AWD", "AET"].contains(match.short) ||
        compareUtcToLocal(match.date)) {
      await deleteMatch(match.id);
    } else {
      updatedMatches.add(match);
    }
    await saveMatches(updatedMatches);
  }
}

bool compareUtcToLocal(String utcDateString) {
  // Parse the UTC date string and convert it to local time
  DateTime utcTime = DateTime.parse(utcDateString);
  DateTime localTime = utcTime.toLocal();

  // Get current local time
  DateTime now = DateTime.now();

  // Calculate the difference in duration
  Duration difference = now.difference(localTime);

  bool hasPassed = false;

  // Determine if it's hours or days
  if (difference.inDays > 0) {
    hasPassed = true;
  } else if (difference.inHours > 1) {
    hasPassed = true;
  } else {
    hasPassed = false;
  }
  return hasPassed;
}

Future<void> _sendGoalNotification(
  String title,
  String body,
  Match match,
) async {
  Map<String, dynamic> matchMap = {
    'league': {
      'id': match.league.id,
      'name': match.league.name,
      'image': match.league.image,
      'country': match.league.country,
      'countryFlag': match.league.countryFlag,
    },
    'home': {
      'id': match.home.id,
      'name': match.home.name,
      'image': match.home.image,
    },
    'away': {
      'id': match.away.id,
      'name': match.away.name,
      'image': match.away.image,
    },
    'id': match.id,
    'homeScore': match.homeScore,
    'awayScore': match.awayScore,
    'date': match.date,
    'elapsed': match.elapsed,
    'short': match.short,
    'halftimeScore': match.halftimeScore,
    'extra': match.extra,
  };

  String matchJson = jsonEncode(matchMap);

  _playAlarm();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'notifications_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
      largeIcon:
          match.league.image.startsWith("http") ? match.league.image : null,
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
  final ringtonePlayer = FlutterRingtonePlayer(); // Create an instance
  await ringtonePlayer.play(
    fromAsset: "assets/goal_alert.aac", // Custom sound from assets
    //android: AndroidSounds.alarm, // Default system alarm sound on Android
    ios: IosSounds.alarm, // Default system alarm sound on iOS
    looping: false, // Play once
    volume: 1.0, // Full volume
    asAlarm: true, // Uses system alarm volume
  );
}
