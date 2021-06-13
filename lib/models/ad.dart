import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  String postId;
  String currentUserUid;
  String imgUrl;
  String caption;
  String location;
  String city;
  String condition;
  String description;
  String price;
  FieldValue time;
  String postOwnerName;
  String postOwnerPhotoUrl;
  String postType;
  String category;
  List<String> imgUrls;
  GeoPoint geopoint;

  Ad({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.condition,
    this.description,
    this.price,
    this.imgUrl,
    this.location,
    this.city,
    this.time,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
    this.postType,
    this.category,
    this.imgUrls,
    this.geopoint,
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
    data['city'] = post.city;
    data['time'] = post.time;
    data['postType'] = post.postType;
    data['category'] = post.category;
    data['imgUrls'] = post.imgUrls;
    data['postOwnerName'] = post.postOwnerName;
    data['postOwnerPhotoUrl'] = post.postOwnerPhotoUrl;
    data['geopoint'] = post.geopoint;
    return data;
  }

  Ad.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.city = mapData['city'];
    this.condition = mapData['condition'];
    this.description = mapData['description'];
    this.price = mapData['price'];
    this.time = mapData['time'];
    this.postType = mapData['postType'];
    this.category = mapData['category'];
    this.imgUrls = mapData['imgUrls'];
    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
    this.geopoint = mapData['geopoint'];
  }
}
