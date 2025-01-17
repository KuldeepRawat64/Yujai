import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  String actId;
  String ownerName;
  String ownerUid;
  String type;
  String imgUrl;
  String postId;
  String ownerPhotoUrl;
  String commentData;
  String gid;
  String gname;
  String groupProfilePhoto;
  FieldValue timestamp;
  String postOwnerUid;

  Feed(
      {this.actId,
      this.ownerName,
      this.ownerUid,
      this.type,
      this.imgUrl,
      this.postId,
      this.ownerPhotoUrl,
      this.commentData,
      this.gid,
      this.gname,
      this.groupProfilePhoto,
      this.timestamp,
      this.postOwnerUid});

  Map toMap(Feed feed) {
    var data = Map<String, dynamic>();
    data['actId'] = feed.actId;
    data['ownerName'] = feed.ownerName;
    data['ownerUid'] = feed.ownerUid;
    data['type'] = feed.type;
    data['imgUrl'] = feed.imgUrl;
    data['postId'] = feed.postId;
    data['ownerPhotoUrl'] = feed.ownerPhotoUrl;
    data['commentData'] = feed.commentData;
    data['gid'] = feed.gid;
    data['gname'] = feed.gname;
    data['groupProfilePhoto'] = feed.groupProfilePhoto;
    data['timestamp'] = feed.timestamp;
    data['postOwnerUid'] = feed.postOwnerUid;
    return data;
  }

  Feed.fromMap(Map<String, dynamic> mapData) {
    this.actId = mapData['actId'];
    this.ownerName = mapData['ownerName'];
    this.ownerUid = mapData['ownerUid'];
    this.type = mapData['type'];
    this.imgUrl = mapData['imgUrl'];
    this.postId = mapData['postId'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.commentData = mapData['commentData'];
    this.gid = mapData['gid'];
    this.gname = mapData['gname'];
    this.groupProfilePhoto = mapData['groupProfilePhoto'];
    this.timestamp = mapData['timestamp'];
    this.postOwnerUid = mapData['postOwnerUid'];
  }
}
