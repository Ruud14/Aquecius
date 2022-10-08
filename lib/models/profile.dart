/// Model from profile table.
class Profile {
  String id;
  String username;
  DateTime updatedAt;
  String? phone;
  ActivityLevel? activityLevel;
  HairType? hairType;
  HairTexture? hairTexture;
  bool germyWorker;

  Profile(
      {required this.id,
      required this.username,
      required this.updatedAt,
      this.phone,
      this.activityLevel,
      this.hairType,
      this.hairTexture,
      this.germyWorker = false});

  Profile.fromJson(String id, Map<String, dynamic> json)
      : this.id = id,
        username = json['username'],
        updatedAt = DateTime.parse(json['updated_at']),
        phone = json['phone'],
        hairType = json['hair_type'] == null ? null : HairType.fromName(json['hair_type']),
        hairTexture = json['hair_texture'] == null ? null : HairTexture.fromName(json['hair_texture']),
        activityLevel = json['activity_level'] == null ? null : ActivityLevel.fromName(json['activity_level']),
        germyWorker = json['germy_worker'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "hair_type": hairType?.name,
      "hair_texture": hairTexture?.name,
      "activity_level": activityLevel?.name,
      "phone": phone,
      "updated_at": updatedAt.toIso8601String(),
      "germy_worker": germyWorker,
    };
  }
}

class ActivityLevel {
  String name;
  String exerciseFrequencyPerWeek;
  String stepsPerDay;

  ActivityLevel({
    required this.name,
    required this.exerciseFrequencyPerWeek,
    required this.stepsPerDay,
  });

  factory ActivityLevel.fromName(String name) {
    switch (name) {
      case "sedentary":
        return ActivityLevel.sedentary;
      case "lightly_active":
        return ActivityLevel.lightly_active;
      case "moderately_active":
        return ActivityLevel.moderately_active;
      case "highly_active":
        return ActivityLevel.highly_active;
      case "extremely_active":
        return ActivityLevel.extremely_active;
      default:
        throw Exception("Invalid ActivityLevel");
    }
  }

  static ActivityLevel sedentary = ActivityLevel(name: "sedentary", exerciseFrequencyPerWeek: "1x", stepsPerDay: "up to 3k");
  static ActivityLevel lightly_active = ActivityLevel(name: "lightly_active", exerciseFrequencyPerWeek: "1-3x", stepsPerDay: "3k-10k");
  static ActivityLevel moderately_active = ActivityLevel(name: "moderately_active", exerciseFrequencyPerWeek: "3-5x", stepsPerDay: "10k-15k");
  static ActivityLevel highly_active = ActivityLevel(name: "highly_active", exerciseFrequencyPerWeek: "6-7x", stepsPerDay: "15k-20k");
  static ActivityLevel extremely_active = ActivityLevel(name: "extremely_active", exerciseFrequencyPerWeek: "7+x", stepsPerDay: "25k+");

  String get dropdownString =>
      "${name.split('_').map((e) => e.substring(0, 1).toUpperCase() + e.substring(1)).join(' ')}  -  $exerciseFrequencyPerWeek/week  -  $stepsPerDay";
}

class HairType {
  String name;

  HairType({
    required this.name,
  });

  factory HairType.fromName(String name) {
    switch (name) {
      case "straight":
      case "wavy":
      case "curly":
      case "coily":
        return HairType(name: name);
      default:
        throw Exception("Invalid HairType");
    }
  }
}

class HairTexture {
  String name;

  HairTexture({
    required this.name,
  });

  factory HairTexture.fromName(String name) {
    switch (name) {
      case "fine":
      case "medium":
      case "coarse":
        return HairTexture(name: name);
      default:
        throw Exception("Invalid HairTexture");
    }
  }
}
