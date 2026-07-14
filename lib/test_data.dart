import 'package:flutter/material.dart';
import 'core/api/api_client.dart';
import 'data/models/users_model.dart';

class TestDataPage extends StatelessWidget {
  const TestDataPage({super.key});

  final String targetUid = 'd54fc604-c1e5-4f3f-a598-e154a5f20fc3'; // 실제 UID로 변경

  Future<Users> getUserData(String uid) async {
    const url = String.fromEnvironment('API_URL');
    print("디버깅 - 현재 설정된 API 주소: $url");

    final response = await ApiClient.instance.get('/users/$uid');
    print("RESPONSE: ${response.data}");

    return Users.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('유저 정보 조회')),
      body: FutureBuilder<Users>(
        // 위에서 정의한 targetUid를 전달하여 호출합니다.
        future: getUserData(targetUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('유저 정보를 찾을 수 없습니다.'));
          }

          final user = snapshot.data!;

          // 단일 유저 정보를 담은 박스를 화면 중앙에 배치합니다.
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: _buildUserBox(user)),
          );
        },
      ),
    );
  }

  Widget _buildUserBox(Users user) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 세로 크기를 내부 콘텐츠만큼만 차지하도록 설정
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text('UID: ${user.uid}', style: TextStyle(color: Colors.grey[700])),
            // Text(
            //   'PW: ${user.pw_hash}',
            //   style: TextStyle(color: Colors.grey[700]),
            // ),
            const Divider(height: 30),
            Text(
              '가입일: ${user.createdAt?.toLocal()}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              '가입자: ${user.createdId}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              '수정일: ${user.updatedAt?.toLocal()}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              '수정자: ${user.updatedId}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
