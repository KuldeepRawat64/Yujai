import 'dart:io';
import 'dart:async';
import 'dart:math';
//import 'package:Yujai/main.dart';
import 'package:Yujai/models/chatroom.dart';
import 'package:Yujai/models/comment.dart';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/discussion.dart';
import 'package:Yujai/models/education.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/invite.dart';
import 'package:Yujai/models/like.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/message.dart';
import 'package:Yujai/models/poll.dart';
import 'package:Yujai/models/post.dart';
import 'package:Yujai/models/event.dart';
import 'package:Yujai/models/news.dart';
import 'package:Yujai/models/job.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/promotion.dart';
import 'package:Yujai/models/task.dart';
import 'package:Yujai/models/task_list.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
//import 'package:Yujai/pages/event_upload.dart';
import 'package:Yujai/models/follower.dart';
import 'package:Yujai/models/following.dart';
//import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:Yujai/models/ad.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel user;
  Group group;
  Post post;
  Event event;
  News news;
  Team team;
  Job job;
  Ad ad;
  Poll poll;
  Invite invite;
  Promotion promotion;
  Discussion discussion;
  Department departments;
  Like like;
  Follower follower;
  Following following;
  Message _message;
  ChatRoom _chatRoom;
  Comment comment;
  Project project;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Reference _storageReference;
  String postId = Uuid().v4();
  String groupId = Uuid().v4();
  String teamId = Uuid().v4();
  String departmentId = Uuid().v4();
  String projectId = Uuid().v4();
  String listId = Uuid().v4();
  String taskId = Uuid().v4();
  String msgId = Uuid().v4();

  Future<void> addDataToDb(User currentUser) async {
    print('Inside addDataToDb Method');

    _firestore
        .collection('display_names')
        .doc(currentUser.displayName)
        .set({'displayName': currentUser.displayName});

    user = UserModel(
      uid: currentUser.uid,
      email: currentUser.email,
      displayName: currentUser.displayName,
      photoUrl: currentUser.photoURL,
      isPrivate: false,
      isVerified: false,
      isHidden: false,
      followers: '0',
      following: '0',
      bio: '',
      posts: '0',
      phone: '',
      dateOfBirth: '',
      location: '',
      username: '',
      gender: '',
      status: '',
      accountType: 'Professional',
      education: [],
      experience: [],
      certifications: [],
      website: '',
      designation: '',
      skills: [],
      stream: '',
      rank: '',
      command: '',
      regiment: '',
      department: '',
      companySlogan: '',
      companySize: '',
      postType: '',
      interests: [],
      military: '',
      products: '',
      purpose: [],
      industry: '',
      establishYear: '',
      employees: '',
      medal: '',
    );

    //make new user their own follower to show their posts on their timeline
    // _firestore
    //     .collection('users')
    //     .document(currentUser.uid)
    //     .collection('following')
    //     .document(currentUser.uid)
    //     .setData({});
    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  Future<bool> authenticateUser(User user) async {
    print('Inside authenticateUser');
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;
    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    print('Email Id : ${currentUser.email}');
    return currentUser;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _signInAuthentication.idToken,
      accessToken: _signInAuthentication.accessToken,
    );

    final UserCredential user = await _auth.signInWithCredential(credential);
    return user.user;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    UploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask).ref.getDownloadURL();
    return url;
  }

  Future<void> addTeamToDb(
    UserModel currentUser,
    String teamName,
    List<String> department,
    int color,
  ) async {
    team = Team(
      uid: teamId,
      teamName: teamName,
      teamProfilePhoto:
          'https://firebasestorage.googleapis.com/v0/b/socialnetwork-cbb55.appspot.com/o/team_no-image.png?alt=media&token=aa43c6f9-3bd2-4647-b7f5-68824a943630',
      currentUserUid: currentUser.uid,
      teamOwnerEmail: currentUser.email,
      teamOwnerName: currentUser.displayName,
      teamOwnerPhotoUrl: currentUser.photoUrl,
    );

    await _firestore.collection('teams').doc(teamId).set(team.toMap(team));

    var member = Member(
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        ownerPhotoUrl: currentUser.photoUrl,
        accountType: 'Supervisor',
        timestamp: FieldValue.serverTimestamp());
    await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('members')
        .doc(currentUser.uid)
        .set(member.toMap(member));
    team = Team(
      uid: teamId,
      teamName: teamName,
      teamProfilePhoto:
          'https://firebasestorage.googleapis.com/v0/b/socialnetwork-cbb55.appspot.com/o/team_no-image.png?alt=media&token=aa43c6f9-3bd2-4647-b7f5-68824a943630',
    );
    await _firestore.collection('teams').doc(teamId).update({
      'members': FieldValue.arrayUnion([currentUser.uid])
    });

    String dId = Uuid().v4();
    for (var i = 0; i < department.length; i++) {
      departments = Department(
        departmentOwnerName: '',
        departmentOwnerEmail: '',
        departmentOwnerPhotoUrl: '',
        description: '',
        departmentProfilePhoto: 59251,
        color: color,
        uid: dId,
        departmentName: department[i],
      );
      await _firestore
          .collection('teams')
          .doc(teamId)
          .collection('departments')
          .doc(dId)
          .set(departments.toMap(departments))
          .then((value) {
        dId = Uuid().v4();
      });
    }
  }

  Future<void> addGroupToDb(
    UserModel currentUser,
    String groupName,
    String description,
    String location,
    String agenda,
    bool isPrivate,
    bool isHidden,
    List<String> rules,
  ) async {
    group = Group(
      uid: groupId,
      groupName: groupName,
      groupProfilePhoto:
          'https://firebasestorage.googleapis.com/v0/b/socialnetwork-cbb55.appspot.com/o/group_no-image.png?alt=media&token=7c646dd5-5ec4-467d-9639-09f97c6dc5f0',
      currentUserUid: currentUser.uid,
      groupOwnerEmail: currentUser.email,
      groupOwnerName: currentUser.displayName,
      groupOwnerPhotoUrl: currentUser.photoUrl,
      isPrivate: isPrivate,
      isHidden: isHidden,
      description: description,
      location: location,
      agenda: agenda,
      rules: rules,
      customRules: '',
    );

    await _firestore.collection('groups').doc(groupId).set(group.toMap(group));

    var member = Member(
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        ownerPhotoUrl: currentUser.photoUrl,
        accountType: 'admin',
        timestamp: FieldValue.serverTimestamp());
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .doc(currentUser.uid)
        .set(member.toMap(member));

    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([currentUser.uid])
    });
  }

  Future<void> addDepartmentToTeam(
      UserModel currentUser,
      String teamUid,
      String departmentUid,
      String departmentName,
      bool isPrivate,
      int img,
      int color) {
    departments = Department(
      uid: departmentUid,
      departmentName: departmentName,
      currentUserUid: currentUser.uid,
      departmentOwnerName: currentUser.displayName,
      departmentOwnerEmail: currentUser.email,
      departmentOwnerPhotoUrl: currentUser.photoUrl,
      departmentProfilePhoto: img,
      description: '',
      color: 4284513675,
    );

    return _firestore
        .collection('teams')
        .doc(teamUid)
        .collection('departments')
        .doc(departmentUid)
        .set(departments.toMap(departments))
        .then((val) {
      _firestore
          .collection('teams')
          .doc(teamUid)
          .collection('departments')
          .doc(departmentUid)
          .update({
        "members": FieldValue.arrayUnion([currentUser.uid])
      });
    });

    // var member = Member(
    //     ownerName: currentUser.displayName,
    //     ownerUid: currentUser.uid,
    //     ownerPhotoUrl: currentUser.photoUrl,
    //     accountType: 'Supervisor',
    //     timestamp: FieldValue.serverTimestamp());

    // await _firestore
    //     .collection('teams')
    //     .document(teamUid)
    //     .collection('members')
    //     .document(currentUser.uid)
    //     .setData(member.toMap(member));
  }

  Future<void> addProjectToDepartment(
    UserModel currentUser,
    String teamUid,
    String departmentUid,
    String projectName,
    bool isPrivate,
    int color,
    String pId,
  ) {
    project = Project(
      color: color,
      uid: pId,
      projectName: projectName,
      projectProfilePhoto: 59251,
      currentUserUid: currentUser.uid,
      projectOwnerEmail: currentUser.email,
      projectOwnerName: currentUser.displayName,
      projectOwnerPhotoUrl: currentUser.photoUrl,
      isPrivate: isPrivate,
      timestamp: FieldValue.serverTimestamp(),
    );

    return _firestore
        .collection('teams')
        .doc(teamUid)
        .collection('departments')
        .doc(departmentUid)
        .collection('projects')
        .doc(pId)
        .set(project.toMap(project))
        .then((value) {
      addListToProject(
          '1', currentUser, 'To Do', teamUid, departmentUid, pId, 4284513675);
      addListToProject('2', currentUser, 'In Progress', teamUid, departmentUid,
          pId, 4278238420);
      addListToProject('3', currentUser, 'Completed', teamUid, departmentUid,
          pId, 4278228616);
      addTaskToList('1', currentUser, 'Meeting with the Team', '', teamUid,
          departmentUid, pId, '1');
      addTaskToList('2', currentUser, 'Call with Technician', '', teamUid,
          departmentUid, pId, '2');
      addTaskToList('3', currentUser, 'Submit the Project report', '', teamUid,
          departmentUid, pId, '3');
    });

    // var member = Member(
    //     ownerName: currentUser.displayName,
    //     ownerUid: currentUser.uid,
    //     ownerPhotoUrl: currentUser.photoUrl,
    //     accountType: 'Manager',
    //     timestamp: FieldValue.serverTimestamp());

    // await _firestore
    //     .collection('teams')
    //     .document(teamUid)
    //     .collection('departments')
    //     .document(departmentUid)
    //     .collection('projects')
    //     .document(pId)
    //     .collection('members')
    //     .document(currentUser.uid)
    //     .setData(member.toMap(member));
  }

  Future<void> addListToProject(
    String currentListId,
    UserModel currentUser,
    String listName,
    String currentTeamId,
    String currentDeptId,
    currentProjectId,
    int color,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .doc(currentTeamId)
        .collection('departments')
        .doc(currentDeptId)
        .collection('projects')
        .doc(currentProjectId)
        .collection('list');

    var taskList = TaskList(
      listId: currentListId,
      ownerUid: currentUser.uid,
      listName: listName,
      ownerName: currentUser.displayName,
      ownerPhotoUrl: currentUser.photoUrl,
      color: color,
      timestamp: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(currentListId).set(taskList.toMap(taskList));
  }

  Future<void> addTaskToList(
      String newTaskId,
      UserModel currentUser,
      String taskName,
      String taskDescription,
      String currentTeamId,
      String currentDeptId,
      String currentProjectId,
      String currentListId) async {
    var task = TaskModel(
      taskId: newTaskId,
      ownerUid: currentUser.uid,
      taskName: taskName,
      description: taskDescription,
      ownerName: currentUser.displayName,
      ownerPhotoUrl: currentUser.photoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    await _firestore
        .collection('teams')
        .doc(currentTeamId)
        .collection('departments')
        .doc(currentDeptId)
        .collection('projects')
        .doc(currentProjectId)
        .collection('list')
        .doc(currentListId)
        .collection('tasks')
        .doc(newTaskId)
        .set(task.toMap(task));

    task = TaskModel(
      taskId: newTaskId,
      ownerUid: currentUser.uid,
      taskName: taskName,
      ownerName: currentUser.displayName,
      ownerPhotoUrl: currentUser.photoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    await _firestore
        .collection('teams')
        .doc(currentTeamId)
        .collection('departments')
        .doc(currentDeptId)
        .collection('projects')
        .doc(currentProjectId)
        .collection('incomplete')
        .doc(newTaskId)
        .set(task.toMap(task));
  }

  Future<void> addPostToDb(
      UserModel currentUser, String imgUrl, String caption, String location) {
    CollectionReference _collectionRef =
        _firestore.collection('users').doc(currentUser.uid).collection('posts');

    post = Post(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      location: location,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(post.toMap(post));
  }

  Future<void> addDiscussionToDb(
    UserModel currentUser,
    String caption,
  ) {
    CollectionReference _collectionRef =
        _firestore.collection('users').doc(currentUser.uid).collection('posts');

    discussion = Discussion(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(discussion.toMap(discussion));
  }

  Future<void> addPostToForum(String currentGroupId, UserModel currentUser,
      String imgUrl, String caption, String location) {
    CollectionReference _collectionRef =
        _firestore.collection('groups').doc(currentGroupId).collection('posts');

    post = Post(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      location: location,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(post.toMap(post));
  }

  Future<void> addApprovedPostToForum(
    String currentGroupId,
    String currentPostId,
    String ownerUid,
    String imgUrl,
    String caption,
    String location,
    String ownerName,
    String ownerPhotoUrl,
    String postType,
  ) {
    CollectionReference _collectionRef =
        _firestore.collection('groups').doc(currentGroupId).collection('posts');

    post = Post(
      postId: currentPostId,
      currentUserUid: ownerUid,
      imgUrl: imgUrl,
      caption: caption,
      location: location,
      postOwnerName: ownerName,
      postOwnerPhotoUrl: ownerPhotoUrl,
      postType: postType,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(currentPostId).set(post.toMap(post));
  }

  Future<void> addApprovedPollToForum(
    String currentGroupId,
    String currentPostId,
    String ownerUid,
    String caption,
    String option1,
    String option2,
    String option3,
    String option4,
    String postType,
    String ownerName,
    String ownerPhotoUrl,
  ) {
    CollectionReference _collectionRef =
        _firestore.collection('groups').doc(currentGroupId).collection('posts');

    poll = Poll(
      postId: currentPostId,
      currentUserUid: ownerUid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      postType: postType,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      postOwnerName: ownerName,
      postOwnerPhotoUrl: ownerPhotoUrl,
    );
    return _collectionRef.doc(currentPostId).set(poll.toMap(poll));
  }

  Future<void> addPostToReview(
    String currentGroupId,
    UserModel currentUser,
    String imgUrl,
    String caption,
    String location,
    String postType,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('reviews');

    post = Post(
        postId: postId,
        currentUserUid: currentUser.uid,
        imgUrl: imgUrl,
        caption: caption,
        location: location,
        postOwnerName: currentUser.displayName,
        postOwnerPhotoUrl: currentUser.photoUrl,
        time: FieldValue.serverTimestamp(),
        postType: postType);
    return _collectionRef.doc(postId).set(post.toMap(post));
  }

  Future<void> addAdToForum(
    String currentGroupId,
    UserModel currentUser,
    List<String> imgUrls,
    String caption,
    String description,
    String price,
    String condition,
    String city,
    String location,
    String category,
    GeoPoint geoPoint,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('marketplace');

    ad = Ad(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrls: imgUrls,
      caption: caption,
      description: description,
      price: price,
      condition: condition,
      city: city,
      location: location,
      category: category,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      geopoint: geoPoint,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(ad.toMap(ad));
  }

  Future<void> addAdToReview(
    String currentGroupId,
    UserModel currentUser,
    String imgUrl,
    String caption,
    String description,
    String price,
    String condition,
    String location,
    String postType,
    String category,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('reviews');

    ad = Ad(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      description: description,
      price: price,
      condition: condition,
      location: location,
      category: category,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      postType: postType,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(ad.toMap(ad));
  }

  Future<void> addApprovedAdToForum(
      String currentGroupId,
      String currentPostId,
      String ownerUid,
      String imgUrl,
      String caption,
      String description,
      String price,
      String condition,
      String location,
      String ownerName,
      String ownerPhotoUrl,
      String postType) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('marketplace');

    ad = Ad(
      postId: currentPostId,
      currentUserUid: ownerUid,
      imgUrl: imgUrl,
      caption: caption,
      description: description,
      price: price,
      condition: condition,
      location: location,
      postOwnerName: ownerName,
      postOwnerPhotoUrl: ownerPhotoUrl,
      time: FieldValue.serverTimestamp(),
      postType: postType,
    );
    return _collectionRef.doc(currentPostId).set(ad.toMap(ad));
  }

  Future<void> addDiscussionToForum(
    String currentGroupId,
    UserModel currentUser,
    String caption,
  ) {
    CollectionReference _collectionRef =
        _firestore.collection('groups').doc(currentGroupId).collection('posts');

    discussion = Discussion(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(discussion.toMap(discussion));
  }

  Future<void> addDiscussionToProject(
    String currentTeamId,
    String currentDeptId,
    String currentProjectId,
    UserModel currentUser,
    String caption,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .doc(currentTeamId)
        .collection('departments')
        .doc(currentDeptId)
        .collection('projects')
        .doc(currentProjectId)
        .collection('discussions');

    discussion = Discussion(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(discussion.toMap(discussion));
  }

  Future<void> addDiscussionToDept(
    String currentTeamId,
    String currentDeptId,
    UserModel currentUser,
    String caption,
    String discussId,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .doc(currentTeamId)
        .collection('departments')
        .doc(currentDeptId)
        .collection('discussions');

    discussion = Discussion(
      postId: discussId,
      currentUserUid: currentUser.uid,
      caption: caption,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(discussId).set(discussion.toMap(discussion));
  }

  Future<void> addDiscussionToReview(
    String currentGroupId,
    UserModel currentUser,
    String caption,
    String postType,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('reviews');

    discussion = Discussion(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
      postType: postType,
    );
    return _collectionRef.doc(postId).set(discussion.toMap(discussion));
  }

  Future<void> addPollToDept(
    String currentTeamId,
    String currentDeptId,
    UserModel currentUser,
    String caption,
    int pollLength,
    String postType,
    String option1,
    String option2,
    String option3,
    String option4,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .doc(currentTeamId)
        .collection('departments')
        .doc(currentDeptId)
        .collection('discussions');

    poll = Poll(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      postType: postType,
      pollLength: pollLength,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
    );
    return _collectionRef.doc(postId).set(poll.toMap(poll));
  }

  Future<void> addPollToProject(
    String currentTeamId,
    String currentDeptId,
    String currentProjectId,
    UserModel currentUser,
    String caption,
    int pollLength,
    String postType,
    String option1,
    String option2,
    String option3,
    String option4,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .doc(currentTeamId)
        .collection('departments')
        .doc(currentDeptId)
        .collection('projects')
        .doc(currentProjectId)
        .collection('discussions');

    poll = Poll(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      postType: postType,
      pollLength: pollLength,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
    );
    return _collectionRef.doc(postId).set(poll.toMap(poll));
  }

  Future<void> addPollToForum(
    String currentGroupId,
    UserModel currentUser,
    String caption,
    int pollLength,
    String postType,
    String option1,
    String option2,
    String option3,
    String option4,
  ) {
    CollectionReference _collectionRef =
        _firestore.collection('groups').doc(currentGroupId).collection('posts');

    poll = Poll(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      postType: postType,
      pollLength: pollLength,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
    );
    return _collectionRef.doc(postId).set(poll.toMap(poll));
  }

  Future<void> addPollToReview(
    String currentGroupId,
    UserModel currentUser,
    String caption,
    String postType,
    int pollLength,
    String option1,
    String option2,
    String option3,
    String option4,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('reviews');

    poll = Poll(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      postType: postType,
      pollLength: pollLength,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
    );
    return _collectionRef.doc(postId).set(poll.toMap(poll));
  }

  Future<void> addOfflineEventToDb(
    UserModel currentUser,
    String imgUrl,
    String caption,
    String city,
    String venue,
    String host,
    String description,
    String category,
    int startDate,
    int endDate,
    int startTime,
    int endTime,
    String ticketWebsite,
    GeoPoint geoPoint,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('events');

    event = Event(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      city: city,
      venue: venue,
      eventOwnerName: currentUser.displayName,
      eventOwnerPhotoUrl: currentUser.photoUrl,
      description: description,
      category: category,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      host: host,
      ticketWebsite: ticketWebsite,
      geopoint: geoPoint,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(event.toMap(event));
  }

  Future<void> addOnlineEventToDb(
    UserModel currentUser,
    String imgUrl,
    String caption,
    String host,
    String website,
    String description,
    String category,
    int startDate,
    int endDate,
    int startTime,
    int endTime,
    String ticketWebsite,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('events');

    event = Event(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      eventOwnerName: currentUser.displayName,
      eventOwnerPhotoUrl: currentUser.photoUrl,
      website: website,
      description: description,
      category: category,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      host: host,
      ticketWebsite: ticketWebsite,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(event.toMap(event));
  }

  Future<void> addOfflineEventToForum(
    String currentGroupId,
    UserModel currentUser,
    String imgUrl,
    String caption,
    String city,
    String venue,
    String host,
    String description,
    String category,
    int startDate,
    int endDate,
    int startTime,
    int endTime,
    String ticketWebsite,
    GeoPoint geoPoint,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('events');

    event = Event(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      city: city,
      venue: venue,
      eventOwnerName: currentUser.displayName,
      eventOwnerPhotoUrl: currentUser.photoUrl,
      description: description,
      category: category,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      host: host,
      ticketWebsite: ticketWebsite,
      geopoint: geoPoint,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(event.toMap(event));
  }

  Future<void> addOnlineEventToForum(
    String currentGroupId,
    UserModel currentUser,
    String imgUrl,
    String caption,
    String host,
    String website,
    String description,
    String category,
    int startDate,
    int endDate,
    int startTime,
    int endTime,
    String ticketWebsite,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('events');

    event = Event(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      eventOwnerName: currentUser.displayName,
      eventOwnerPhotoUrl: currentUser.photoUrl,
      website: website,
      description: description,
      category: category,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      host: host,
      ticketWebsite: ticketWebsite,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(event.toMap(event));
  }

  Future<void> addNewsToDb(
      UserModel currentUser, String imgUrl, String caption, String source) {
    CollectionReference _collectionRef =
        _firestore.collection('users').doc(currentUser.uid).collection('news');

    news = News(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      source: source,
      newsOwnerName: currentUser.displayName,
      newsOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(news.toMap(news));
  }

  Future<void> addJobPostToDb(
    UserModel currentUser,
    String caption,
    String location,
    String industry,
    String description,
    String website,
  ) {
    CollectionReference _collectionRef =
        _firestore.collection('users').doc(currentUser.uid).collection('jobs');

    job = Job(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      location: location,
      jobOwnerName: currentUser.displayName,
      jobOwnerPhotoUrl: currentUser.photoUrl,
      industry: industry,
      description: description,
      website: website,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(job.toMap(job));
  }

  Future<void> addPromotionToDb(
      UserModel currentUser,
      String caption,
      String location,
      String portfolio,
//String timing,
      // String category,
      String description,
      // String locations,
      List<dynamic> skills,
      List<dynamic> experience,
      List<dynamic> education) {
    CollectionReference _collectionRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('promotion');

    promotion = Promotion(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      location: location,
      promotionOwnerName: currentUser.displayName,
      promotionOwnerPhotoUrl: currentUser.photoUrl,
      portfolio: portfolio,
      //   timing: timing,
      //   category: category,
      description: description,
      //   locations: locations,
      skills: skills,
      experience: experience,
      education: education,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.doc(postId).set(promotion.toMap(promotion));
  }

  Future<UserModel> retrieveUserDetails(User user) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection('users').doc(user.uid).get();
    return UserModel.fromMap(_documentSnapshot.data());
  }

  Future<Group> retrieveGroupDetails(String group) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection('groups').doc(group).get();
    return Group.fromMap(_documentSnapshot.data());
  }

  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('posts')
        .orderBy('time', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserGroups(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('groups')
        .orderBy('time', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveGroupsPosts(String groupId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('posts')
        .orderBy('time', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveTeamTasks(
    String teamTid,
    String deptTid,
    String projectTid,
    String listTid,
  ) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('teams')
        .doc(teamTid)
        .collection('departments')
        .doc(deptTid)
        .collection('projects')
        .doc(projectTid)
        .collection('list')
        .doc(listTid)
        .collection('tasks')
        //.orderBy('time', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserJobs(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('jobs')
        .orderBy('time', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserEvents(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .orderBy('time', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserNews(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('news')
        .orderBy('time', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserApplications(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('promotion')
        .orderBy('time', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserFollowers(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('followers')
        .orderBy('ownerName')
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserFollowing(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('following')
        .orderBy('ownerName')
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserChatRooms(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('chatRoom')
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> retrieveUserLikeFeed(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('items')
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchPostCommentDetails(
      DocumentReference reference) async {
    QuerySnapshot snapshot = await reference.collection('comments').get();
    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchPostLikeDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("likes").get();
    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchTotalVotesDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("votes").get();
    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchPerOptionVotesDetails(
      DocumentReference reference, String label) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection(label).get();
    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchActivityFeedDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("feedItems").get();
    return snapshot.docs;
  }

  Future<bool> checkIfUserLikedOrNot(
      String userId, DocumentReference reference) async {
    DocumentSnapshot snapshot =
        await reference.collection('likes').doc(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<bool> checkIfUserVotedOrNot(
      String userId, DocumentReference reference, String label) async {
    DocumentSnapshot snapshot =
        await reference.collection(label).doc(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<List<DocumentSnapshot>> retrievePosts(User user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('posts')
          .orderBy('time', descending: true)
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED LIST LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveGroupPosts(User group) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore
        .collection('groups')
        .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('posts')
          .orderBy('time', descending: true)
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED LIST LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveGroupSuggestions(User user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore
        .collection('groups')
        // .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('posts')
          .orderBy('time', descending: true)
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED LIST LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveFeeds(User user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i].reference.collection('feedItems').get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('Feed LIST LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveEvents(User user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('events')
          .orderBy('time', descending: true)
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED Event LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveNews(User user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('news')
          .orderBy('time', descending: true)
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED News LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveJobs(User user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('jobs')
          .orderBy('time', descending: true)
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED Jobs LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrievePromotion(User user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('promotion')
          .orderBy('time', descending: true)
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED Promotion LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveFollowers(User user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != user.uid) {
        list.add(snapshot.docs[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('following')
          .orderBy('ownerName')
          .get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        updatedList.add(querySnapshot.docs[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED following LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<String>> fetchAllUserNames(User user) async {
    List<String> userNameList = List<String>();
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userNameList.add(querySnapshot.docs[i]['displayName']);
      }
    }
    print('USERNAME LIST : ${userNameList.length}');
    return userNameList;
  }

  Future<String> fetchUidBySearchedName(String name) async {
    String uid;
    List<DocumentSnapshot> uidList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      uidList.add(querySnapshot.docs[i]);
    }
    print('UID LIST : ${uidList.length}');
    for (var i = 0; i < uidList.length; i++) {
      if (uidList[i]['uid'] == name) {
        uid = uidList[i].id;
      }
    }
    print('UID DOC ID : $uid');
    return uid;
  }

  Future<UserModel> fetchUserDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(uid).get();
    return UserModel.fromMap(documentSnapshot.data());
  }

  Future<Group> fetchGroupDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('groups').doc(uid).get();
    return Group.fromMap(documentSnapshot.data());
  }

  Future<Team> fetchTeamDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('teams').doc(uid).get();
    return Team.fromMap(documentSnapshot.data());
  }

  Future<Department> fetchDepartmentDetailsById(
      String uid, String departmentUid) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('teams')
        .doc(uid)
        .collection('departments')
        .doc(departmentUid)
        .get();
    return Department.fromMap(documentSnapshot.data());
  }

  Future<Project> fetchProjectDetailsById(
      String uid, String departmentUid, String projectId) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('teams')
        .doc(uid)
        .collection('departments')
        .doc(departmentUid)
        .collection('projects')
        .doc(projectId)
        .get();
    return Project.fromMap(documentSnapshot.data());
  }

  Future<Project> fetchListDetailsById(String uid, String departmentUid,
      String projectId, String listUid) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('teams')
        .doc(uid)
        .collection('departments')
        .doc(departmentUid)
        .collection('projects')
        .doc(projectId)
        .collection('list')
        .doc(listUid)
        .get();
    return Project.fromMap(documentSnapshot.data());
  }

  Future<UserModel> fetchPostDetailsById(String uid, String postId) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('posts')
        .doc(postId)
        .get();
    return UserModel.fromMap(documentSnapshot.data());
  }

  Future<void> followUser(
      {String currentUserId,
      String followingUserId,
      UserModel followingUser,
      UserModel currentUser}) async {
    following = Following(
        ownerUid: followingUser.uid,
        ownerName: followingUser.displayName,
        ownerPhotoUrl: followingUser.photoUrl,
        accountType: followingUser.accountType,
        timestamp: FieldValue.serverTimestamp());

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('followers')
        .doc(followingUser.uid)
        .set(following.toMap(following));

    follower = Follower(
        ownerUid: currentUserId,
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        accountType: currentUser.accountType,
        timestamp: FieldValue.serverTimestamp());

    return _firestore
        .collection('users')
        .doc(followingUser.uid)
        .collection('following')
        .doc(currentUserId)
        .set(follower.toMap(follower));
  }

  Future<void> addChatRoom(
      {
      //String currentUserId,
      // String followingUserId,
      UserModel followingUser,
      UserModel currentUser}) async {
    _chatRoom = ChatRoom(
        ownerUid: followingUser.uid,
        ownerName: followingUser.displayName,
        ownerPhotoUrl: followingUser.photoUrl,
        timestamp: FieldValue.serverTimestamp());

    await _firestore
        .collection('messages')
        .doc(currentUser.uid)
        .collection('chatRoom')
        .doc(followingUser.uid)
        .set(_chatRoom.toMap(_chatRoom));

    _chatRoom = ChatRoom(
        ownerUid: currentUser.uid,
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        timestamp: FieldValue.serverTimestamp());

    return _firestore
        .collection('messages')
        .doc(followingUser.uid)
        .collection('chatRoom')
        .doc(currentUser.uid)
        .set(_chatRoom.toMap(_chatRoom));
  }

  Future<void> unFollowUser(
      {String currentUserId,
      String followingUserId,
      UserModel followingUser,
      UserModel currentUser}) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('followers')
        .doc(followingUser.uid)
        .delete();

    return _firestore
        .collection('users')
        .doc(followingUser.uid)
        .collection('following')
        .doc(currentUserId)
        .delete();
  }

  Future<void> inviteUser({
    String currentGroupId,
    String followingUserId,
  }) async {
    invite = Invite(
      ownerUid: followingUserId,
      timestamp: FieldValue.serverTimestamp(),
    );

    return _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('invites')
        .doc(followingUserId)
        .set(invite.toMap(invite));
  }

  Future<void> addTeamMember(
      {Team currentTeam,
      String followerId,
      String followerAccountType,
      String followerName,
      String followerPhotoUrl}) async {
    var member = Member(
      ownerUid: followerId,
      ownerName: followerName,
      accountType: followerAccountType,
      ownerPhotoUrl: followerPhotoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    await _firestore
        .collection('teams')
        .doc(currentTeam.uid)
        .collection('members')
        .doc(followerId)
        .set(member.toMap(member));

    await _firestore.collection('teams').doc(currentTeam.uid).update({
      'members': FieldValue.arrayUnion([followerId])
    });
  }

  Future<void> addDeptMember(
      {Team currentTeam,
      String currentDeptId,
      String followerId,
      String followerAccountType,
      String followerName,
      String followerPhotoUrl}) {
    var member = Member(
      ownerUid: followerId,
      ownerName: followerName,
      accountType: followerAccountType,
      ownerPhotoUrl: followerPhotoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    // await _firestore
    //       .collection('teams')
    //       .document(currentTeam.uid)
    //       .collection('departments')
    //       .document(currentDeptId)
    //       .updateData({
    //        "members" : [followerId]
    //       });
    return _firestore
        .collection('teams')
        .doc(currentTeam.uid)
        .collection('departments')
        .doc(currentDeptId)
        .collection('members')
        .doc(followerId)
        .set(member.toMap(member))
        .then((val) {
      _firestore
          .collection('teams')
          .doc(currentTeam.uid)
          .collection('departments')
          .doc(currentDeptId)
          .update({
        "members": FieldValue.arrayUnion([followerId])
      });
    });

    // var team = Team(
    //     uid: currentTeam.uid,
    //     teamName: currentTeam.teamName,
    //     teamProfilePhoto: currentTeam.teamProfilePhoto);
    // return _firestore
    //     .collection('users')
    //     .document(followerId)
    //     .collection('teams')
    //     .document(currentTeam.uid)
    //     .setData(team.toMap(team));
  }

  Future<void> addProjectMember(
      {Team currentTeam,
      String currentDeptId,
      String currentProjectId,
      String followerId,
      String followerAccountType,
      String followerName,
      String followerPhotoUrl}) {
    var member = Member(
      ownerUid: followerId,
      ownerName: followerName,
      accountType: followerAccountType,
      ownerPhotoUrl: followerPhotoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    return _firestore
        .collection('teams')
        .doc(currentTeam.uid)
        .collection('departments')
        .doc(currentDeptId)
        .collection('projects')
        .doc(currentProjectId)
        .collection('members')
        .doc(followerId)
        .set(member.toMap(member))
        .then((val) {
      _firestore
          .collection('teams')
          .doc(currentTeam.uid)
          .collection('departments')
          .doc(currentDeptId)
          .collection('projects')
          .doc(currentProjectId)
          .update({
        "members": FieldValue.arrayUnion([followerId])
      });
    });

    // var team = Team(
    //     uid: currentTeam.uid,
    //     teamName: currentTeam.teamName,
    //     teamProfilePhoto: currentTeam.teamProfilePhoto);
    // return _firestore
    //     .collection('users')
    //     .document(followerId)
    //     .collection('teams')
    //     .document(currentTeam.uid)
    //     .setData(team.toMap(team));
  }

  Future<void> addProjectAdmin({
    Team currentTeam,
    String currentDeptId,
    String currentProjectId,
    int currentProjectColor,
    String currentProjectName,
    int currentProjectProfile,
    String currentProjectDesc,
    String followerId,
    String followerAccountType,
    String followerName,
    String followerPhotoUrl,
    FieldValue projectTimestamp,
  }) async {
    var project = Project(
        uid: currentDeptId,
        color: currentProjectColor,
        projectName: currentProjectName,
        projectProfilePhoto: currentProjectProfile,
        description: currentProjectDesc,
        currentUserUid: followerId,
        projectOwnerName: followerName,
        projectOwnerEmail: '',
        projectOwnerPhotoUrl: followerPhotoUrl,
        timestamp: projectTimestamp);

    await _firestore
        .collection('teams')
        .doc(currentTeam.uid)
        .collection('departments')
        .doc(currentDeptId)
        .collection('projects')
        .doc(currentProjectId)
        .update(project.toMap(project));

    var member = Member(
      ownerUid: followerId,
      ownerName: followerName,
      accountType: followerAccountType,
      ownerPhotoUrl: followerPhotoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    return _firestore
        .collection('teams')
        .doc(currentTeam.uid)
        .collection('departments')
        .doc(currentDeptId)
        .collection('projects')
        .doc(currentProjectId)
        .collection('members')
        .doc(followerId)
        .set(member.toMap(member))
        .then((val) {
      _firestore
          .collection('teams')
          .doc(currentTeam.uid)
          .collection('departments')
          .doc(currentDeptId)
          .collection('projects')
          .doc(currentProjectId)
          .update({
        "members": FieldValue.arrayUnion([followerId])
      });
    });

    // var team = Team(
    //   uid: currentTeam.uid,
    //   teamName: currentTeam.teamName,
    //   teamProfilePhoto: currentTeam.teamProfilePhoto,
    // );
    // return _firestore
    //     .collection('users')
    //     .document(followerId)
    //     .collection('teams')
    //     .document(currentTeam.uid)
    //     .setData(team.toMap(team));
  }

  Future<void> addDeptAdmin(
      {Team currentTeam,
      String currentDeptId,
      int currentDeptColor,
      String currentDeptName,
      int currentDeptProfile,
      String currentDeptDesc,
      String followerId,
      String followerAccountType,
      String followerName,
      String followerPhotoUrl}) async {
    var dept = Department(
        uid: currentDeptId,
        color: currentDeptColor,
        departmentName: currentDeptName,
        departmentProfilePhoto: currentDeptProfile,
        description: currentDeptDesc,
        currentUserUid: followerId,
        departmentOwnerName: followerName,
        departmentOwnerEmail: '',
        departmentOwnerPhotoUrl: followerPhotoUrl);

    await _firestore
        .collection('teams')
        .doc(currentTeam.uid)
        .collection('departments')
        .doc(currentDeptId)
        .update(dept.toMap(dept));

    var member = Member(
      ownerUid: followerId,
      ownerName: followerName,
      accountType: followerAccountType,
      ownerPhotoUrl: followerPhotoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    return _firestore
        .collection('teams')
        .doc(currentTeam.uid)
        .collection('departments')
        .doc(currentDeptId)
        .collection('members')
        .doc(followerId)
        .set(member.toMap(member))
        .then((val) {
      _firestore
          .collection('teams')
          .doc(currentTeam.uid)
          .collection('departments')
          .doc(currentDeptId)
          .update({
        "members": FieldValue.arrayUnion([followerId])
      });
    });

    // var team = Team(
    //   uid: currentTeam.uid,
    //   teamName: currentTeam.teamName,
    //   teamProfilePhoto: currentTeam.teamProfilePhoto,
    // );
    // return _firestore
    //     .collection('users')
    //     .document(followerId)
    //     .collection('teams')
    //     .document(currentTeam.uid)
    //     .setData(team.toMap(team));
  }

  Future<void> deleteInvite({
    String currentGroupId,
    String followingUserId,
  }) async {
    return _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('invites')
        .doc(followingUserId)
        .delete();
  }

  Future<bool> checkIsFollowing(String name, String currentUserId) async {
    bool isFollowing = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == uid) {
        isFollowing = true;
      }
    }
    return isFollowing;
  }

  Future<bool> checkIsRequested(String name, String currentUserId) async {
    bool isRequested = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('requests')
        // .where('type', isEqualTo: 'request')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == uid) {
        isRequested = true;
      }
    }
    return isRequested;
  }

  Future<bool> checkIsRequestedGroup(String name, String currentGroupId) async {
    bool isRequested = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('requests')
        // .where('type', isEqualTo: 'request')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == uid) {
        isRequested = true;
      }
    }
    return isRequested;
  }

  Future<bool> checkIsInvited(String name, String currentUserId) async {
    bool isInvited = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('invites')
        // .where('type', isEqualTo: 'request')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == uid) {
        isInvited = true;
      }
    }
    return isInvited;
  }

  Future<bool> checkIsHidden(String name, String currentUserId) async {
    bool isHidden = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('items')
        // .where('type', isEqualTo: 'request')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == uid) {
        isHidden = true;
      }
    }
    return isHidden;
  }

  Future<bool> checkIsMember(String name, String currentGroupId) async {
    bool isMember = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        .doc(currentGroupId)
        .collection('members')
        // .where('type', isEqualTo: 'request')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == uid) {
        isMember = true;
      }
    }
    return isMember;
  }

  Future<bool> checkDepartmentMember(
      String name, String currentTeamId, String currentDeptId) async {
    bool isMember = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection('teams')
        .doc(currentTeamId)
        .collection('departments')
        .doc(currentDeptId)
        .collection('members')
        // .where('type', isEqualTo: 'request')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id == uid) {
        isMember = true;
      }
    }
    return isMember;
  }

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('users').doc(uid).collection(label).get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchVotes(
      {String gid, String postId, String label}) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        .doc(gid)
        .collection('posts')
        .doc(postId)
        .collection(label)
        .get();
    return querySnapshot.docs;
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = Map();
    map['groupProfilePhoto'] = photoUrl;
    return _firestore.collection('groups').doc(uid).update(map);
  }

  Future<void> updateDetails(String uid, String name, String bio, String email,
      String phone, String website, String location) async {
    Map<String, dynamic> map = Map();
    map['displayName'] = name;
    map['bio'] = bio;
    map['email'] = email;
    map['phone'] = phone;
    map['website'] = website;
    map['location'] = location;
    return _firestore.collection('users').doc(uid).update(map);
  }

  Future<void> updateEducationDetails(
      String uid,
      String university,
      String stream,
      int startDate,
      int endDate,
      String cert1,
      String cert2,
      String cert3) async {
    Map<String, dynamic> map = Map();
    map['university'] = university;
    map['stream'] = stream;
    map['startUniversity'] = startDate;
    map['endUniversity'] = endDate;
    map['cet1'] = cert1;
    map['cet2'] = cert2;
    map['cet3'] = cert3;
    return _firestore.collection('users').doc(uid).update(map);
  }

  Future<void> updateExperienceDetails(
    String uid,
    String company1,
    String designationCompany1,
    int startDateCompany1,
    int endDateCompany1,
    String company2,
    String designationCompany2,
    int startDateCompany2,
    int endDateCompany2,
    String company3,
    String designationCompany3,
    int startDateCompany3,
    int endDateCompany3,
  ) async {
    Map<String, dynamic> map = Map();
    map['experience']['id'] = 0;
    map['experience']['company'] = company1;
    map['experience']['designation'] = designationCompany1;
    map['experience']['startCompany'] = startDateCompany1;
    map['experience']['endCompany'] = endDateCompany1;
    map['experience']['id'] = 1;
    map['experience']['company'] = company1;
    map['experience']['designation'] = designationCompany1;
    map['experience']['startCompany'] = startDateCompany1;
    map['experience']['endCompany'] = endDateCompany1;
    map['experience']['id'] = 2;
    map['experience']['company'] = company1;
    map['experience']['designation'] = designationCompany1;
    map['experience']['startCompany'] = startDateCompany1;
    map['experience']['endCompany'] = endDateCompany1;
    return _firestore.collection('users').doc(uid).update(map);
  }

  Future<void> updateSchool(String uid, String school) async {
    Map<String, dynamic> map = Map();
    map['school'] = school;
    return _firestore.collection('users').doc(uid).update(map);
  }

  Future<void> updateProducts(String uid, List<String> products) async {
    Map<String, dynamic> map = Map();
    map['products'] = products;
    return _firestore.collection('users').doc(uid).update(map);
  }

  Future<List<String>> fetchUserNames(User user) async {
    DocumentReference documentReference =
        _firestore.collection('messages').doc(user.uid);
    List<String> userNameList = List<String>();
    List<String> chatUsersList = List<String>();
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        print('USERNAMES : ${querySnapshot.docs[i].id}');
        userNameList.add(querySnapshot.docs[i].id);
        // querySnapshot.documents[
        //  i].reference.collection('collectionPath');
        //   userNameList.add(querySnapshot.documents[
        //  i].data['displayName']);
      }
    }
    for (var i = 0; i < userNameList.length; i++) {
      if (documentReference.collection(userNameList[i]) != null) {
        if (documentReference.collection(userNameList[i]).get() != null) {
          print("CHAT USERS : ${userNameList[i]}");
          chatUsersList.add(userNameList[i]);
        }
      }
    }
    print('CHAT USERS :${chatUsersList.length}');
    return chatUsersList;
    // print('USERNAMES LIST : ${userNameList.length');
    //return userNameList;
  }

  Future<List<UserModel>> fetchAllUsers(User user) async {
    List<UserModel> userList = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where(
          'accountType',
          whereIn: [
            'Professional',
            'Military',
            'Student',
            '',
          ],
        )
        .where('isHidden', isEqualTo: false)
        .orderBy('displayName')
        // .limit(20)
        //.orderBy('displayName')
        .get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('USERSLIST : ${userList.length}');
    return userList;
  }

  static Future<QuerySnapshot> getUsers(
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    final refUsers = FirebaseFirestore.instance
        .collection('users')
        .where(
          'accountType',
          whereIn: [
            'Professional',
            'Military',
            'Student',
            '',
          ],
        )
        .where('isHidden', isEqualTo: false)
        .orderBy('displayName')
        .limit(limit);
    if (startAfter == null) {
      return refUsers.get();
    } else {
      return refUsers.startAfterDocument(startAfter).get();
    }
  }

  Future<List<Member>> fetchAllProjectMembers(
      String teamUid, String deptUid, String projectUid) async {
    List<Member> userList;
    QuerySnapshot querySnapshot = await _firestore
        .collection('teams')
        .doc(teamUid)
        .collection('departments')
        .doc(deptUid)
        .collection('projects')
        .doc(projectUid)
        .collection('members')
        .get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      //  if (querySnapshot.documents[i].documentID != user.uid) {
      userList.add(Member.fromMap(querySnapshot.docs[i].data()));
      //userList.add(querySnapshot.doucments[i].data[User.fromMap(
      // mapData)]);
      // }
    }
    print('members : ${userList.length}');
    return userList;
  }

  Future<List<Group>> fetchAllGroups(User user) async {
    List<Group> groupList = List<Group>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        //   .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        groupList.add(Group.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('Grouplist : ${groupList.length}');
    return groupList;
  }

  Future<List<Team>> fetchMyTeams(User user) async {
    List<Team> myTeamList = List<Team>();
    QuerySnapshot querySnapshot = await _firestore.collection('teams')
        //   .where('isPrivate', isEqualTo: false)
        .where('members', arrayContainsAny: [user.uid]).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        myTeamList.add(Team.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('Teamlist : ${myTeamList.length}');
    return myTeamList;
  }

  Future<List<Group>> fetchMyGroups(User user) async {
    List<Group> myGroupList = List<Group>();
    QuerySnapshot querySnapshot = await _firestore.collection('groups')
        //   .where('isPrivate', isEqualTo: false)
        .where('members', arrayContainsAny: [user.uid]).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        myGroupList.add(Group.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('My Grouplist : ${myGroupList.length}');
    return myGroupList;
  }

  Future<List<Group>> fetchAllGroupSuggestions(User user) async {
    List<Group> groupList = List<Group>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        //   .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .limit(20)
        //.orderBy('displayName')
        .get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        groupList.add(Group.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('Grouplist : ${groupList.length}');
    return groupList;
  }

  Future<List<UserModel>> fetchAllCompanies(User user) async {
    List<UserModel> companyList = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('accountType', isEqualTo: 'Company')
        .get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        companyList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('USERSLIST : ${companyList.length}');
    return companyList;
  }

  void uploadImageMsgToDb(
    String url,
    String receiverUid,
    String senderuid,
    String senderPhoto,
    String senderName,
  ) {
    _message = Message.withoutMessage(
        receiverUid: receiverUid,
        senderUid: senderuid,
        photoUrl: url,
        senderPhoto: senderPhoto,
        senderName: senderName,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;
    map['senderPhoto'] = _message.senderPhoto;
    map['senderName'] = _message.senderName;

    print('Map : $map');
    _firestore
        .collection('messages')
        .doc(_message.senderUid)
        .collection('chatRoom')
        .doc(receiverUid)
        .collection('messages')
        .doc(msgId)
        .set(map)
        .whenComplete(() {
      print('Messages added to db');
      msgId = Uuid().v4();
    });

    _firestore
        .collection('messages')
        .doc(receiverUid)
        .collection('chatRoom')
        .doc(_message.senderUid)
        .collection('messages')
        .doc(msgId)
        .set(map)
        .whenComplete(() {
      print('Messages added to db');
      msgId = Uuid().v4();
    });
  }

  Future<void> addMessageToDb(
    Message message,
    String receiverUid,
  ) async {
    print('Message : ${message.message}');
    var map = message.toMap();

    print('Map : $map');
    await _firestore
        .collection('messages')
        .doc(message.senderUid)
        .collection('chatRoom')
        .doc(receiverUid)
        .collection('messages')
        .doc(msgId)
        .set(map);

    return _firestore
        .collection('messages')
        .doc(receiverUid)
        .collection('chatRoom')
        .doc(message.senderUid)
        .collection('messages')
        .doc(msgId)
        .set(map)
        .whenComplete(() {
      print('Messages added to db');
      msgId = Uuid().v4();
    });
    ;
  }

  void uploadImageMsgToGroup(
    String url,
    Group receiverGroup,
    String senderuid,
    String senderPhoto,
    String senderName,
  ) {
    _message = Message.withoutMessage(
        receiverUid: receiverGroup.uid,
        senderUid: senderuid,
        photoUrl: url,
        senderPhoto: senderPhoto,
        senderName: senderName,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;
    map['senderPhoto'] = _message.senderPhoto;
    map['senderName'] = _message.senderName;

    print('Map : $map');
    _firestore
        .collection('groups')
        .doc(receiverGroup.uid)
        .collection('messages')
        .doc(msgId)
        .set(map)
        .whenComplete(() {
      print('Messages added to db');
      msgId = Uuid().v4();
    });
  }

  Future<void> addMessageToGroup(
    Message message,
    Group receiverGroup,
  ) {
    print('Message : ${message.message}');
    var map = message.toMap();

    print('Map : $map');

    return _firestore
        .collection('groups')
        .doc(receiverGroup.uid)
        .collection('messages')
        .doc(msgId)
        .set(map)
        .whenComplete(() {
      msgId = Uuid().v4();
    });
  }

  Future<List<DocumentSnapshot>> fetchFeed(User user) async {
    List<String> followingUIDs = List<String>();
    List<DocumentSnapshot> list = List<DocumentSnapshot>();

    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('following')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      followingUIDs.add(querySnapshot.docs[i].id);
    }
    print("FOLLOWING UIDS : ${followingUIDs.length}");
    for (var i = 0; i < followingUIDs.length; i++) {
      print('SDDSSD : ${followingUIDs[i]}');

      //retreivePostByUID(followingUIDs[i]);
      // fetchUserDetailsById(followingUIDs[i]);

      QuerySnapshot postSnapshot = await _firestore
          .collection('users')
          .doc(followingUIDs[i])
          .collection('posts')
          .get();
      //postSnapshot.documents;
      for (var i = 0; i < postSnapshot.docs.length; i++) {
        print('dad : ${postSnapshot.docs[i].id}');
        list.add(postSnapshot.docs[i]);
        print('ads : ${list.length}');
      }
    }
    return list;
  }

  Future<List<String>> fetchFollowingUids(User user) async {
    List<String> followingUIDs = List<String>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('following')
        .get();

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      followingUIDs.add(querySnapshot.docs[i].id);
    }
    for (var i = 0; i < followingUIDs.length; i++) {
      print('DDDD : ${followingUIDs[i]}');
    }
    return followingUIDs;
  }

  Future<List<UserModel>> fetchFollowingUsers(User user) async {
    List<UserModel> userList = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('following')
        .get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
      //userList.add(querySnapshot.doucments[i].data[User.fromMap(
      // mapData)]);

    }
    print('USERSLIST : ${userList.length}');
    return userList;
  }

  Future<List<UserModel>> fetchFollowUsers(User user) async {
    List<UserModel> userList = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('followers')
        .get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('USERSLIST : ${userList.length}');
    return userList;
  }

  // getChatRooms(FirebaseUser user) async {
  //   return await _firestore
  //       .collection('messages')
  //       .document(user.uid)
  //       .snapshots();
  // }
}
