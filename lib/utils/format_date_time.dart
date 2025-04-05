import 'package:intl/intl.dart';

String formatMatchDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime matchDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (matchDate == today) {
    return 'Today';
  } else {
    return DateFormat(
      'E, d MMM y',
    ).format(dateTime); // Example: Wed, 19 Jun 2025
  }
}

String formatFullDateTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  return DateFormat('EEEE, d MMMM y \'at\' HH:mm').format(dateTime);
  // Example: Sunday, 3 February 2025 at 21:00
}

String formatTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  return DateFormat('HH:mm').format(dateTime); // Example: 21:00
}
