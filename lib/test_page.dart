import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'core/api/api_client.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  // Future<String> getServerData() async {
  //   const url = String.fromEnvironment('API_URL');
  //   print("디버깅 - 현재 설정된 API 주소: $url");

  //   // final response = await ApiClient.instance.get('/test-contents');
  //   final response = await ApiClient.instance.get('/test-contents');
  //   return response.data.toString();
  // }

  Future<String> getServerNoteData() async {
    try {
      // 💡 ApiClient.instance.post 뒤에 Options를 추가하여
      // 이 요청에 한해서만 3초 제한을 30초로 늘리고, 순수 텍스트로 안전하게 받습니다.
      const url = String.fromEnvironment('API_URL');
      print("디버깅 - 현재 설정된 API 주소: $url");

      final response = await ApiClient.instance.post(
        '/notes/me',
        data: {"uid": "d54fc604-c1e5-4f3f-a598-e154a5f20fc3"},
        options: Options(
          responseType: ResponseType.plain, // 브라우저가 파싱하다 터지는 걸 방지
          receiveTimeout: const Duration(seconds: 30), // 3초 제한을 30초로 확장!
        ),
      );

      return response.data.toString();
    } catch (e) {
      print("디버깅 - 에러 내용: $e");
      return "실패: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CloneKeep')),
      body: FutureBuilder<String>(
        // future: getServerData(),
        future: getServerNoteData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) return Center(child: Text(snapshot.data!));
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
