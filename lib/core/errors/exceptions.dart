import 'package:dio/dio.dart';
import 'package:iptv/core/errors/error_model.dart';

class ServerError implements Exception {
  final ErrorModel errorModel;

  ServerError({required this.errorModel});
}

class CacheError implements Exception {
  final String errorMsg;

  CacheError({required this.errorMsg});
}

void dioServerExceptions(DioException e) {
  // Default error data if response is null
  final errorData =
      e.response?.data ??
      {
        'statusCode': e.response?.statusCode ?? 0,
        'message': e.message ?? 'An unknown error occurred',
        'error': 'REQUEST_ERROR',
      };

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerError(errorModel: ErrorModel.jsonData(errorData));
    case DioExceptionType.sendTimeout:
      throw ServerError(errorModel: ErrorModel.jsonData(errorData));
    case DioExceptionType.receiveTimeout:
      throw ServerError(errorModel: ErrorModel.jsonData(errorData));
    case DioExceptionType.badCertificate:
      throw ServerError(errorModel: ErrorModel.jsonData(errorData));
    case DioExceptionType.cancel:
      throw ServerError(errorModel: ErrorModel.jsonData(errorData));
    case DioExceptionType.connectionError:
      throw ServerError(errorModel: ErrorModel.jsonData(errorData));
    case DioExceptionType.unknown:
      throw ServerError(errorModel: ErrorModel.jsonData(errorData));
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
          throw ServerError(
            errorModel: ErrorModel.jsonData(e.response?.data ?? errorData),
          );
        case 401:
          throw ServerError(
            errorModel: ErrorModel.jsonData(e.response?.data ?? errorData),
          );
        case 403:
          throw ServerError(
            errorModel: ErrorModel.jsonData(e.response?.data ?? errorData),
          );
        case 409:
          throw ServerError(
            errorModel: ErrorModel.jsonData(e.response?.data ?? errorData),
          );
        case 422:
          throw ServerError(
            errorModel: ErrorModel.jsonData(e.response?.data ?? errorData),
          );
        case 504:
          throw ServerError(
            errorModel: ErrorModel.jsonData(e.response?.data ?? errorData),
          );
        default:
          throw ServerError(errorModel: ErrorModel.jsonData(errorData));
      }
  }
}
