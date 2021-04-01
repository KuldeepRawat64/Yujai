import 'package:cloud_firestore/cloud_firestore.dart';

class TaskList {
  String listId;
  String listName;
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  int color;
  FieldValue timestamp;
  int totalTasks;

  TaskList({
    this.listId,
    this.listName,
    this.ownerName,
    this.ownerPhotoUrl,
    this.ownerUid,
    this.color,
    this.timestamp,
    this.totalTasks,
  });

  Map toMap(TaskList taskList) {
    var data = Map<String, dynamic>();
    data['listId'] = taskList.listId;
    data['listName'] = taskList.listName;
    data['ownerName'] = taskList.ownerName;
    data['ownerPhotoUrl'] = taskList.ownerPhotoUrl;
    data['ownerUid'] = taskList.ownerUid;
    data['color'] = taskList.color;
    data['timestamp'] = taskList.timestamp;
    data['totalTasks'] = taskList.totalTasks;
    return data;
  }

  TaskList.fromMap(Map<String, dynamic> mapData) {
    this.listId = mapData['listId'];
    this.listName = mapData['listName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.color = mapData['color'];
    this.timestamp = mapData['timestamp'];
    this.totalTasks = mapData['totalTasks'];
  }
}
