import 'package:cloud_firestore/cloud_firestore.dart';

class Follower {
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  String accountType;
  FieldValue timestamp;

  Follower({
    this.ownerName,
    this.ownerPhotoUrl,
    this.ownerUid,
    this.accountType,
    this.timestamp,
  });

  Map toMap(Follower follower) {
    var data = Map<String, dynamic>();
    data['ownerName'] = follower.ownerName;
    data['ownerPhotoUrl'] = follower.ownerPhotoUrl;
    data['ownerUid'] = follower.ownerUid;
    data['accountType'] = follower.accountType;
    data['timestamp'] = follower.timestamp;
    return data;
  }

  Follower.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.accountType = mapData['accountType'];
    this.timestamp = mapData['timestamp'];
  }
}
