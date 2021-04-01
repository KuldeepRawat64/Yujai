import 'package:cloud_firestore/cloud_firestore.dart';

class Invite {
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  String accountType;
  FieldValue timestamp;

  Invite({
    this.ownerName,
    this.ownerPhotoUrl,
    this.ownerUid,
    this.accountType,
    this.timestamp,
  });

  Map toMap(Invite invite) {
    var data = Map<String, dynamic>();
    data['ownerName'] = invite.ownerName;
    data['ownerPhotoUrl'] = invite.ownerPhotoUrl;
    data['ownerUid'] = invite.ownerUid;
    data['accountType'] = invite.accountType;
    data['timestamp'] = invite.timestamp;
    return data;
  }

  Invite.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.accountType = mapData['accountType'];
    this.timestamp = mapData['timestamp'];
  }
}
