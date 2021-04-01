import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  String postId;
  String currentUserUid;
  String imgUrl;
  String caption;
  FieldValue time;
  String newsOwnerName;
  String newsOwnerPhotoUrl;
  String source;

  News({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.imgUrl,
    this.time,
    this.newsOwnerName,
    this.newsOwnerPhotoUrl,
    this.source,
  });

  Map toMap(News news) {
    var data = Map<String, dynamic>();
    data['postId'] = news.postId;
    data['ownerUid'] = news.currentUserUid;
    data['imgUrl'] = news.imgUrl;
    data['caption'] = news.caption;
    data['time'] = news.time;
    data['newsOwnerName'] = news.newsOwnerName;
    data['newsOwnerPhotoUrl'] = news.newsOwnerPhotoUrl;
    data['source'] = news.source;
    return data;
  }

  News.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.time = mapData['time'];
    this.newsOwnerName = mapData['newsOwnerName'];
    this.newsOwnerPhotoUrl = mapData['newsOwnerPhotoUrl'];
    this.source = mapData['source'];
  }
}
