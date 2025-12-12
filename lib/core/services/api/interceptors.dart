import 'package:dio/dio.dart';
import 'package:iptv/core/services/secure_storage.dart';
import 'package:iptv/core/services/logout_service.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.contentType = Headers.formUrlEncodedContentType;
    super.onRequest(options, handler);
    var token = await getToken();
    if(token != null){
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the error is a 401 Unauthorized response
    if (err.response?.statusCode == 401) {
    
      await LogoutService.forceLogout();
    }
    super.onError(err, handler);
  }
}
