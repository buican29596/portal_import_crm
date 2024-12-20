class ErrorResponse {
  final bool success;
  final String message;
  final String issuedate;
  final String localissue;
  final String errorCode;

  ErrorResponse({
    required this.success,
    required this.message,
    required this.issuedate,
    required this.localissue,
    required this.errorCode,
  });

  // Tạo một hàm từ JSON sang đối tượng Dart
  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      issuedate: json['issuedate'] ?? '',
      localissue: json['localissue'] ?? '',
      errorCode: json['errorCode'] ?? '',
    );
  }

  // Nếu cần, bạn có thể tạo hàm chuyển đổi ngược lại từ Dart sang JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'issuedate': issuedate,
      'localissue': localissue,
      'errorCode': errorCode,
    };
  }
}