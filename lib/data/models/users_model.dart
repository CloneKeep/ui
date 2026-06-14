class Users {
  final String uid;
  final String email;
  final String? pwHash;
  final DateTime createdAt;
  final String createdId;
  final DateTime updatedAt;
  final String updatedId;

  Users({
    required this.uid,
    required this.email,
    this.pwHash,
    required this.createdAt,
    required this.createdId,
    required this.updatedAt,
    required this.updatedId,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'] as String,
      email: json['email'] as String,
      pwHash: json['pw_hash'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdId: json['created_id'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      updatedId: json['updated_id'] as String,
    );
  }
}
