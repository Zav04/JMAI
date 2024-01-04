import 'package:intl/intl.dart';

String formatDateString(String isoDate) {
  DateTime date = DateTime.parse(isoDate);
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(date);
}
