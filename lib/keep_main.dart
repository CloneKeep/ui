// lib/keep_main.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'core/api/api_client.dart';

// 1. 메모 데이터 구조 정의 (데이터 모델)
class Note {
  final String title;
  final String content;
  final Color color;

  Note({required this.title, required this.content, required this.color});
}

// 2. 구글 킵 메인 화면 위젯
class KeepMainScreen extends StatefulWidget {
  const KeepMainScreen({super.key});

  @override
  State<KeepMainScreen> createState() => _KeepMainScreenState();
}

// API 통신
Future<String> getServerData() async {
  const url = String.fromEnvironment('API_URL');
  print("디버깅 - 현재 설정된 API 주소: $url");

  final response = await ApiClient.instance.get('/test-contents');
  return response.data.toString();
}

class _KeepMainScreenState extends State<KeepMainScreen> {
  // 화면에 보여줄 가상의 예시 데이터 (글자 길이를 제각각으로 구성)
  final List<Note> dummyNotes = [
    Note(
      title: '장보기 목록',
      content: '- 사과\n- 우유\n- 계란\n- 파스타 면\n- 올리브유',
      color: Colors.amber.shade100,
    ),
    // Note(
    //   title: '아이디어',
    //   content: '플러터 웹으로 구글 킵 클론 코딩하기! 레이아웃을 컴포넌트별로 쪼개서 만들면 유지보수가 쉽다.',
    //   color: Colors.blue.shade100,
    // ),
    // Note(
    //   title: '오늘 할 일',
    //   content: '플러터 패키지 에러 해결하기 🛠️',
    //   color: Colors.green.shade100,
    // ),
    // Note(
    //   title: '일기',
    //   content: '오늘 날씨가 너무 좋았다. 내일은 탁 트인 카페에 가서 웹 브라우저를 띄워놓고 반응형 UI를 테스트해봐야겠다.',
    //   color: Colors.pink.shade100,
    // ),
    // Note(
    //   title: '',
    //   content: '제목이 없는 메모도 구글 킵에서는 자연스럽게 본문만 노출됩니다.',
    //   color: Colors.purple.shade100,
    // ),
  ];

  // 네비게이션 바에서 API 통신 테스트용 버튼 클릭 시 호출되는 함수(태그별 메모 조회 API 연동 예시)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 왼쪽 상단 메뉴 버튼 클릭 시 열리는 서랍 메뉴
      drawer: const Drawer(child: Center(child: Text('사이드 메뉴 구성 예정'))),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ① 상단 구글 킵 스타일 검색바
            _buildTopSearchBar(),

            // 검색바와 메모 리스트 사이의 여백
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ② 메인 콘텐츠: 불규칙 격자 메모 리스트
            _buildNoteGrid(),
          ],
        ),
      ),
      // ③ 하단 메모 작성 고정 바
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  // ① 상단 검색바 위젯 구현
  Widget _buildTopSearchBar() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              // Scaffold 외부의 context를 통해 Drawer를 열기 위해 Builder 사용
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '메모 검색',
                    border: InputBorder.none,
                  ),
                ),
              ),
              // 뷰 모드 전환 아이콘 (격자/리스트 변환용 아이콘 모양)
              IconButton(
                icon: const Icon(Icons.view_agenda_outlined),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              // 우측 상단 유저 프로필 아바타
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.orange,
                child: Text(
                  'A',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ② 불규칙 격자 (Staggered Grid) 위젯 구현
  Widget _buildNoteGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2, // 웹 브라우저 화면에서 가로로 2열씩 정렬
        mainAxisSpacing: 10, // 위아래 카드 간격
        crossAxisSpacing: 10, // 좌우 카드 간격
        itemBuilder: (context, index) {
          final note = dummyNotes[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: note.color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목이 있을 때만 화면에 렌더링
                if (note.title.isNotEmpty) ...[
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                // 메모 본문 내용
                Text(
                  note.content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4, // 줄간격 조절로 가독성 확보
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
        childCount: dummyNotes.length,
      ),
    );
  }

  // ③ 하단 앱바 위젯 구현
  Widget _buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.grey.shade50,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.check_box_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.brush_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.mic_none_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: () {},
            ),
            const Spacer(),
            // 우측 하단 새 메모 추가 원형 버튼 효과
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.amber.shade200,
              elevation: 4,
              onPressed: () {},
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
