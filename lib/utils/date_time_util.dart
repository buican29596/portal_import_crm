import 'dart:math';

import 'package:intl/intl.dart';

String? formatDate(DateTime? date, String format) {
  if (date == null) return null;
  final dateFormat = DateFormat(format);
  return dateFormat.format(date);
}

DateTime? parseDate(String? strDate, String format, {bool utc = true}) {
  if (strDate == null) return null;
  try {
    return DateFormat(format).parse(strDate, utc).toLocal();
  } catch (e) {
    return null;
  }
}

const normalDateTime = "dd/MM/yyyy";
const serverDateTime = "yyyy-MM-dd'T'HH:mm:ss'Z'";

extension DateTimeExtension on DateTime {
  DateTime addMonths(int months) {
    var newMonth = month + months;
    var newYear = year + (newMonth - 1) ~/ 12;
    newMonth = (newMonth - 1) % 12 + 1;
    var lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day;
    var newDay = min(day, lastDayOfMonth);
    return DateTime(newYear, newMonth, newDay);
  }
}

