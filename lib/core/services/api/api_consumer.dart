abstract class ApiConsumer {
  Future<dynamic> get(String baseUrl,
      {dynamic body,
      Map<String, dynamic>? queryPrameters,
      bool isForm = false});
  Future<dynamic> post(String baseUrl,
      {dynamic body,
      Map<String, dynamic>? queryPrameters,
      bool isForm = false});
  Future<dynamic> patch(String baseUrl,
      {dynamic body,
      Map<String, dynamic>? queryPrameters,
      bool isForm = false});
  Future<dynamic> delete(String baseUrl,
      {dynamic body,
      Map<String, dynamic>? queryPrameters,
      bool isForm = false});
      Future<dynamic> put(String baseUrl,
      {dynamic body,
      Map<String, dynamic>? queryPrameters,
      bool isForm = false});
}
