import 'package:cloud_firestore/cloud_firestore.dart';

class TeamFeed {
  String actId;
  List<String> assigned;
  String ownerName;
  String ownerUid;
  String type;
  String imgUrl;
  String postId;
  String ownerPhotoUrl;
  String commentData;
  String gid;
  String deptId;
  String projectId;
  String gname;
  String groupProfilePhoto;
  FieldValue timestamp;

  TeamFeed(
      {this.actId,
      this.assigned,
      this.ownerName,
      this.ownerUid,
      this.type,
      this.imgUrl,
      this.postId,
      this.ownerPhotoUrl,
      this.commentData,
      this.gid,
      this.deptId,
      this.projectId,
      this.gname,
      this.groupProfilePhoto,
      this.timestamp});

  Map toMap(TeamFeed teamFeed) {
    var data = Map<String, dynamic>();
    data['actId'] = teamFeed.actId;
    data['assigned'] = teamFeed.assigned;
    data['ownerName'] = teamFeed.ownerName;
    data['ownerUid'] = teamFeed.ownerUid;
    data['type'] = teamFeed.type;
    data['imgUrl'] = teamFeed.imgUrl;
    data['postId'] = teamFeed.postId;
    data['ownerPhotoUrl'] = teamFeed.ownerPhotoUrl;
    data['commentData'] = teamFeed.commentData;
    data['gid'] = teamFeed.gid;
    data['deptId'] = teamFeed.deptId;
    data['projectId'] = teamFeed.projectId;
    data['gname'] = teamFeed.gname;
    data['groupProfilePhoto'] = teamFeed.groupProfilePhoto;
    data['timestamp'] = teamFeed.timestamp;
    return data;
  }

  TeamFeed.fromMap(Map<String, dynamic> mapData) {
    this.actId = mapData['actId'];
    this.assigned = mapData['assigned'];
    this.ownerName = mapData['ownerName'];
    this.ownerUid = mapData['ownerUid'];
    this.type = mapData['type'];
    this.imgUrl = mapData['imgUrl'];
    this.postId = mapData['postId'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.commentData = mapData['commentData'];
    this.gid = mapData['gid'];
    this.deptId = mapData['deptId'];
    this.projectId = mapData['projectId'];
    this.gname = mapData['gname'];
    this.groupProfilePhoto = mapData['groupProfilePhoto'];
    this.timestamp = mapData['timestamp'];
  }
}
