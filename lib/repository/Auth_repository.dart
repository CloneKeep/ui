import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ui/core/api/api_client.dart';
import 'package:ui/core/services/token_service.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login', // FastAPI 로그인 엔드포인트
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        // FastAPI에서 내려주는 토큰 응답 파싱
        final String accessToken = response.data['access_token'];
        final String? refreshToken = response.data['refresh_token']; // 있을 경우

        // 받아온 토큰 저장
        await TokenService.instance.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        debugPrint('✅ 로그인 성공 및 Access Token 저장 완료');
        return true;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('❌ 로그인 실패: ${e.response?.data ?? e.message}');
      return false;
    }
  }
}
