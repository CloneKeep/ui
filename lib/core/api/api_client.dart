import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ui/core/services/token_service.dart';

class ApiClient {
  static final Dio instance = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8080', // 백엔드 서버 주소
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    // Dio 인터셉터로 모든 API 요청 전에 Header 조작
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 저장된 Access Token 꺼내기
          final String? accessToken = await TokenService.instance
              .getAccessToken();

          if (accessToken != null && accessToken.isNotEmpty) {
            // 🌟 FastAPI의 HTTPBearer() 규격인 'Bearer <token>'으로 헤더 추가
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          // FastAPI TokenValidator에서 401 (토큰 만료/유효하지 않음)을 보냈을 때 처리
          if (error.response?.statusCode == 401) {
            debugPrint('⚠️ [401 Unauthorized] 토큰이 만료되었거나 유효하지 않습니다.');
            await TokenService.instance.clearTokens();
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
