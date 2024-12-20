// import 'package:flutter/services.dart';
// import 'package:portal_ticket/data/response/ticket_info.dart';
// import 'package:portal_ticket/utils/commons.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// Future<Uint8List> _generatePdf(PdfPageFormat format, TicketInfoModel ticketInfo, {String? foodName}) async {
//   final pdf = pw.Document();
//   final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
//   final ttf = pw.Font.ttf(fontData);
//
//   pdf.addPage(
//     pw.Page(
//       pageFormat: format,
//       build: (pw.Context context) {
//         return pw.Padding(
//           padding: const pw.EdgeInsets.symmetric(vertical: 16),
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             mainAxisAlignment: pw.MainAxisAlignment.center,
//             children: [
//               pw.Text(foodName?.isNotEmpty == true ? foodName!: ticketInfo.serviceNameList?[0]??"",
//                   style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf)),
//               pw.SizedBox(height: 16),
//               pw.Row(
//                 children: [
//                   pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text('Ngày sử dụng/ Valid On:',
//                             style: pw.TextStyle(fontSize: 14, font: ttf)),
//                         pw.SizedBox(height: 6),
//                         pw.Text('Ngày hết hạn/ Expiration time:',
//                             style: pw.TextStyle(fontSize: 14, font: ttf)),
//                         pw.SizedBox(height: 6),
//                         pw.Text('Mã vé/ Ticket code:',
//                             style: pw.TextStyle(fontSize: 14, font: ttf)),
//                         pw.SizedBox(height: 6),
//                         pw.Text('Thời Gian in vé/ Time print:',
//                             style: pw.TextStyle(fontSize: 14, font: ttf)),
//                       ]
//                   ),
//                   pw.SizedBox(width: 12),
//                   pw.Expanded(
//                     flex: 4,
//                     child: pw.Column(
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text('${formatDate(ticketInfo.arrivalDate)}',
//                               style: pw.TextStyle(fontSize: 14, font: ttf)),
//                           pw.SizedBox(height: 6),
//                           pw.Text('${formatDate(ticketInfo.departureDate)}',
//                               style: pw.TextStyle(fontSize: 14, font: ttf)),
//                           pw.SizedBox(height: 6),
//                           pw.Text('${ticketInfo.cardId}',
//                               style: pw.TextStyle(fontSize: 14, font: ttf)),
//                           pw.SizedBox(height: 6),
//                           pw.Text('${formatDateTime(DateTime.now().toString())}',
//                               style: pw.TextStyle(fontSize: 14, font: ttf)),
//                         ]
//                     ),
//                   ),
//                 ],
//               ),
//               pw.Text('   ',
//                   style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf)),
//               pw.Spacer(),
//               pw.SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     ),
//   );
//
//   return pdf.save();
// }
//
// void printTicket(TicketInfoModel ticketInfo, {String? foodName}) async{
//   await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
//     return await _generatePdf(format, ticketInfo, foodName: foodName);
//   });
// }