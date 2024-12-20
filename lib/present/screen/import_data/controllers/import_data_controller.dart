import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portal_hotel/data/response/import_data.dart';
import 'package:portal_hotel/network/services/api_endpoints.dart';
import 'package:portal_hotel/network/services/reponsitory.dart';
import 'dart:io';
import 'dart:html' as html;

import 'package:portal_hotel/utils/commons.dart';
import 'package:http/http.dart' as http;

class ImportDataController with ChangeNotifier {
  List<ImportData>? _importDataList;
  List<ImportData>? get importDataList => _importDataList;
  String? _errorResponse;
  bool _isLoading = false;
  bool _isLoaded = false;
  String? get errorResponse => _errorResponse;
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  String? fileName;
  Uint8List? fileBytes;
  bool dataError = false;
  int totalData = 0;
  int totalImportSuccess = 0;
  int totalImportFail = 0;

  final Repository repository = Repository();

  List<String> definedFields = [
    'BU',
    'Store',
    'OrderId',
    'FullName',
    'LastName',
    'Salutation',
    'FirstName',
    'MiddleName',
    'Mobile',
    'TaxCode',
    'Cooperate',
    'CooperatePhone',
    'CooperateEmail',
    'CooperateAddress',
    'DOB',
    'Gender',
    'Email',
    'JobTitle',
    'Voucher',
    'VoucherType',
    'VoucherDiscountAmount',
    'DiscountAmount',
    'TotalDiscountAmount',
    'MembershipType',
    'Description',
    'Qty',
    'TotalAmount',
    'Paymentdate',
    'PaymentMethod',
  ];

