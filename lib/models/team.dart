class Team {
  String uid;
  String teamName;
  String currentUserUid;
  String teamProfilePhoto;
  String teamOwnerName;
  String teamOwnerPhotoUrl;
  String teamOwnerEmail;
  bool isPrivate;
  bool isHidden;
  List<dynamic> department;
  List<String> memberList;

  Team({
    this.uid,
    this.teamName,
    this.currentUserUid,
    this.teamProfilePhoto,
    this.teamOwnerName,
    this.teamOwnerPhotoUrl,
    this.isPrivate,
    this.isHidden,
    this.teamOwnerEmail,
    this.department,
    this.memberList,
  });

  Map toMap(Team team) {
    var data = Map<String, dynamic>();
    data['uid'] = team.uid;
    data['teamName'] = team.teamName;
    data['ownerUid'] = team.currentUserUid;
    data['teamProfilePhoto'] = team.teamProfilePhoto;
    data['teamOwnerName'] = team.teamOwnerName;
    data['teamOwnerPhotoUrl'] = team.teamOwnerPhotoUrl;
    data['teamProfilePhoto'] = team.teamProfilePhoto;
    data['isPrivate'] = team.isPrivate;
    data['isHidden'] = team.isHidden;
    data['teamOwnerEmail'] = team.teamOwnerEmail;
    data['department'] = team.department;
    data['memberList'] = team.memberList;
    return data;
  }

  Team.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.teamName = mapData['teamName'];
    this.currentUserUid = mapData['ownerUid'];
    this.teamProfilePhoto = mapData['teamProfilePhoto'];
    this.teamOwnerName = mapData['teamOwnerName'];
    this.teamOwnerPhotoUrl = mapData['teamOwnerPhotoUrl'];
    this.teamProfilePhoto = mapData['teamProfilePhoto'];
    this.isHidden = mapData['isHidden'];
    this.isPrivate = mapData['isPrivate'];
    this.teamOwnerEmail = mapData['teamOwnerEmail'];
    this.department = mapData['department'];
    this.memberList = mapData['memberList'];
  }
}
