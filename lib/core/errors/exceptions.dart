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
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
    case DioExceptionType.sendTimeout:
      throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
    case DioExceptionType.receiveTimeout:
      throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
    case DioExceptionType.badCertificate:
      throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
    case DioExceptionType.cancel:
      throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
    case DioExceptionType.connectionError:
      throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
    case DioExceptionType.unknown:
      throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
          throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
        case 401:
          throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
        case 403:
          throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
        case 409:
          throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
        case 422:
          throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
        case 504:
          throw ServerError(errorModel: ErrorModel.jsonData(e.response!.data));
      }
  }
}
