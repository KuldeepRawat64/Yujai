import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  String postId;
  String currentUserUid;
  String caption;
  FieldValue time;
  String category;
  String pollType;
  String postType;
  String option1;
  String option2;
  String option3;
  String option4;
  String option5;
  String option6;
  String postOwnerName;
  String postOwnerPhotoUrl;

  Poll({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.time,
    this.category,
    this.pollType,
    this.postType,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.option5,
    this.option6,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
  });

  Map toMap(Poll poll) {
    var data = Map<String, dynamic>();
    data['postId'] = poll.postId;
    data['ownerUid'] = poll.currentUserUid;
    data['caption'] = poll.caption;
    data['time'] = poll.time;
    data['category'] = poll.category;
    data['pollType'] = poll.pollType;
    data['postType'] = poll.postType;
    data['option1'] = poll.option1;
    data['option2'] = poll.option2;
    data['option3'] = poll.option3;
    data['option4'] = poll.option4;
    data['option5'] = poll.option5;
    data['option6'] = poll.option6;
    data['postOwnerName'] = poll.postOwnerName;
    data['postOwnerPhotoUrl'] = poll.postOwnerPhotoUrl;
    return data;
  }

  Poll.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.caption = mapData['caption'];
    this.time = mapData['time'];
    this.category = mapData['category'];
    this.pollType = mapData['pollType'];
    this.postType = mapData['postType'];
    this.option1 = mapData['option1'];
    this.option2 = mapData['option2'];
    this.option3 = mapData['option3'];
    this.option4 = mapData['option4'];
    this.option5 = mapData['option5'];
    this.option6 = mapData['option6'];
    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
  }
}
