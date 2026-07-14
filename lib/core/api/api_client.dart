import 'package:dio/dio.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      // TODO: 나중에 백엔드 주소 변경
      baseUrl: const String.fromEnvironment(
        'API_URL',
        defaultValue: 'http://localhost:8080',
      ),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Dio get instance => _dio;
}
