import 'package:intl/intl.dart';

String formatTimestampString(String isoTimestamp) {
  DateTime timestamp = DateTime.parse(isoTimestamp);
  final DateFormat formatter = DateFormat('dd-MM-yy HH:mm');
  return formatter.format(timestamp);
}

String formatDateString(String isoDate) {
  DateTime date = DateTime.parse(isoDate);
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(date);
}
