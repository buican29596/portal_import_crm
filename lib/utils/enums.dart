import 'dart:ui';

import 'package:flutter/material.dart';

enum Permission {
  reportLongBeach,
  reportTicket,
  checkTicket,
  searchTicket,
  actionReprint,
  menu,
  configPrint,
}

extension PermissionExtension on Permission {
  String get value {
    switch (this) {
      case Permission.reportLongBeach:
        return 'REPORT_LONGBEACH';
      case Permission.reportTicket:
        return 'REPORT_TICKET';
      case Permission.checkTicket:
        return 'CHECK_TICKET';
      case Permission.searchTicket:
        return 'SEARCH_TICKET';
      case Permission.actionReprint:
        return 'ACTION_REPRINT';
      case Permission.menu:
        return 'MENU';
      case Permission.configPrint:
        return 'CONFIG_PRINT';
    }
  }
}

enum Status {
  inprocess,
  paymentRate30,
  paymentRate60,
  paymentRate80,
  contractCommencement,
  contractTermination,
}

extension StatusExtension on Status {
  static Status fromString(String code) {
    switch (code) {
      case 'inprocess':
        return Status.inprocess;
      case 'paymentrate30':
        return Status.paymentRate30;
      case 'paymentrate60':
        return Status.paymentRate60;
      case 'paymentrate80':
        return Status.paymentRate80;
      case 'ContractCommencement':
        return Status.contractCommencement;
      case 'Contracttermination':
        return Status.contractTermination;
      default:
        throw Exception('Unknown status code: $code');
    }
  }

  String get description {
    switch (this) {
      case Status.inprocess:
        return "Đang thực hiện";
      case Status.paymentRate30:
        return "Tỷ lệ thanh toán 30%";
      case Status.paymentRate60:
        return "Tỷ lệ thanh toán 60%";
      case Status.paymentRate80:
        return "Tỷ lệ thanh toán 80%";
      case Status.contractCommencement:
        return "Khai trương";
      case Status.contractTermination:
        return "Thanh lý hợp đồng";
      default:
        return "";
    }
  }

  Color get color {
    switch (this) {
      case Status.inprocess:
        return Colors.green;
      case Status.paymentRate30:
        return Colors.blue;
      case Status.paymentRate60:
        return Colors.blue;
      case Status.paymentRate80:
        return Colors.blue;
      case Status.contractCommencement:
        return Colors.blue;
      case Status.contractTermination:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

enum ContractStatus {
  pending,
  confirm,
  cancel;

  const ContractStatus();

  String get code {
    switch (this) {
      case ContractStatus.pending:
        return 'PENDING';
      case ContractStatus.confirm:
        return 'Confirm';
      case ContractStatus.cancel:
        return 'Cancel';
    }
  }

  String get description {
    switch (this) {
      case ContractStatus.pending:
        return 'Chờ duyệt';
      case ContractStatus.confirm:
        return 'Đã duyệt';
      case ContractStatus.cancel:
        return 'Từ chối duyệt';
    }
  }

  static ContractStatus fromString(String code) {
    return ContractStatus.values.firstWhere(
          (status) => status.code.toLowerCase() == code.toLowerCase(),
      orElse: () => ContractStatus.pending,
    );
  }

  Color get color {
    switch (this) {
      case ContractStatus.pending:
        return Colors.orangeAccent;
      case ContractStatus.confirm:
        return Colors.green;
      case ContractStatus.cancel:
        return Colors.red;
    }
  }
}

enum VoucherStatus {
  active,
  deactive,
}

extension VoucherStatusExtension on VoucherStatus {
  String get description {
    switch (this) {
      case VoucherStatus.active:
        return 'Kích hoạt';
      case VoucherStatus.deactive:
        return 'Tắt kích hoạt';
    }
  }

  Color get color {
    switch (this) {
      case VoucherStatus.active:
        return Colors.green;
      case VoucherStatus.deactive:
        return Colors.red;
    }
  }

  static VoucherStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return VoucherStatus.active;
      case 'deactive':
        return VoucherStatus.deactive;
      default:
        return VoucherStatus.deactive;
    }
  }
}


