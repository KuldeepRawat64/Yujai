class Group {
  String uid;
  String groupName;
  String currentUserUid;
  String groupProfilePhoto;
  String description;
  String location;
  String groupOwnerName;
  String groupOwnerPhotoUrl;
  String groupOwnerEmail;
  String agenda;
  bool isPrivate;
  bool isHidden;
  List<dynamic> rules;
  String customRules;

  Group({
    this.uid,
    this.groupName,
    this.currentUserUid,
    this.description,
    this.groupProfilePhoto,
    this.location,
    this.groupOwnerName,
    this.groupOwnerPhotoUrl,
    this.agenda,
    this.isPrivate,
    this.isHidden,
    this.groupOwnerEmail,
    this.rules,
    this.customRules,
  });

  Map toMap(Group group) {
    var data = Map<String, dynamic>();
    data['uid'] = group.uid;
    data['groupName'] = group.groupName;
    data['ownerUid'] = group.currentUserUid;
    data['groupProfilePhoto'] = group.groupProfilePhoto;
    data['description'] = group.description;
    data['location'] = group.location;
    data['groupOwnerName'] = group.groupOwnerName;
    data['groupOwnerPhotoUrl'] = group.groupOwnerPhotoUrl;
    data['groupProfilePhoto'] = group.groupProfilePhoto;
    data['isPrivate'] = group.isPrivate;
    data['isHidden'] = group.isHidden;
    data['groupOwnerEmail'] = group.groupOwnerEmail;
    data['rules'] = group.rules;
    data['customRules'] = group.customRules;

    return data;
  }

  Group.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.groupName = mapData['groupName'];
    this.currentUserUid = mapData['ownerUid'];
    this.groupProfilePhoto = mapData['groupProfilePhoto'];
    this.description = mapData['description'];
    this.location = mapData['location'];
    this.groupOwnerName = mapData['groupOwnerName'];
    this.groupOwnerPhotoUrl = mapData['groupOwnerPhotoUrl'];
    this.groupProfilePhoto = mapData['groupProfilePhoto'];
    this.isHidden = mapData['isHidden'];
    this.isPrivate = mapData['isPrivate'];
    this.groupOwnerEmail = mapData['groupOwnerEmail'];
    this.rules = mapData['rules'];
    this.customRules = mapData['customRules'];
  }
}
