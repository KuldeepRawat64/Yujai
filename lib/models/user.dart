import 'package:Yujai/models/education.dart';
import 'package:Yujai/models/experience.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String username;
  String phone;
  String email;
  String dateOfBirth;
  String location;
  String photoUrl;
  String displayName;
  String bio;
  String followers;
  String following;
  String posts;
  String gender;
  String status;
  GeoPoint geoPoint;
  String accountType;
  List<dynamic> education;
  List<dynamic> experience;
  String website;
  String designation;
  List<dynamic> skills;
  String stream;
  List<dynamic> interests;
  List<dynamic> purpose;
  String rank;
  String military;
  String command;
  String regiment;
  String department;
  String companySlogan;
  String companySize;
  String postType;
  String products;
  String establishYear;
  String industry;
  List<dynamic> certifications;
  String employees;
  String medal;
  bool isVerified;
  bool isPrivate;
  bool isHidden;
  String gst;

  UserModel({
    this.posts,
    this.followers,
    this.following,
    this.uid,
    this.username,
    this.phone,
    this.email,
    this.dateOfBirth,
    this.location,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.gender,
    this.status,
    this.geoPoint,
    this.accountType,
    this.education,
    this.experience,
    this.website,
    this.designation,
    this.skills,
    this.stream,
    this.interests,
    this.purpose,
    this.rank,
    this.military,
    this.command,
    this.regiment,
    this.department,
    this.companySlogan,
    this.companySize,
    this.postType,
    this.products,
    this.establishYear,
    this.industry,
    this.certifications,
    this.employees,
    this.medal,
    this.isVerified,
    this.isPrivate,
    this.isHidden,
    this.gst,
  });

  Map toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['username'] = user.username;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['followers'] = user.followers;
    data['following'] = user.following;
    data['posts'] = user.posts;
    data['dateOfBirth'] = user.dateOfBirth;
    data['location'] = user.location;
    data['photoUrl'] = user.photoUrl;
    data['geoPoint'] = user.geoPoint;
    data['displayName'] = user.displayName;
    data['bio'] = user.bio;
    data['gender'] = user.gender;
    data['status'] = user.status;
    data['accountType'] = user.accountType;
    data['website'] = user.website;
    data['designation'] = user.designation;
    data['skills'] = user.skills;
    data['stream'] = user.stream;
    data['interests'] = user.interests;
    data['purpose'] = user.purpose;
    data['rank'] = user.rank;
    data['military'] = user.military;
    data['command'] = user.command;
    data['regiment'] = user.regiment;
    data['department'] = user.department;
    data['companySlogan'] = user.companySlogan;
    data['companySize'] = user.companySize;
    data['postType'] = user.postType;
    data['products'] = user.products;
    data['establishYear'] = user.establishYear;
    data['industry'] = user.industry;
    data['education'] = user.education;
    data['experience'] = user.experience;
    data['industry'] = user.industry;
    data['employees'] = user.employees;
    data['certifications'] = user.certifications;
    data['medal'] = user.medal;
    data['isVerified'] = user.isVerified;
    data['isPrivate'] = user.isPrivate;
    data['isHidden'] = user.isHidden;
    data['gst'] = user.gst;
    return data;
  }

  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.username = mapData['username'];
    this.phone = mapData['phone'];
    this.email = mapData['email'];
    this.followers = mapData['followers'];
    this.following = mapData['following'];
    this.posts = mapData['posts'];
    this.dateOfBirth = mapData['dateOfBirth'];
    this.location = mapData['location'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.geoPoint = mapData['geoPoint'];
    this.bio = mapData['bio'];
    this.gender = mapData['gender'];
    this.status = mapData['status'];
    this.accountType = mapData['accountType'];
    this.education = mapData['education'];
    this.experience = mapData['experience'];
    this.certifications = mapData['certifications'];
    this.website = mapData['website'];
    this.designation = mapData['designation'];
    this.skills = mapData['skills'];
    this.stream = mapData['stream'];
    this.rank = mapData['rank'];
    this.military = mapData['military'];
    this.command = mapData['command'];
    this.regiment = mapData['regiment'];
    this.department = mapData['department'];
    this.companySlogan = mapData['companySlogan'];
    this.companySize = mapData['companySize'];
    this.postType = mapData['postType'];
    this.interests = mapData['interests'];
    this.purpose = mapData['purpose'];
    this.products = mapData['products'];
    this.establishYear = mapData['establishYear'];
    this.industry = mapData['industry'];

    this.employees = mapData['employees'];

    this.medal = mapData['medal'];
    this.isVerified = mapData['isVerified'];
    this.isPrivate = mapData['isPrivate'];
    this.isHidden = mapData['isHidden'];
    this.gst = mapData['gst'];
  }
}
