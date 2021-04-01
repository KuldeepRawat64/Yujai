import 'package:cloud_firestore/cloud_firestore.dart';

class Following {
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  String accountType;
  FieldValue timestamp;

  Following({
    this.ownerName,
    this.ownerPhotoUrl,
    this.ownerUid,
    this.accountType,
    this.timestamp,
  });

  Map toMap(Following following) {
    var data = Map<String, dynamic>();
    data['ownerName'] = following.ownerName;
    data['ownerPhotoUrl'] = following.ownerPhotoUrl;
    data['ownerUid'] = following.ownerUid;
    data['accountType'] = following.accountType;
    data['timestamp'] = following.timestamp;
    return data;
  }

  Following.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.accountType = mapData['accountType'];
    this.timestamp = mapData['timestamp'];
  }
}
