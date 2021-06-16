import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String taskId;
  String taskName;
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;
  FieldValue timestamp;
  String dueDateRange;
  bool isCompleted;
  String assigned;
  String assignedName;
  String assignedEmail;
  String assignedPhoto;
  String dueDateRangeStart;
  String dueDateRangeEnd;
  String description;
  int count;

  TaskModel(
      {this.taskId,
      this.taskName,
      this.ownerName,
      this.ownerPhotoUrl,
      this.ownerUid,
      this.timestamp,
      this.dueDateRange,
      this.isCompleted,
      this.assigned,
      this.assignedName,
      this.assignedPhoto,
      this.dueDateRangeStart,
      this.dueDateRangeEnd,
      this.description,
      this.count});

  Map toMap(TaskModel task) {
    var data = Map<String, dynamic>();
    data['taskId'] = task.taskId;
    data['taskName'] = task.taskName;
    data['ownerName'] = task.ownerName;
    data['ownerPhotoUrl'] = task.ownerPhotoUrl;
    data['ownerUid'] = task.ownerUid;
    data['timestamp'] = task.timestamp;
    data['dueDateRange'] = task.dueDateRange;
    data['isCompleted'] = task.isCompleted;
    data['assigned'] = task.assigned;
    data['assignedName'] = task.assignedName;
    data['assignedPhoto'] = task.assignedPhoto;
    data['dueDateRangeStart'] = task.dueDateRangeStart;
    data['dueDateRangeEnd'] = task.dueDateRangeEnd;
    data['description'] = task.description;
    data['count'] = task.count;
    return data;
  }

  TaskModel.fromMap(Map<String, dynamic> mapData) {
    this.taskId = mapData['taskId'];
    this.taskName = mapData['taskName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.timestamp = mapData['timestamp'];
    this.dueDateRange = mapData['dueDateRange'];
    this.isCompleted = mapData['isCompleted'];
    this.assigned = mapData['assigned'];
    this.assignedName = mapData['assignedName'];
    this.assignedPhoto = mapData['assignedPhoto'];
    this.dueDateRangeStart = mapData['dueDateRangeStart'];
    this.dueDateRangeEnd = mapData['dueDateRangeEnd'];
    this.description = mapData['description'];
    this.count = mapData['count'];
  }
}
