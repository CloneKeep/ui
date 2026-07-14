class Users {
  final String uid;
  final String email;
  final String? pwHash;
  final DateTime? createdAt;
  final String? createdId;
  final DateTime? updatedAt;
  final String? updatedId;

  Users({
    required this.uid,
    required this.email,
    this.pwHash,
    this.createdAt,
    this.createdId,
    this.updatedAt,
    this.updatedId,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'] as String,
      email: json['email'] as String,
      pwHash: json['pw_hash'] as String?,
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
