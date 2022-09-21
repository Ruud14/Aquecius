import 'dart:ffi';

/// Model from session table.
class ShowerSession {
  String? id;
  String startedAt;
  String endedAt;
  double consumption;
  String userId;

  ShowerSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.consumption,
    required this.userId,
  });

  ShowerSession.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        startedAt = json['started_at'],
        endedAt = json['ended_at'],
        consumption = json['consumption'].toDouble(),
        userId = json['user_id'];

  Map<String, dynamic> toJson() {
    return {
      "started_at": startedAt,
      "ended_at": endedAt,
      "consumption": consumption,
      "user_id": userId,
    };
  }
}
