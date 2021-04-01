

class User {
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
  String accountType;
  String school;
  String startSchool;
  String endSchool;
  String college;
  String startCollege;
  String endCollege;
  String university;
  String startUniversity;
  String endUniversity;
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
  String certification1;
  String certification2;
  String certification3;
  String company1;
  String startCompany1;
  String endCompany1;
  String company2;
  String startCompany2;
  String endCompany2;
  String company3;
  String startCompany3;
  String endCompany3;
  String employees;
  String medal;
  bool isVerified;
  bool isPrivate;
  bool isHidden;
  String gst;

  User({
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
    this.accountType,
    this.school,
    this.startSchool,
    this.endSchool,
    this.college,
    this.startCollege,
    this.endCollege,
    this.university,
    this.startUniversity,
    this.endUniversity,
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
    this.certification1,
    this.certification2,
    this.certification3,
    this.employees,
    this.company1,
    this.startCompany1,
    this.endCompany1,
    this.company2,
    this.startCompany2,
    this.endCompany2,
    this.company3,
    this.startCompany3,
    this.endCompany3,
    this.medal,
    this.isVerified,
    this.isPrivate,
    this.isHidden,
    this.gst,
  });

  Map toMap(User user) {
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
    data['displayName'] = user.displayName;
    data['bio'] = user.bio;
    data['gender'] = user.gender;
    data['status'] = user.status;
    data['accountType'] = user.accountType;
    data['school'] = user.school;
    data['startSchool'] = user.startSchool;
    data['endSchool'] = user.endSchool;
    data['college'] = user.college;
    data['startCollege'] = user.startCollege;
    data['endCollege'] = user.endCollege;
    data['university'] = user.university;
    data['startUniversity'] = user.startUniversity;
    data['endUniversity'] = user.endUniversity;
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
    data['certification1'] = user.certification1;
    data['certification2'] = user.certification2;
    data['certification3'] = user.certification3;
    data['employees'] = user.employees;
    data['company1'] = user.company1;
    data['company2'] = user.company2;
    data['company3'] = user.company3;
    data['startCompany1'] = user.startCompany1;
    data['startCompany2'] = user.startCompany2;
    data['startCompany3'] = user.startCompany3;
    data['endCompany1'] = user.endCompany1;
    data['endCompany2'] = user.endCompany2;
    data['endCompany3'] = user.endCompany3;
    data['medal'] = user.medal;
    data['isVerified'] = user.isVerified;
    data['isPrivate'] = user.isPrivate;
    data['isHidden'] = user.isHidden;
    data['gst'] = user.gst;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
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
    this.bio = mapData['bio'];
    this.gender = mapData['gender'];
    this.status = mapData['status'];
    this.accountType = mapData['accountType'];
    this.school = mapData['school'];
    this.startSchool = mapData['startSchool'];
    this.endSchool = mapData['endSchool'];
    this.college = mapData['college'];
    this.startCollege = mapData['startCollege'];
    this.endCollege = mapData['endCollege'];
    this.university = mapData['university'];
    this.startUniversity = mapData['startUniversity'];
    this.endUniversity = mapData['endUniversity'];
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
    this.certification1 = mapData['certification1'];
    this.certification2 = mapData['certification2'];
    this.certification3 = mapData['certification3'];
    this.employees = mapData['employees'];
    this.company1 = mapData['company1'];
    this.company2 = mapData['company2'];
    this.company3 = mapData['company3'];
    this.startCompany1 = mapData['startCompany1'];
    this.startCompany2 = mapData['startCompany2'];
    this.startCompany3 = mapData['startCompany3'];
    this.endCompany1 = mapData['endCompany1'];
    this.endCompany2 = mapData['endCompany2'];
    this.endCompany3 = mapData['endCompany3'];
    this.medal = mapData['medal'];
    this.isVerified = mapData['isVerified'];
    this.isPrivate = mapData['isPrivate'];
    this.isHidden = mapData['isHidden'];
    this.gst = mapData['gst'];
  }
}
