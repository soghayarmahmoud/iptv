// ErrorModel class to represent server errors.
class ErrorModel {
  final dynamic statusCode;
  final String errorMsg;
  final String code;

  ErrorModel({
    required this.statusCode,
    required this.errorMsg,
    required this.code,
  });

  factory ErrorModel.jsonData(dynamic jsonData) {
    return ErrorModel(
      statusCode: jsonData['statusCode'] ?? 0,
      code: jsonData['error'] ?? 'UNKNOWN_CODE',
      errorMsg: jsonData['message'] is List ? jsonData['message'].join(', ') : jsonData['message'] ?? 'An unknown error occurred',
    );
  }
}
