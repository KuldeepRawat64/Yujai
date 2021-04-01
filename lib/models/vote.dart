import 'package:cloud_firestore/cloud_firestore.dart';

class Vote {
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  FieldValue timestamp;

  Vote({this.ownerName, this.ownerPhotoUrl, this.ownerUid, this.timestamp});

  Map toMap(Vote vote) {
    var data = Map<String, dynamic>();
    data['ownerName'] = vote.ownerName;
    data['ownerPhotoUrl'] = vote.ownerPhotoUrl;
    data['ownerUid'] = vote.ownerUid;
    data['timestamp'] = vote.timestamp;
    return data;
  }

  Vote.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.timestamp = mapData['timestamp'];
  }
}
