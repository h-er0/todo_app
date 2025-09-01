import 'package:intl/intl.dart';

//Format date time function
String formatDate(DateTime date) {
  return DateFormat('d MMMM y').format(date);
}
