import 'package:cloud_firestore/cloud_firestore.dart';

class Discussion {
  String postId;
  String currentUserUid;
  String caption;
  FieldValue time;
  String postOwnerName;
  String postOwnerPhotoUrl;
  String postType;

  Discussion({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.time,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
    this.postType,
  });

  Map toMap(Discussion post) {
    var data = Map<String, dynamic>();
    data['postId'] = post.postId;
    data['ownerUid'] = post.currentUserUid;
    data['caption'] = post.caption;
    data['time'] = post.time;
    data['postType'] = post.postType;
    data['postOwnerName'] = post.postOwnerName;
    data['postOwnerPhotoUrl'] = post.postOwnerPhotoUrl;
    return data;
  }

  Discussion.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.caption = mapData['caption'];
    this.time = mapData['time'];
    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
    this.postType = mapData['postType'];
  }
}
