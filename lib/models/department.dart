class Department {
  String uid;
  String departmentName;
  String currentUserUid;
  int departmentProfilePhoto;
  String description;
  String location;
  String departmentOwnerName;
  String departmentOwnerPhotoUrl;
  String departmentOwnerEmail;
  String agenda;
  bool isPrivate;
  bool isHidden;
  List<dynamic> rules;
  String customRules;
  int color;
  List<dynamic> members;

  Department({
    this.uid,
    this.departmentName,
    this.currentUserUid,
    this.description,
    this.departmentProfilePhoto,
    this.location,
    this.departmentOwnerName,
    this.departmentOwnerPhotoUrl,
    this.agenda,
    this.isPrivate,
    this.isHidden,
    this.departmentOwnerEmail,
    this.rules,
    this.customRules,
    this.color,
    this.members,
  });

  Map toMap(Department department) {
    var data = Map<String, dynamic>();
    data['uid'] = department.uid;
    data['departmentName'] = department.departmentName;
    data['ownerUid'] = department.currentUserUid;
    data['departmentProfilePhoto'] = department.departmentProfilePhoto;
    data['description'] = department.description;
    data['location'] = department.location;
    data['departmentOwnerName'] = department.departmentOwnerName;
    data['departmentOwnerPhotoUrl'] = department.departmentOwnerPhotoUrl;
    data['departmentProfilePhoto'] = department.departmentProfilePhoto;
    data['isPrivate'] = department.isPrivate;
    data['isHidden'] = department.isHidden;
    data['departmentOwnerEmail'] = department.departmentOwnerEmail;
    data['rules'] = department.rules;
    data['customRules'] = department.customRules;
    data['color'] = department.color;
    data['members'] = department.members;

    return data;
  }

  Department.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.departmentName = mapData['departmentName'];
    this.currentUserUid = mapData['ownerUid'];
    this.departmentProfilePhoto = mapData['departmentProfilePhoto'];
    this.description = mapData['description'];
    this.location = mapData['location'];
    this.departmentOwnerName = mapData['departmentOwnerName'];
    this.departmentOwnerPhotoUrl = mapData['departmentOwnerPhotoUrl'];
    this.departmentProfilePhoto = mapData['departmentProfilePhoto'];
    this.isHidden = mapData['isHidden'];
    this.isPrivate = mapData['isPrivate'];
    this.departmentOwnerEmail = mapData['departmentOwnerEmail'];
    this.rules = mapData['rules'];
    this.customRules = mapData['customRules'];
    this.color = mapData['color'];
    this.members = mapData['members'];
  }
}
