
class VoucherRequest {
  int? contractId;
  int? schemaVoucherId;
  String? voucherCode;
  String? startDate;
  String? endDate;
  String? notes;

  VoucherRequest({this.contractId, this.schemaVoucherId, this.voucherCode, this.startDate, this.endDate, this.notes});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["contract_id"] = contractId;
    _data["schema_voucher_id"] = schemaVoucherId;
    _data["voucher_code"] = voucherCode;
    _data["start_date"] = startDate;
    _data["end_date"] = endDate;
    _data["notes"] = notes;
    return _data;
  }
}