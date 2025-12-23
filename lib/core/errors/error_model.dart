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
    String errorMessage = 'An unknown error occurred';

    // Handle different message formats safely
    if (jsonData != null) {
      if (jsonData['message'] is List) {
        errorMessage = (jsonData['message'] as List).join(', ');
      } else if (jsonData['message'] is String) {
        errorMessage = jsonData['message'] as String;
      }
    }

    return ErrorModel(
      statusCode: jsonData?['statusCode'] ?? 0,
      code: jsonData?['error'] ?? 'UNKNOWN_CODE',
      errorMsg: errorMessage,
    );
  }
}
