class Hierarchy {
  final String hId;
  final String nId;
  final int? nPos;
  final String cId;
  final String? cntPid;
  final int? cPos;
  final DateTime? createdAt;
  final String? createdId;
  final DateTime? updatedAt;
  final String? updatedId;

  Hierarchy({
    required this.hId,
    required this.nId,
    this.nPos,
    required this.cId,
    this.cntPid,
    this.cPos,
    this.createdAt,
    this.createdId,
    this.updatedAt,
    this.updatedId,
  });

  // JSON데이터를 Dart 객체로 변환
  factory Hierarchy.fromJson(Map<String, dynamic> json) {
    return Hierarchy(
      hId: json['hId'],
      nId: json['nId'],
      nPos: json['n_pos'],
      cId: json['cId'],
      cntPid: json['cnt_pid'],
      cPos: json['c_pos'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      createdId: json['created_id'] as String,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      updatedId: json['updated_id'] as String,
    );
  }
}
