import 'package:intl/intl.dart';

class ImportData {
  final String? bu;
  final String? store;
  final String? orderId;
  final String? fullName;
  final String? lastName;
  final String? salutation;
  final String? firstName;
  final String? middleName;
  final String? mobile;
  final String? taxCode;
  final String? cooperate;
  final String? cooperatePhone;
  final String? cooperateEmail;
  final String? cooperateAddress;
  final String? dob;
  final String? gender;
  final String? email;
  final String? jobTitle;
  final String? voucher;
  final String? voucherType;
  final double? voucherDiscountAmount;
  final double? discountAmount;
  final double? totalDiscountAmount;
  final String? membershipType;
  final String? description;
  final int? qty;
  final double? totalAmount;
  final String? paymentDate;
  final String? paymentMethod;
  final bool isValidPhoneNumber;
  final bool isValidPaymentDate;
  final bool isValidTotalAmount;
  bool insertSuccess;

  ImportData({
    this.bu,
    this.store,
    this.orderId,
    this.fullName,
    this.lastName,
    this.salutation,
    this.firstName,
    this.middleName,
    this.mobile,
    this.taxCode,
    this.cooperate,
    this.cooperatePhone,
    this.cooperateEmail,
    this.cooperateAddress,
    this.dob,
    this.gender,
    this.email,
    this.jobTitle,
    this.voucher,
    this.voucherType,
    this.voucherDiscountAmount,
    this.discountAmount,
    this.totalDiscountAmount,
    this.membershipType,
    this.description,
    this.qty,
    this.totalAmount,
    this.paymentDate,
    this.paymentMethod,
    this.isValidPhoneNumber = true,
    this.isValidPaymentDate = true,
    this.isValidTotalAmount = true,
    this.insertSuccess = false,
  });


  factory ImportData.fromMap(Map<String, dynamic> map) {
    String? parseString(dynamic value) => value?.toString();
    double? parseDouble(dynamic value) => value == null ? null : double.tryParse(value.toString());
    int? parseInt(dynamic value) => value == null ? null : int.tryParse(value.toString());

    String? mobile = parseString(map['Mobile']);
    bool isMobileValid = mobile != null && RegExp(r'^\d{10,}$').hasMatch(mobile);

    String? paymentDate = parseString(map['Paymentdate']);
    bool isPaymentDateValid = false;
    if (paymentDate != null) {
      try {
        DateFormat('dd/MM/yyyy').parseStrict(paymentDate);
        isPaymentDateValid = true;
      } catch (e) {
        isPaymentDateValid = false;
      }
    }

    double? totalAmount = 0;
    if (map['TotalAmount'] == null) totalAmount = 0;
    String stringValue = map['TotalAmount'].toString();
    stringValue = stringValue.replaceAll('.', '').replaceAll(',', '');
    totalAmount =  double.tryParse(stringValue);
    bool isTotalAmountValid = totalAmount != null;
    return ImportData(
      bu: parseString(map['BU']),
      store: parseString(map['Store']),
      orderId: parseString(map['OrderId']),
      fullName: parseString(map['FullName']),
      lastName: parseString(map['LastName']),
      salutation: parseString(map['Salutation']),
      firstName: parseString(map['FirstName']),
      middleName: parseString(map['MiddleName']),
      mobile: parseString(map['Mobile']),
      taxCode: parseString(map['TaxCode']),
      cooperate: parseString(map['Cooperate']),
      cooperatePhone: parseString(map['CooperatePhone']),
      cooperateEmail: parseString(map['CooperateEmail']),
      cooperateAddress: parseString(map['CooperateAddress']),
      dob: parseString(map['DOB']),
      gender: parseString(map['Gender']),
      email: parseString(map['Email']),
      jobTitle: parseString(map['JobTitle']),
      voucher: parseString(map['Voucher']),
      voucherType: parseString(map['VoucherType']),
      voucherDiscountAmount: parseDouble(map['VoucherDiscountAmount']),
      discountAmount: parseDouble(map['DiscountAmount']),
      totalDiscountAmount: parseDouble(map['TotalDiscountAmount']),
      membershipType: parseString(map['MembershipType']),
      description: parseString(map['Description']),
      qty: parseInt(map['Qty']),
      totalAmount: parseDouble(map['TotalAmount']),
      paymentDate: parseString(map['Paymentdate']),
      paymentMethod: parseString(map['PaymentMethod']),
      isValidPhoneNumber: isMobileValid,
      isValidPaymentDate: isPaymentDateValid,
      isValidTotalAmount: isTotalAmountValid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bu': bu?.trim().toUpperCase(),
      'store': store,
      'order_id': orderId,
      'full_name': fullName,
      'last_name': lastName,
      'salutation': salutation,
      'first_name': firstName,
      'middle_name': middleName,
      'mobile': mobile,
      'tax_code': taxCode,
      'cooperate': cooperate,
      'cooperate_phone': cooperatePhone,
      'cooperate_email': cooperateEmail,
      'cooperate_address': cooperateAddress,
      'dob': (dob != null && dob?.isNotEmpty == true) ? dob : null,
      'gender': gender,
      'email': email,
      'job_title': jobTitle,
      'voucher': voucher,
      'voucher_type': voucherType,
      'voucher_discount_amount': voucherDiscountAmount,
      'discount_amount': discountAmount,
      'TotalDiscountAmount': totalDiscountAmount,
      'membership_type': membershipType,
      'description': description,
      'qty': qty,
      'total_amount': totalAmount,
      'payment_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateFormat('dd/MM/yyyy').parse(paymentDate ?? '01/01/1900')),
      'payment_method': paymentMethod,
      "order_json": "{\"product\": $orderId, \"totalAmount\": $totalAmount, \"quantity\": $qty}",
      "order_detail_json": "{\"details\": [{\"item\": $orderId, \"qty\": $qty, \"price\": $totalAmount}]}",
    };
  }
}