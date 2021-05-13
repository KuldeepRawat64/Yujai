import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String uid;
  String projectName;
  String currentUserUid;
  int projectProfilePhoto;
  String description;
  String location;
  String projectOwnerName;
  String projectOwnerPhotoUrl;
  String projectOwnerEmail;
  String agenda;
  bool isPrivate;
  bool isHidden;
  List<dynamic> rules;
  String customRules;
  FieldValue timestamp;
  int color;
  List<dynamic> members;

  Project({
    this.uid,
    this.projectName,
    this.currentUserUid,
    this.description,
    this.projectProfilePhoto,
    this.location,
    this.projectOwnerName,
    this.projectOwnerPhotoUrl,
    this.agenda,
    this.isPrivate,
    this.isHidden,
    this.projectOwnerEmail,
    this.rules,
    this.customRules,
    this.timestamp,
    this.color,
    this.members,
  });

  Map toMap(Project project) {
    var data = Map<String, dynamic>();
    data['uid'] = project.uid;
    data['projectName'] = project.projectName;
    data['ownerUid'] = project.currentUserUid;
    data['projectProfilePhoto'] = project.projectProfilePhoto;
    data['description'] = project.description;
    data['location'] = project.location;
    data['projectOwnerName'] = project.projectOwnerName;
    data['projectOwnerPhotoUrl'] = project.projectOwnerPhotoUrl;
    data['projectProfilePhoto'] = project.projectProfilePhoto;
    data['isPrivate'] = project.isPrivate;
    data['isHidden'] = project.isHidden;
    data['projectOwnerEmail'] = project.projectOwnerEmail;
    data['rules'] = project.rules;
    data['customRules'] = project.customRules;
    data['timestamp'] = project.customRules;
    data['color'] = project.color;
    data['members'] = project.members;
    return data;
  }

  Project.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.projectName = mapData['projectName'];
    this.currentUserUid = mapData['ownerUid'];
    this.projectProfilePhoto = mapData['projectProfilePhoto'];
    this.description = mapData['description'];
    this.location = mapData['location'];
    this.projectOwnerName = mapData['projectOwnerName'];
    this.projectOwnerPhotoUrl = mapData['projectOwnerPhotoUrl'];
    this.projectProfilePhoto = mapData['projectProfilePhoto'];
    this.isHidden = mapData['isHidden'];
    this.isPrivate = mapData['isPrivate'];
    this.projectOwnerEmail = mapData['projectOwnerEmail'];
    this.rules = mapData['rules'];
    this.customRules = mapData['customRules'];
    this.timestamp = mapData['time'];
    this.color = mapData['color'];
    this.members = mapData['members'];
  }
}
