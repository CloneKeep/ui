import 'package:flutter/foundation.dart';
import 'contents_model.dart';

class Note {
  final String nId;
  final String uId;
  final String title;
  final String type;
  final int nPos;
  final String isColor;
  final bool isPinned;
  final bool isArchived;
  final bool isTrashed;
  final DateTime createdAt;
  final String createdId;
  final DateTime? updatedAt;
  final String? updatedId;
  final List<Contents>? contents;

  Note({
    required this.nId,
    required this.uId,
    required this.title,
    required this.type,
    required this.nPos,
    required this.isColor,
    required this.isPinned,
    required this.isArchived,
    required this.isTrashed,
    required this.createdAt,
    required this.createdId,
    this.updatedAt,
    this.updatedId,
    this.contents,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      nId: json['nId'],
      uId: json['uId'],
      title: json['title'],
      type: json['type'],
      nPos: json['nPos'],
      isColor: json['isColor'],
      isPinned: json['isPinned'],
      isArchived: json['isArchived'],
      isTrashed: json['isTrashed'],
      createdAt: DateTime.parse(json['createAt']),
      createdId: json['createId'],
      updatedAt: DateTime.parse(json['updateAt']),
      updatedId: json['updateId'],
      contents: (json['contents'] as List<dynamic>?)
          ?.map((e) => Contents.fromJson(e))
          .toList(),
    );
  }
}
