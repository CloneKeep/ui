import 'package:flutter/foundation.dart';
import 'contents_model.dart';

class Notes {
  final String nId;
  final String uId;
  final String title;
  final String type;
  final int nPos;
  final String? isColor;
  final bool? isPinned;
  final bool? isArchived;
  final bool? isTrashed;
  final DateTime? createdAt;
  final String? createdId;
  final DateTime? updatedAt;
  final String? updatedId;
  final List<Contents>? contents;

  Notes({
    required this.nId,
    required this.uId,
    required this.title,
    required this.type,
    required this.nPos,
    this.isColor,
    this.isPinned,
    this.isArchived,
    this.isTrashed,
    this.createdAt,
    this.createdId,
    this.updatedAt,
    this.updatedId,
    this.contents,
  });

  // factory Notes.fromJson(Map<String, dynamic> json) {
  //   // json_object_agg로 묶인 contents 맵 파싱
  //   final Map<String, dynamic> rawContents =
  //       json['contents'] as Map<String, dynamic>;

  //   final List<Contents> parsedContents = rawContents.entries.map((entry) {
  //     final Map<String, dynamic> cJson = entry.value as Map<String, dynamic>;
  //     return Contents(
  //       cId: entry.key, // 문맥상 cid가 key로 들어가 있음
  //       content: cJson['content'] as String, // SQL의 'text'
  //       status: cJson['status'] as int, // SQL의 'status'
  //     );
  //   }).toList();

  //   return Notes(
  //     nId: json['nId'] as String,
  //     uId: json['uId'] as String,
  //     nPos: json['n_pos'] ?? 0,
  //     title: json['title_name'] ?? '',
  //     type: json['note_type'] ?? '',
  //     contents: parsedContents,
  //   );
  // }

  factory Notes.fromJson(Map<String, dynamic> json) {
    // Contents Map 파싱 부분 안전 정제
    final Map<String, dynamic> rawContents = json['contents'] is Map
        ? Map<String, dynamic>.from(json['contents'])
        : {};

    final List<Contents> parsedContents = rawContents.entries.map((entry) {
      final Map<String, dynamic> cJson = Map<String, dynamic>.from(entry.value);
      // 위에 수정한 Contents.fromJson 호출
      return Contents.fromJson(entry.key, cJson);
    }).toList();

    return Notes(
      // 🌟 json['nId'] 가 String이 아닐 확률이나 null일 확률을 원천 차단합니다.
      nId: (json['nId'] ?? json['nid'] ?? '').toString(),
      uId: (json['uId'] ?? '').toString(),
      nPos: json['n_pos'] as int? ?? 0,
      title: json['title_name'] as String? ?? '',
      type: json['note_type'] as String? ?? '',
      contents: parsedContents,
    );
  }
}
