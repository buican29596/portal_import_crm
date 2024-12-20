
import 'dart:typed_data';

import 'package:excel/excel.dart' hide TextSpan;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:portal_hotel/present/screen/import_data/controllers/import_data_controller.dart';
import 'package:portal_hotel/present/screen/import_data/ticket_error_dialog.dart';
import 'package:portal_hotel/present/screen/import_data/ticket_success_dialog.dart';
import 'package:portal_hotel/present/widget/loading_widget.dart';
import 'package:portal_hotel/res/colors.dart';
import 'package:portal_hotel/res/icons.dart';
import 'package:provider/provider.dart';

class ImportDataScreen extends StatefulWidget {
  const ImportDataScreen({super.key});

  @override
  State<ImportDataScreen> createState() => _ImportDataScreenState();
}

class _ImportDataScreenState extends State<ImportDataScreen> {
  int rowsPerPage = 20;
  int currentPage = 0;

  Future<void> _pickExcelFile(ImportDataController controller) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null) {
      String pickedFileName = result.files.single.name;
      Uint8List? pickedFileBytes = result.files.first.bytes;

      if (pickedFileBytes != null) {
        var excel = Excel.decodeBytes(pickedFileBytes);
        Sheet? sheet = excel.tables[excel.tables.keys.first];

        if (sheet != null) {
          List<String> fileFields = [];
          for (var cell in sheet.rows.first) {
            fileFields.add(cell?.value.toString() ?? '');
          }
          List<String> missingFields =
          controller.definedFields.where((field) => !fileFields.contains(field)).toList();

          if (missingFields.isNotEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ImportErrorDialog(
                  title: 'Thiếu Field trong File Excel',
                  mess: 'File Excel đang thiếu các fields sau:\n\n${missingFields.join(", ")}',
                );
              },
            );
            return;
          } else {
            await controller.loadFile(context,sheet,pickedFileName,pickedFileBytes);
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const ImportErrorDialog(
                title: 'Không tìm thấy Sheet',
                mess: 'Không thể đọc sheet đầu tiên trong file Excel.',
              );
            },
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ImportDataController>(
      builder: (context, importDataController, child) {
        int totalItems = importDataController.importDataList?.length??0;
        int totalPages = (totalItems / rowsPerPage).ceil();
        int start = currentPage * rowsPerPage;
        int end =
        (start + rowsPerPage > totalItems) ? totalItems : start + rowsPerPage;
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Gap(20),
                            CustomPaint(
                              painter: DashedBorderPainter(),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(NSGIcons.importFile),
                                    const Gap(16),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Chọn File đính kèm ',
                                            style: TextStyle(fontSize: 14, color: grey),
                                          ),
                                          TextSpan(
                                            text: 'tại đây',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                _pickExcelFile(importDataController);
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(20),
                            if(importDataController.fileName?.isNotEmpty == true)...[
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(NSGIcons.excel),
                                              const Gap(8),
                                              Text(importDataController.fileName??''),
                                            ],
                                          ),
                                          IconButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () {
                                              importDataController.clearFile();
                                            },
                                            icon: const Icon(Icons.clear),
                                            color: Colors.red,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Gap(24),
                                  if(importDataController.dataError == false && importDataController.totalImportFail==0)...[
                                    ElevatedButton(
                                      onPressed: () async{
                                        if(importDataController.importDataList?.isNotEmpty == true){
                                          await importDataController
                                              .fetchUploadFile(context)
                                              .then((value) async {
                                            if (value == true) {
                                              String mess = '';
                                              if(importDataController.totalImportSuccess == importDataController.totalData){
                                                mess = '${importDataController.totalImportSuccess} dòng dữ liệu được Import thành công';
                                              }
                                              if(importDataController.totalImportSuccess != importDataController.totalData){
                                                mess = '${importDataController.totalImportSuccess} dòng dữ liệu được Import thành công\n${importDataController.totalImportFail} dòng dữ liệu được Import thất bại';
                                              }
                                              if(importDataController.totalImportFail == importDataController.totalData){
                                                mess = '${importDataController.totalImportFail} dòng dữ liệu được Import thất bại';
                                              }
                                              if(importDataController.totalImportFail == importDataController.totalData){
                                                WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return ImportErrorDialog(mess: mess,);
                                                    },
                                                  );
                                                });
                                              }else{
                                                WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return ImportSuccessDialog(mess:mess);
                                                    },
                                                  );
                                                });
                                              }
                                            }else{
                                              WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return const ImportErrorDialog(title: 'Import thất bại',mess: 'Vui lòng Export file. Kiểm tra dữ liệu và Import lại.',);
                                                  },
                                                );
                                              });
                                            }
                                          });
                                        }else{
                                          WidgetsBinding.instance.addPostFrameCallback((_) async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const ImportErrorDialog(title: 'Import thất bại',mess: 'Không có dữ liệu để import. Vui lòng chọn file khác!',);
                                              },
                                            );
                                          });
                                        }

                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.upload_sharp,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            'Import',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                                ],
                              )
                            ]
                          ],
                        ),
                      ),
                      const Gap(24),
                      if(importDataController.importDataList?.isNotEmpty == true)...[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(NSGIcons.decorArrow,
                                          width: 12, height: 12),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Text(
                                        'Danh sách dữ liệu import',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () async{
                                      await importDataController.exportToExcelWeb(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.import_export_sharp,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          'Export File',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DataTable(
                                      headingRowColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          return Colors.grey.withOpacity(0.2);
                                        },
                                      ),
                                      dividerThickness: 0,
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Text(
                                            'BU',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Store',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'OrderId',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                        end - start,
                                            (index) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(importDataController.importDataList?[start + index].bu??'')),
                                            DataCell(
                                              Text(
                                                (importDataController.importDataList?[start + index].store ?? '').length > 30
                                                    ? '${importDataController.importDataList?[start + index].store?.substring(0, 30)}...'
                                                    : importDataController.importDataList?[start + index].store ?? '',
                                              ),
                                            ),
                                            DataCell(Text(importDataController.importDataList?[start + index].orderId??'')),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 1),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          headingRowColor:
                                          MaterialStateProperty.resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                              return Colors.grey.withOpacity(0.2);
                                            },
                                          ),
                                          dividerThickness: 0,
                                          columns: const <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'FullName',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'LastName',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Salutation',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'FirstName',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'MiddleName',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Mobile',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'TaxCode',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Cooperate',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'CooperatePhone',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'CooperateEmail',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'CooperateAddress',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'DOB',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Gender',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Email',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'JobTitle',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Voucher',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'VoucherType',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'VoucherDiscountAmount',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'DiscountAmount',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'TotalDiscountAmount',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'MembershipType',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Description',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Qty',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'TotalAmount',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Paymentdate',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'PaymentMethod',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                          rows: List<DataRow>.generate(
                                            end - start,
                                                (index) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(importDataController.importDataList?[start + index].fullName??'')),
                                                DataCell(Text(importDataController.importDataList?[start + index].lastName??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].salutation??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].firstName??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].middleName??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].mobile??'-',style: TextStyle(color:importDataController.importDataList?[start + index].isValidPhoneNumber ==false ?Colors.red:null))),
                                                DataCell(Text(importDataController.importDataList?[start + index].taxCode??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].cooperate??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].cooperatePhone??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].cooperateEmail??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].cooperateAddress??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].dob??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].gender??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].email??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].jobTitle??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].voucher??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].voucherType??'-')),
                                                DataCell(Text('${importDataController.importDataList?[start + index].voucherDiscountAmount??'-'}')),
                                                DataCell(Text('${importDataController.importDataList?[start + index].discountAmount??'-'}')),
                                                DataCell(Text('${importDataController.importDataList?[start + index].totalDiscountAmount??'-'}')),
                                                DataCell(Text(importDataController.importDataList?[start + index].membershipType??'-')),
                                                DataCell(Text(importDataController.importDataList?[start + index].description??'-')),
                                                DataCell(Text('${importDataController.importDataList?[start + index].qty??'1'}')),
                                                DataCell(Text('${importDataController.importDataList?[start + index].totalAmount??'0'}',style: TextStyle(color:importDataController.importDataList?[start + index].isValidTotalAmount ==false ?Colors.red:null),)),
                                                DataCell(Text(importDataController.importDataList?[start + index].paymentDate??'-',style: TextStyle(color:importDataController.importDataList?[start + index].isValidPaymentDate ==false ?Colors.red:null),)),
                                                DataCell(Text(importDataController.importDataList?[start + index].paymentMethod??'-')),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text('Rows per page:'),
                                  const SizedBox(width: 10),
                                  DropdownButton<int>(
                                    value: rowsPerPage,
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        rowsPerPage = newValue!;
                                        currentPage = 0; // Reset lại trang về trang đầu tiên
                                      });
                                    },
                                    items: <int>[20, 50, 100, 200]
                                        .map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text('$value'),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(width: 20),
                                  IconButton(
                                    icon: const Icon(Icons.chevron_left),
                                    onPressed: currentPage > 0
                                        ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                        : null, // Không cho bấm khi đang ở trang đầu tiên
                                  ),
                                  Text('${start + 1} - $end of $totalItems'),
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right),
                                    onPressed: currentPage < totalPages - 1
                                        ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                        : null, // Không cho bấm khi đang ở trang cuối cùng
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),

            if (importDataController.isLoading) ...[
              const Center(
                child: NLLoadingWidget(), // Widget loading của bạn
              )
            ]
          ],
        );
      },
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double dashWidth = 4.0, dashSpace = 4.0;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
