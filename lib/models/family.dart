/// Model for family table.
class Family {
  String id;
  String creator;
  List<String> members;
  List<String> requestedMembers;
  String inviteCode;
  String? isShowering;

  Family({
    required this.id,
    required this.creator,
    required this.members,
    required this.requestedMembers,
    required this.inviteCode,
    required this.isShowering,
  });

  Family.fromJson(Map<String, dynamic> json)
      : id = json['id']!,
        creator = json['creator']!,
        members = json['members']!,
        requestedMembers = json['requested_members']!,
        inviteCode = json['invite_code']!,
        isShowering = json['is_showering'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "creator": creator,
      "members": members,
      "requested_members": requestedMembers,
      "invite_code": inviteCode,
      "is_showering": isShowering,
    };
  }
}
