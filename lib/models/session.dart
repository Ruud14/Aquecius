/// Model from session table.
class ShowerSession {
  String? id;
  DateTime startedAt;
  DateTime endedAt;
  double consumption;
  List<double> temperatures;
  String userId;
  int points;

  ShowerSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.consumption,
    required this.userId,
    required this.temperatures,
    required this.points,
  });

  ShowerSession.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        startedAt = DateTime.parse(json['started_at']),
        endedAt = DateTime.parse(json['ended_at']),
        consumption = json['consumption'].toDouble(),
        temperatures = List<double>.from(json['temperatures']),
        points = json['points'],
        userId = json['user_id'];

  Map<String, dynamic> toJson() {
    return {
      "started_at": startedAt.toIso8601String(),
      "ended_at": endedAt.toIso8601String(),
      "consumption": consumption,
      "temperatures": temperatures,
      "points": points,
      "user_id": userId,
    };
  }

  int get averageTemperature => (temperatures.reduce((a, b) => a + b) / temperatures.length).round();
  int get durationMinutes => endedAt.difference(startedAt).inMinutes.abs();
}
