import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String postId;
  String currentUserUid;
  String imgUrl;
  String caption;
  String location;
  String postType;
  FieldValue time;
  String postOwnerName;
  String postOwnerPhotoUrl;

  Post({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.imgUrl,
    this.postType,
    this.location,
    this.time,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
  });

  Map toMap(Post post) {
    var data = Map<String, dynamic>();
    data['postId'] = post.postId;
    data['ownerUid'] = post.currentUserUid;
    data['imgUrl'] = post.imgUrl;
    data['caption'] = post.caption;
    data['location'] = post.location;
    data['postType'] = post.postType;
    data['time'] = post.time;
    data['postOwnerName'] = post.postOwnerName;
    data['postOwnerPhotoUrl'] = post.postOwnerPhotoUrl;
    return data;
  }

  Post.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.postType = mapData['postType'];
    this.time = mapData['time'];
    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
  }
}
