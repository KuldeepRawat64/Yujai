import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String postId;
  String currentUserUid;
  String caption;
  String location;
  FieldValue time;
  String jobOwnerName;
  String jobOwnerPhotoUrl;
  String industry;
  String jobType;
  String workDays;
  String minSalary;
  String maxSalary;
  String timing;
  String description;
  String website;

  Job({
    this.postId,
    this.currentUserUid,
    this.caption,
    this.location,
    this.time,
    this.jobOwnerName,
    this.jobOwnerPhotoUrl,
    this.industry,
    this.workDays,
    this.minSalary,
    this.maxSalary,
    this.jobType,
    this.timing,
    this.description,
    this.website,
  });

  Map toMap(Job job) {
    var data = Map<String, dynamic>();
    data['postId'] = job.postId;
    data['ownerUid'] = job.currentUserUid;
    data['caption'] = job.caption;
    data['location'] = job.location;
    data['time'] = job.time;
    data['jobOwnerName'] = job.jobOwnerName;
    data['jobOwnerPhotoUrl'] = job.jobOwnerPhotoUrl;
    data['industry'] = job.industry;
    data['minSalary'] = job.minSalary;
    data['maxSalary'] = job.maxSalary;
    data['jobType'] = job.jobType;
    data['workDays'] = job.workDays;
    data['timing'] = job.timing;
    data['description'] = job.description;
    data['website'] = job.website;
    return data;
  }

  Job.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.currentUserUid = mapData['ownerUid'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.time = mapData['time'];
    this.jobOwnerName = mapData['jobOwnerName'];
    this.jobOwnerPhotoUrl = mapData['jobOwnerPhotoUrl'];
    this.industry = mapData['industry'];
    this.minSalary = mapData['minSalary'];
    this.maxSalary = mapData['maxSalary'];
    this.jobType = mapData['jobType'];
    this.workDays = mapData['workDays'];
    this.timing = mapData['timing'];
    this.description = mapData['description'];
    this.website = mapData['website'];
  }
}
