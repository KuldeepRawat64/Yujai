import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  String postId;
  String currentUserUid;
  String caption;
  FieldValue time;
  int pollLength;

  String postType;
  String option1;
  String option2;
  String option3;
  String option4;

  String postOwnerName;
  String postOwnerPhotoUrl;

  Poll({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.time,
    this.pollLength,
    this.postType,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
  });

  Map toMap(Poll poll) {
    var data = Map<String, dynamic>();
    data['postId'] = poll.postId;
    data['ownerUid'] = poll.currentUserUid;
    data['caption'] = poll.caption;
    data['time'] = poll.time;
    data['pollLength'] = poll.pollLength;

    data['postType'] = poll.postType;
    data['option1'] = poll.option1;
    data['option2'] = poll.option2;
    data['option3'] = poll.option3;
    data['option4'] = poll.option4;

    data['postOwnerName'] = poll.postOwnerName;
    data['postOwnerPhotoUrl'] = poll.postOwnerPhotoUrl;
    return data;
  }

  Poll.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.caption = mapData['caption'];
    this.time = mapData['time'];
    this.pollLength = mapData['pollLength'];

    this.postType = mapData['postType'];
    this.option1 = mapData['option1'];
    this.option2 = mapData['option2'];
    this.option3 = mapData['option3'];
    this.option4 = mapData['option4'];

    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
  }
}
