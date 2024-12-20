import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal_hotel/res/colors.dart';

class DatePickerField extends StatefulWidget {
  final Function(DateTime?) onDateSelected;
  final String? hintText;

  const DatePickerField({
    Key? key,
    required this.onDateSelected,
    this.hintText,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('vi', 'VN'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
        widget.onDateSelected(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.green),
        ),
        suffixIcon: const Icon(Icons.date_range_sharp,color: grey,),
      ),
      onTap: () {
        _selectDate(context);
      },
    );
  }
}