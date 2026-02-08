import 'package:intl/intl.dart';

///  Get difference in days between two dates
int differenceInDays(DateTime startDate, DateTime endDate) {
  return endDate.difference(startDate).inDays;
}

///  Format date to "Oct 12", "Feb 23", etc.
String formatDateShort(DateTime date) {
  final formatter = DateFormat('MMM dd');
  return formatter.format(date);
}
