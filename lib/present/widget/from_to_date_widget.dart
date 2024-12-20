import 'package:flutter/material.dart';
import 'package:portal_hotel/utils/commons.dart';

class DateFilterWidget extends StatefulWidget {
  final Function(DateTime? start, DateTime? end) onDateSelected;

  const DateFilterWidget({super.key, required this.onDateSelected});

  @override
  _DateFilterWidgetState createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends State<DateFilterWidget> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          if (endDate != null && startDate!.isAfter(endDate!)) {
            endDate = startDate;
          }
        } else {
          endDate = picked;
          if (startDate != null && endDate!.isBefore(startDate!)) {
            startDate = endDate;
          }
        }
      });

      // Gọi callback để gửi dữ liệu ra ngoài
      widget.onDateSelected(startDate, endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.calendar_today, color: Colors.blue),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => _selectDate(context, true),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  startDate == null ? 'Từ ngày' : '${formatDate(startDate!.toLocal().toString())}'.split(' ')[0],
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              const SizedBox(width: 10),
              const Icon(Icons.calendar_today, color: Colors.blue),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => _selectDate(context, false),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  endDate == null ? 'Đến ngày' : '${formatDate(endDate!.toLocal().toString())}'.split(' ')[0],
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}