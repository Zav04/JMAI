import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String formatTimestampString(String isoTimestamp) {
  DateTime timestamp = DateTime.parse(isoTimestamp);
  final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
  return formatter.format(timestamp);
}

String formatDateString(String isoDate) {
  DateTime date = DateTime.parse(isoDate);
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(date);
}

String dataPorExtenso(String data) {
  initializeDateFormatting('pt_PT', null);

  DateTime dateTime = DateFormat('dd-MM-yyyy').parse(data);
  String dataExtenso =
      DateFormat("d 'de' MMMM 'de' yyyy", 'pt_PT').format(dateTime);

  dataExtenso = dataExtenso.split(' ').map((word) {
    if (word.length > 3) {
      return word[0].toUpperCase() + word.substring(1);
    }
    return word;
  }).join(' ');

  return dataExtenso;
}
