import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom{
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  FieldValue timestamp;

  ChatRoom({this.ownerName,this.ownerPhotoUrl,this.ownerUid,this.timestamp});
 
 Map toMap(ChatRoom chatRoom){
   var data = Map<String,dynamic>();
   data['ownerName'] = chatRoom.ownerName;
   data['ownerPhotoUrl'] = chatRoom.ownerPhotoUrl;
   data['ownerUid'] = chatRoom.ownerUid;
   data['timestamp'] = chatRoom.timestamp;
   return data;
 }

 ChatRoom.fromMap(Map<String,dynamic> mapData){
   this.ownerName = mapData['ownerName'];
   this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
   this.ownerUid = mapData['ownerUid'];
   this.timestamp = mapData['timestamp'];
 }
}