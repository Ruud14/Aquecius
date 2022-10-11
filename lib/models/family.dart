/// Model for family table.
class Family {
  String id;
  String creator;
  String inviteCode;
  String? isShowering;

  Family({
    required this.id,
    required this.creator,
    required this.inviteCode,
    required this.isShowering,
  });

  Family.fromJson(Map<String, dynamic> json)
      : id = json['id']!,
        creator = json['creator']!,
        inviteCode = json['invite_code']!,
        isShowering = json['is_showering'];

  Map<String, dynamic> toJson() {
    return {
      "creator": creator,
      "invite_code": inviteCode,
      "is_showering": isShowering,
    };
  }
}
