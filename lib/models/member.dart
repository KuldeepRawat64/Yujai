import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  String accountType;
  FieldValue timestamp;

  Member({
    this.ownerName,
    this.ownerPhotoUrl,
    this.ownerUid,
    this.accountType,
    this.timestamp,
  });

  Map toMap(Member like) {
    var data = Map<String, dynamic>();
    data['ownerName'] = like.ownerName;
    data['ownerPhotoUrl'] = like.ownerPhotoUrl;
    data['ownerUid'] = like.ownerUid;
    data['accountType'] = like.accountType;
    data['timestamp'] = like.timestamp;
    return data;
  }

  Member.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.accountType = mapData['accountType'];
    this.timestamp = mapData['timestamp'];
  }
}