  Future<bool> fetchUploadFile(BuildContext context) async {
    _isLoading = true;
    _isLoaded = false;
    _errorResponse = null;
    totalImportSuccess = 0;
    totalImportFail = 0;
    notifyListeners();
    try {
      _isLoaded = true;
      String token = await  fetchToken();
      for (int i = 0; i < _importDataList!.length; i++) {
        final result = await sendOrder(token, _importDataList![i]);
        if (result == true) {
          totalImportSuccess++;
          _importDataList![i].insertSuccess = true;
        } else {
          totalImportFail++;
          print('Failed to import row at index: $i');
        }
      }
      _importDataList = _importDataList!.where((data) => !data.insertSuccess).toList();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> fetchToken() async {
    String url ='';
    Map<String, String> body ={};
    if(BaseUrl.url.contains('uat')){
      url = 'https://iamlab.citigym.asia';
      body = {
        'grant_type': 'client_credentials',
        'client_id': 'sfgw-nsg-draft-orders-service-qVsoRgUO',
        'client_secret': 'utm5JItuJPA7VflLbZkVPlNsoKBwKEvN',
      };
    }else{
      url = 'https://iam.citigym.asia';
      body = {
        'grant_type': 'client_credentials',
        'client_id': 'sfgw-nsg-draft-orders-service-qVsoRgUO',
        'client_secret': 'trZsNM5gBesDQJBzlZ7j0zaqjkiVCoJ3',
      };
    }
    final urlAPI = Uri.parse(
      '$url/realms/services/protocol/openid-connect/token',
    );

    // Headers
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    try {
      // Gửi yêu cầu POST
      final response = await http.post(
        urlAPI,
        headers: headers,
        body: body,
      );

      // Xử lý kết quả trả về
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Access Token: ${data['access_token']}');
        return data['access_token'];
      } else {
        print('Failed to fetch token: ${response.statusCode}');
        print('Response: ${response.body}');
      }
      return '';
    } catch (e) {
      print('Error fetching token: $e');
      return '';
    }
  }


  Future<bool> sendOrder(String token,ImportData importData) async {
    final url = Uri.parse(
      '${BaseUrl.url}/api/v1/draft-orders/orders',
    );
    Map<String, String> headers ={
      'x-client-id': 'sfgw-nsg-draft-orders-service-qVsoRgUO',
      'x-timezone': 'Asia/Ho_Chi_Minh',
      'Content-Type': 'application/json',
      'Authorization':
      'Bearer $token',
    };
    if (kDebugMode) {
      print(jsonEncode(importData.toJson()));
    }
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(importData.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response: ${response.body}');
        return true;
      } else {
        print('Failed: ${response.statusCode}, ${response.body}');
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<void> loadFile(BuildContext context, Sheet? sheet, String? pickedFileName, Uint8List? pickedFileBytes) async {
    _isLoading = true;
    _isLoaded = false;
    _importDataList = [];
    _errorResponse = null;
    fileName = pickedFileName;
    fileBytes = pickedFileBytes;
    dataError = false;
    totalData = 0;
    totalImportSuccess = 0;
    totalImportFail = 0;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      _importDataList = await compute(_processExcelDataInIsolate, sheet!);
      totalData = importDataList?.length??0;
      _isLoaded = true;
    } catch (e) {
      _errorResponse = 'Không tìm thấy dữ liệu';
    } finally {
      _isLoading = false; // Tắt trạng thái loading
      notifyListeners();
    }
  }

  Future<List<ImportData>> _processExcelDataInIsolate(Sheet sheet) async {
    List<ImportData> allData = [];
    List<ImportData> invalidData = [];
    List<ImportData> validData = [];

    List<String> fileFields = sheet.rows.first.map((cell) => cell?.value.toString() ?? '').toList();
    for (var row in sheet.rows.skip(1)) {
      Map<String, dynamic> rowData = {};
      for (int i = 0; i < fileFields.length; i++) {
        rowData[fileFields[i]] = row[i]?.value;
      }
      ImportData importData = ImportData.fromMap(rowData);
      if(importData.orderId?.isNotEmpty == true){
        if (importData.isValidPhoneNumber && importData.isValidPaymentDate && importData.isValidTotalAmount) {
          validData.add(importData);
        } else {
          dataError = true;
          invalidData.add(importData);
        }
      }
    }

    allData = [...invalidData, ...validData];
    return allData;
  }


  Future<void> exportToExcelWeb(BuildContext context) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    List<String> headers = [
      'BU',
      'Store',
      'OrderId',
      'FullName',
      'LastName',
      'Salutation',
      'FirstName',
      'MiddleName',
      'Mobile',
      'TaxCode',
      'Cooperate',
      'CooperatePhone',
      'CooperateEmail',
      'CooperateAddress',
      'DOB',
      'Gender',
      'Email',
      'JobTitle',
      'Voucher',
      'VoucherType',
      'VoucherDiscountAmount',
      'DiscountAmount',
      'TotalDiscountAmount',
      'MembershipType',
      'Description',
      'Qty',
      'TotalAmount',
      'Paymentdate',
      'PaymentMethod',
    ];

    sheetObject.appendRow(headers.map((header) => FormulaCellValue('"$header"')).toList());

    CellStyle errorStyle = CellStyle(
      backgroundColorHex: ExcelColor.red50,
      fontColorHex: ExcelColor.red,
    );

    for (var entry in _importDataList!) {
      List<dynamic> row = [
        entry.bu,
        entry.store,
        entry.orderId,
        entry.fullName,
        entry.lastName,
        entry.salutation,
        entry.firstName,
        entry.middleName,
        entry.mobile,
        entry.taxCode,
        entry.cooperate,
        entry.cooperatePhone,
        entry.cooperateEmail,
        entry.cooperateAddress,
        entry.dob,
        entry.gender,
        entry.email,
        entry.jobTitle,
        entry.voucher,
        entry.voucherType,
        entry.voucherDiscountAmount,
        entry.discountAmount,
        entry.totalDiscountAmount,
        entry.membershipType,
        entry.description,
        entry.qty,
        entry.totalAmount,
        entry.paymentDate,
        entry.paymentMethod,
      ];

      sheetObject.appendRow(row.map((value) => FormulaCellValue('"${value ?? ""}"')).toList());
      int rowIndex = sheetObject.maxRows - 1;

      if (!entry.isValidPhoneNumber) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex)); // Mobile column
        cell.cellStyle = errorStyle;
      }
      if (!entry.isValidPaymentDate) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 27, rowIndex: rowIndex)); // PaymentDate column
        cell.cellStyle = errorStyle;
      }
      if (!entry.isValidTotalAmount) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 26, rowIndex: rowIndex)); // TotalAmount column
        cell.cellStyle = errorStyle;
      }
    }

    final excelBytes = excel.encode();
    final base64 = base64Encode(excelBytes!);

    String timestamp = DateTime.now().toString().replaceAll('-', '').replaceAll(':', '').replaceAll(' ', '').substring(0, 12);

    final anchor = html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')
      ..setAttribute("download", "${fileName?.replaceAll('.xlsx','')}$timestamp.xlsx")
      ..click();

    showFlushbarMessage(
        context: context,
        message: 'Xuất file excel thành công',
        backgroundColor: Colors.green);
  }

  void clearFile() {
    fileName = null;
    fileBytes = null;
    _importDataList = [];
    notifyListeners();
  }
}