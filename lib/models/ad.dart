import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  String postId;
  String currentUserUid;
  String imgUrl;
  String caption;
  String location;
  String condition;
  String description;
  String price;
  FieldValue time;
  String postOwnerName;
  String postOwnerPhotoUrl;
  String postType;

  Ad({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.condition,
    this.description,
    this.price,
    this.imgUrl,
    this.location,
    this.time,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
    this.postType,
  });

  Map toMap(Ad post) {
    var data = Map<String, dynamic>();
    data['postId'] = post.postId;
    data['ownerUid'] = post.currentUserUid;
    data['imgUrl'] = post.imgUrl;
    data['caption'] = post.caption;
    data['description'] = post.description;
    data['price'] = post.price;
    data['condition'] = post.condition;
    data['location'] = post.location;
    data['time'] = post.time;
    data['postType'] = post.postType;
    data['postOwnerName'] = post.postOwnerName;
    data['postOwnerPhotoUrl'] = post.postOwnerPhotoUrl;
    return data;
  }

  Ad.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.condition = mapData['condition'];
    this.description = mapData['description'];
    this.price = mapData['price'];
    this.time = mapData['time'];
    this.postType = mapData['postType'];
    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
  }
}
