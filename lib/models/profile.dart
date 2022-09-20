/// Model from profile table.
class Profile {
  String id;
  String username;
  String website;
  String updatedAt;

  Profile({required this.id, required this.username, required this.website, required this.updatedAt});

  Profile.fromJson(String id, Map<String, dynamic> json)
      : this.id = id,
        username = json['username'],
        updatedAt = json['updated_at'],
        website = json['website'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "website": website,
      "updated_at": updatedAt,
    };
  }
}
