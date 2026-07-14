import 'package:flutter/foundation.dart';

class Contents {
  final String cId;
  final String content;
  final int status;
  final DateTime? createdAt;
  final String? createdId;
  final DateTime? updatedAt;
  final String? updatedId;

  Contents({
    required this.cId,
    required this.content,
    required this.status,
    this.createdAt,
    this.createdId,
    this.updatedAt,
    this.updatedId,
  });

  // JSON데이터를 Dart 객체로 변환
  // factory Contents.fromJson(Map<String, dynamic> json) {
  //   return Contents(
  //     cId: json['cId'],
  //     content: json['content'],
  //     status: json['status'],
  //     createdAt: json['created_at'] != null
  //         ? DateTime.parse(json['created_at'] as String)
  //         : null,
  //     createdId: json['created_id'] as String,
  //     updatedAt: json['updated_at'] != null
  //         ? DateTime.parse(json['updated_at'] as String)
  //         : null,
  //     updatedId: json['updated_id'] as String,
  //   );
  // }
  factory Contents.fromJson(String cId, Map<String, dynamic> json) {
    return Contents(
      cId: cId,
      // 🌟 json['content']가 null일 때를 대비해 'text' 키를 바라보고, 최종 ?? '' 처리를 해줍니다.
      content: json['text'] as String? ?? json['content'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      // cPos: json['c_pos'] as int? ?? 0,
    );
  }
}
