import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String postId;
  String ownerName;
  String ownerPhotoUrl;
  String comment;
  String type;
  FieldValue timeStamp;
  String ownerUid;
  String imgUrl;

  Comment(
      {this.ownerName,
      this.ownerPhotoUrl,
      this.comment,
      this.timeStamp,
      this.ownerUid,
      this.type,
      this.imgUrl,
      this.postId
      });

  Map toMap(Comment comment) {
    var data = Map<String, dynamic>();
    data['ownerName'] = comment.ownerName;
    data['ownerPhotoUrl'] = comment.ownerPhotoUrl;
    data['comment'] = comment.comment;
    data['timestamp'] = comment.timeStamp;
    data['ownerUid'] = comment.ownerUid;
    data['imgUrl'] = comment.imgUrl;
    data['postId'] = comment.postId;
    return data;
  }

  Comment.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.comment = mapData['comment'];
    this.timeStamp = mapData['timestamp'];
    this.ownerUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.postId = mapData['postId'];
  }
}
