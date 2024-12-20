
class VoucherTypeRequest {
  String? voucherCode;
  String? name;
  String? shortDescription;
  String? fullDescription;
  int? voucherTypeId;
  String? voucherValue;
  int? validityMonths;
  int? buId;
  String? status;

  VoucherTypeRequest({this.voucherCode, this.name, this.shortDescription, this.fullDescription, this.voucherTypeId, this.voucherValue, this.validityMonths, this.buId, this.status});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["voucher_code"] = voucherCode;
    _data["name"] = name;
    _data["short_description"] = shortDescription;
    _data["full_description"] = fullDescription;
    _data["voucher_type_id"] = voucherTypeId;
    _data["voucher_value"] = voucherValue;
    _data["validity_months"] = validityMonths;
    _data["bu_id"] = buId;
    _data["status"] = status;
    return _data;
  }
}