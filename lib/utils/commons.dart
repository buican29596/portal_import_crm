
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime? parseStringToDateTime(String? value) {
  if (value == null) return null;
  return DateTime.tryParse(value)?.toLocal();
}

String? formatDateTime(String? value) {
  if(value?.isNotEmpty == true){
    DateTime dateTime = DateTime.parse(value!);
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    return formattedDate;
  }
  return '-';
}

String? formatDate(String? value) {
  if(value?.isNotEmpty == true){
    DateTime dateTime = DateTime.parse(value!);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }
  return '-';
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitHours = twoDigits(duration.inHours);
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
  if (twoDigitHours == "00") {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
}

void showFlushbarMessage({
  required BuildContext context,
  required String message,
  Color? backgroundColor,
  FlushbarPosition position = FlushbarPosition.TOP,
  Duration duration = const Duration(seconds: 3),
}) {
  final messageText = Text(
    message,
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,
  );

  Flushbar(
    messageText: messageText,
    flushbarPosition: position,
    backgroundColor: position == FlushbarPosition.BOTTOM
        ? const Color(0xFF303030)
        : backgroundColor ??
            Colors.red,
    duration: duration,
    flushbarStyle: FlushbarStyle.GROUNDED,
  ).show(context);
}

String getUsingDateFrom() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd 00:00:00');
  return formatter.format(now);
}

String getUsingDateTo() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd 23:59:59');
  return formatter.format(now);
}

String formatCurrency(int amount) {
  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  return currencyFormatter.format(amount);
}
