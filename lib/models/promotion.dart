import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  String postId;
  String currentUserUid;
  String caption;
  String location;
  FieldValue time;
  String promotionOwnerName;
  String promotionOwnerPhotoUrl;
  String portfolio;
  String timing;
  String category;
  String description;
  String locations;
  String skills;

  Promotion({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.location,
    this.time,
    this.promotionOwnerName,
    this.promotionOwnerPhotoUrl,
    this.portfolio,
    this.timing,
    this.category,
    this.description,
    this.locations,
    this.skills,
  });

  Map toMap(Promotion promotion) {
    var data = Map<String, dynamic>();
    data['postId'] = promotion.postId;
    data['ownerUid'] = promotion.currentUserUid;
    data['caption'] = promotion.caption;
    data['location'] = promotion.location;
    data['time'] = promotion.time;
    data['promotionOwnerName'] = promotion.promotionOwnerName;
    data['promotionOwnerPhotoUrl'] = promotion.promotionOwnerPhotoUrl;
    data['portfolio'] = promotion.portfolio;
    data['timing'] = promotion.timing;
    data['category'] = promotion.category;
    data['description'] = promotion.description;
    data['locations'] = promotion.locations;
    data['skills'] = promotion.skills;
    return data;
  }

  Promotion.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.time = mapData['time'];
    this.promotionOwnerName = mapData['promotionOwnerName'];
    this.promotionOwnerPhotoUrl = mapData['promotionOwnerPhotoUrl'];
    this.portfolio = mapData['portfolio'];
    this.timing = mapData['timing'];
    this.category = mapData['category'];
    this.description = mapData['description'];
    this.locations = mapData['locations'];
    this.skills = mapData['skills'];
  }
}
