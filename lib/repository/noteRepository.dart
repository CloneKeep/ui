import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ui/core/api/api_client.dart';
import 'package:ui/data/models/notes_model.dart';

class NoteRepository {
  // 데이터 정제
  Future<List<Notes>> fetchNotesAndContents(String uId) async {
    try {
      final response = await ApiClient.instance.post(
        '/notes/me',
        data: {"uid": uId},
        options: Options(responseType: ResponseType.plain),
      );

      print('RESPONSE : $response');
      print('RESPONSE_type : ${response.runtimeType}');

      // 통신 성공
      if (response.statusCode == 200 && response.data != null) {
        final dynamic decodedBody = jsonDecode(response.data.toString());
        List<dynamic> rawNoteList = [];

        // 1. 최상위가 Map 구조일 때 안전하게 타입 컨버전
        if (decodedBody is Map) {
          final Map<String, dynamic> safeBody = Map<String, dynamic>.from(
            decodedBody,
          );

          if (safeBody.containsKey(uId)) {
            final dynamic userValue = safeBody[uId];

            if (userValue is List) {
              rawNoteList = userValue;
            } else if (userValue is Map) {
              // 💡 중요: 유저 데이터를 안전하게 Map<String, dynamic>으로 변환하여 리스트에 주입
              final Map<String, dynamic> userValueMap =
                  Map<String, dynamic>.from(userValue);
            }
          }
        } else if (decodedBody is List) {
          rawNoteList = decodedBody;
        }

        // 2. 모델로 변환하는 루프
        final List<Notes> parsedNotes = rawNoteList.map((noteElement) {
          final Map<String, dynamic> rawMap = noteElement is Map
              ? Map<String, dynamic>.from(noteElement)
              : {};

          // 🌟 [치트키 해결책]
          // 만약 꺼내온 rawMap 안에 uId(UUID) 키가 들어있다면,
          // 그 내부 맵({email: ..., title_name: ...})을 진짜 userData로 인정하고 꺼내옵니다.
          Map<String, dynamic> userData = {};
          if (rawMap.containsKey(uId) && rawMap[uId] is Map) {
            userData = Map<String, dynamic>.from(rawMap[uId]);
          } else {
            userData = rawMap; // 껍데기가 이미 벗겨져서 왔을 경우 대비 fallback
          }

          print('👉 진짜 변환에 사용하는 완전히 알몸이 된 userData: $userData');

          // contents 데이터 구조 안전 정제
          Map<String, dynamic> finalContentsMap = {};
          final dynamic rawContents = userData['contents'];
          if (rawContents is Map) {
            finalContentsMap = Map<String, dynamic>.from(rawContents);
          }

          // 3. 모델 규격에 맞춰 안전하게 매핑
          final Map<String, dynamic> adjustedJson = {
            'nId': userData['nid'] ?? userData['nId'] ?? '',
            'uId': uId,
            'n_pos': userData['note_position'] ?? userData['n_pos'] ?? 0,
            'title_name': userData['title_name'] ?? '', // 드디어 "testTitle2" 안착!
            'note_type': userData['note_type'] ?? '', // 드디어 "TEXT" 안착!
            'contents': finalContentsMap,
          };

          print('👉 최종 조립된 adjustedJson: $adjustedJson');
          return Notes.fromJson(adjustedJson);
        }).toList();

        return parsedNotes;
      }

      return [];
    } on DioException catch (e) {
      // 서버에러(500) 및 통신 장애 발생 시 exception 처리
      debugPrint("네트워크 통신 에러: ${e.message}");
      throw Exception("서버연결 실패 : ${e.response?.statusCode}");
    } catch (e) {
      debugPrint("데이터 처리 에러: $e");
      throw Exception("데이터 처리시 오류가 발생했습니다.");
    }
  }
}
