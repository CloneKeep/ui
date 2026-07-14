// 2. lib/main.dart (메인 설정)
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'test_page.dart'; // 분리한 파일 불러오기
import 'keep_main.dart';
import 'test_data.dart'; // 테스트 데이터 페이지 불러오기

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClonKeep',
      theme: ThemeData(useMaterial3: true),
      // home: const TestPage(), // 외부 파일 위젯 호출
      // home: const KeepMainScreen(),
      // home: const TestDataPage(),
      home: const MainPage(),
    );
  }
}
