import 'package:flutter/material.dart';
import 'package:ui/data/models/notes_model.dart';
import 'package:ui/repository/noteRepository.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, dynamic>? _userInfo; // 서버에서 받아온 유저 정보 저장용 변수
  bool _isLoading = true; // 로딩 상태를 나타내는 변수
  String? _errorMessage; // 에러 메시지를 저장하는 변수

  // repository 인스턴스 선언
  final NoteRepository _noteRepository = NoteRepository();
  // 무한 재요청 제어(최초 스트림 이벤트 변수에 한번만 바인딩딩
  late Future<List<Notes>> _notesFuture;

  @override
  void initState() {
    super.initState();
    // 화면이 켜질 때 딱 한 번 서버에 데이터를 요청합니다.
    _notesFuture = _noteRepository.fetchNotesAndContents(
      // "d54fc604-c1e5-4f3f-a598-e154a5f20fc3",
      "uid", // 실제로는 로그인 후 토큰에서 추출한 uid를 넣어야 함
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // gackgroundColor 설정
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFF9F9F9),
      //   elevation: 0.5, // shadow 효과를 위해 elevation 설정
      // ),
      // Future 변화를 감지 후 화면 조립 위젯
      body: FutureBuilder<List<Notes>>(
        future: _notesFuture, // initState에서 보관해둔 이벤트 감지
        builder: (context, snapshot) {
          // 데이터 로딩 상태
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          // 서버 에러(500) + 네트워크 오프라인 등 예외 상태
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  '${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          // 통신 성공(200) + 빈값
          final memoList = snapshot.data ?? [];
          if (memoList.isEmpty) {
            return const Center(child: Text('작성된 메모가 없습니다'));
          }
          // 통신 성공(200) + 데이터 존재
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            itemCount: memoList.length,
            itemBuilder: (context, index) {
              final note = memoList[index];
              return _buildMemoCard(note); // json 데이터 카드 형태로 화면에 표시
            },
          );
        },
      ),
    );
  }

  // 메모 카드를 생성하는 함수
  Widget _buildMemoCard(Notes note) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ), // 카드Border R값
      elevation: 2.0, // 그림자 효과
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              note.title, // adjustedJson으로 보정된 'title_name' 값 출력
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4.0),
            // 메모 부가정보
            Text(
              "메모 타입: ${note.type}, 위치: ${note.nPos}",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(height: 24.0, thickness: 0.8),
            // List<Contents> 출력
            Column(
              children: (note.contents ?? []).map((contentItem) {
                // 타입체크
                final bool isCheckList = note.type == 'CHECKLIST';
                // 'CHECKLIST' 상태
                final bool isDone = contentItem.status == 1;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      // 분기 처리 1: 노트 성격에 맞게 '체크박스 아이콘' 혹은 '일반 목록 점 기호' 배치
                      isCheckList
                          ? Icon(
                              isDone
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isDone ? Colors.green : Colors.grey,
                              size: 19.0,
                            )
                          : const Icon(
                              Icons.arrow_right,
                              size: 18.0,
                              color: Colors.amber,
                            ),
                      const SizedBox(width: 8.0),

                      // 분기 처리 2: 체크가 끝난 완료(isDone) 항목은 텍스트에 취소선(lineThrough)과 흐린 색상 적용
                      Expanded(
                        child: Text(
                          contentItem.content, // 본문데이터 binding
                          style: TextStyle(
                            fontSize: 14.0,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDone ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
