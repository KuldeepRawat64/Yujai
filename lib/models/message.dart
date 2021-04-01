import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderUid;
  String senderPhoto;
  String senderName;
  String receiverUid;
  String type;
  String message;
  FieldValue timestamp;
  String photoUrl;

  Message(
      {this.senderUid,
      this.senderPhoto,
      this.senderName,
      this.receiverUid,
      this.type,
      this.message,
      this.timestamp});
  Message.withoutMessage(
      {this.senderUid,
      this.senderPhoto,
      this.senderName,
      this.receiverUid,
      this.type,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['senderPhoto'] = this.senderPhoto;
    map['senderName'] = this.senderName;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message();
    _message.senderUid = map['senderUid'];
    _message.receiverUid = map['receiverUid'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.timestamp = map['timestamp'];
    _message.senderPhoto = map['senderPhoto'];
    _message.senderName = map['senderName'];
    return _message;
  }
}
