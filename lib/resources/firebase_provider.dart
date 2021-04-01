import 'dart:io';
import 'dart:async';
import 'dart:math';
//import 'package:Yujai/main.dart';
import 'package:Yujai/models/chatroom.dart';
import 'package:Yujai/models/comment.dart';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/discussion.dart';
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
  final Firestore _firestore = Firestore.instance;
  User user;
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
  StorageReference _storageReference;
  String postId = Uuid().v4();
  String groupId = Uuid().v4();
  String teamId = Uuid().v4();
  String departmentId = Uuid().v4();
  String projectId = Uuid().v4();
  String listId = Uuid().v4();
  String taskId = Uuid().v4();
  String msgId = Uuid().v4();

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    print('Inside addDataToDb Method');

    _firestore
        .collection('display_names')
        .document(currentUser.displayName)
        .setData({'displayName': currentUser.displayName});

    user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      displayName: currentUser.displayName,
      photoUrl: currentUser.photoUrl,
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
      school: '',
      startSchool: '',
      endSchool: '',
      college: '',
      startCollege: '',
      endCollege: '',
      university: '',
      startUniversity: '',
      endUniversity: '',
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
      certification1: '',
      certification2: '',
      certification3: '',
      company1: '',
      company2: '',
      company3: '',
      startCompany1: '',
      startCompany2: '',
      startCompany3: '',
      endCompany1: '',
      endCompany2: '',
      endCompany3: '',
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
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    print('Inside authenticateUser');
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;
    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    print('Email Id : ${currentUser.email}');
    return currentUser;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _signInAuthentication.idToken,
      accessToken: _signInAuthentication.accessToken,
    );

    final AuthResult user = await _auth.signInWithCredential(credential);
    return user.user;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<void> addTeamToDb(
    User currentUser,
    String teamName,
    List<String> department,
    int color,
  ) async {
    team = Team(
      uid: teamId,
      teamName: teamName,
      teamProfilePhoto: '',
      currentUserUid: currentUser.uid,
      teamOwnerEmail: currentUser.email,
      teamOwnerName: currentUser.displayName,
      teamOwnerPhotoUrl: currentUser.photoUrl,
    );

    await _firestore
        .collection('teams')
        .document(teamId)
        .setData(team.toMap(team));

    var member = Member(
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        ownerPhotoUrl: currentUser.photoUrl,
        accountType: 'Supervisor',
        timestamp: FieldValue.serverTimestamp());
    await _firestore
        .collection('teams')
        .document(teamId)
        .collection('members')
        .document(currentUser.uid)
        .setData(member.toMap(member));
    team = Team(
      uid: teamId,
      teamName: teamName,
      teamProfilePhoto: '',
    );
    await _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('teams')
        .document(teamId)
        .setData(team.toMap(team));

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
          .document(teamId)
          .collection('departments')
          .document(dId)
          .setData(departments.toMap(departments))
          .then((value) {
        dId = Uuid().v4();
      });
    }
  }

  Future<void> addGroupToDb(
    User currentUser,
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
      groupProfilePhoto: '',
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

    await _firestore
        .collection('groups')
        .document(groupId)
        .setData(group.toMap(group));

    var member = Member(
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        ownerPhotoUrl: currentUser.photoUrl,
        accountType: 'admin',
        timestamp: FieldValue.serverTimestamp());
    await _firestore
        .collection('groups')
        .document(groupId)
        .collection('members')
        .document(currentUser.uid)
        .setData(member.toMap(member));

    group = Group(
      uid: groupId,
      groupName: groupName,
      groupProfilePhoto: '',
      isPrivate: isPrivate,
    );
    return _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('groups')
        .document(groupId)
        .setData(group.toMap(group));
  }

  Future<void> addDepartmentToTeam(User currentUser, String teamUid,
      String departmentUid, String departmentName, bool isPrivate, int img) {
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
        .document(teamUid)
        .collection('departments')
        .document(departmentUid)
        .setData(departments.toMap(departments));

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
    User currentUser,
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
        .document(teamUid)
        .collection('departments')
        .document(departmentUid)
        .collection('projects')
        .document(pId)
        .setData(project.toMap(project));

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
    User currentUser,
    String listName,
    String currentTeamId,
    String currentDeptId,
    currentProjectId,
    int color,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .document(currentTeamId)
        .collection('departments')
        .document(currentDeptId)
        .collection('projects')
        .document(currentProjectId)
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
    return _collectionRef
        .document(currentListId)
        .setData(taskList.toMap(taskList));
  }

  Future<void> addTaskToList(
      String newTaskId,
      User currentUser,
      String taskName,
      String taskDescription,
      String currentTeamId,
      String currentDeptId,
      String currentProjectId,
      String currentListId) async {
    var task = Task(
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
        .document(currentTeamId)
        .collection('departments')
        .document(currentDeptId)
        .collection('projects')
        .document(currentProjectId)
        .collection('list')
        .document(currentListId)
        .collection('tasks')
        .document(newTaskId)
        .setData(task.toMap(task));

    task = Task(
      taskId: newTaskId,
      ownerUid: currentUser.uid,
      taskName: taskName,
      ownerName: currentUser.displayName,
      ownerPhotoUrl: currentUser.photoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    await _firestore
        .collection('teams')
        .document(currentTeamId)
        .collection('departments')
        .document(currentDeptId)
        .collection('projects')
        .document(currentProjectId)
        .collection('incomplete')
        .document(newTaskId)
        .setData(task.toMap(task));
  }

  Future<void> addPostToDb(
      User currentUser, String imgUrl, String caption, String location) {
    CollectionReference _collectionRef = _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('posts');

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
    return _collectionRef.document(postId).setData(post.toMap(post));
  }

  Future<void> addPostToForum(String currentGroupId, User currentUser,
      String imgUrl, String caption, String location) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
        .collection('posts');

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
    return _collectionRef.document(postId).setData(post.toMap(post));
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
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
        .collection('posts');

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
    return _collectionRef.document(currentPostId).setData(post.toMap(post));
  }

  Future<void> addApprovedPollToForum(
    String currentGroupId,
    String currentPostId,
    String ownerUid,
    String caption,
    String category,
    String option1,
    String option2,
    String option3,
    String option4,
    String option5,
    String option6,
    String pollType,
    String postType,
    String ownerName,
    String ownerPhotoUrl,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
        .collection('posts');

    poll = Poll(
      postId: currentPostId,
      currentUserUid: ownerUid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      category: category,
      pollType: pollType,
      postType: postType,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      option5: option5,
      option6: option6,
      postOwnerName: ownerName,
      postOwnerPhotoUrl: ownerPhotoUrl,
    );
    return _collectionRef.document(currentPostId).setData(poll.toMap(poll));
  }

  Future<void> addPostToReview(
    String currentGroupId,
    User currentUser,
    String imgUrl,
    String caption,
    String location,
    String postType,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
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
    return _collectionRef.document(postId).setData(post.toMap(post));
  }

  Future<void> addAdToForum(
    String currentGroupId,
    User currentUser,
    String imgUrl,
    String caption,
    String description,
    String price,
    String condition,
    String location,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
        .collection('marketplace');

    ad = Ad(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      description: description,
      price: price,
      condition: condition,
      location: location,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.document(postId).setData(ad.toMap(ad));
  }

  Future<void> addAdToReview(
    String currentGroupId,
    User currentUser,
    String imgUrl,
    String caption,
    String description,
    String price,
    String condition,
    String location,
    String postType,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
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
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      postType: postType,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.document(postId).setData(ad.toMap(ad));
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
        .document(currentGroupId)
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
    return _collectionRef.document(currentPostId).setData(ad.toMap(ad));
  }

  Future<void> addDiscussionToForum(
    String currentGroupId,
    User currentUser,
    String caption,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
        .collection('posts');

    discussion = Discussion(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef
        .document(postId)
        .setData(discussion.toMap(discussion));
  }

  Future<void> addDiscussionToProject(
    String currentTeamId,
    String currentDeptId,
    String currentProjectId,
    User currentUser,
    String caption,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .document(currentTeamId)
        .collection('departments')
        .document(currentDeptId)
        .collection('projects')
        .document(currentProjectId)
        .collection('discussions');

    discussion = Discussion(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef
        .document(postId)
        .setData(discussion.toMap(discussion));
  }

  Future<void> addDiscussionToDept(
    String currentTeamId,
    String currentDeptId,
    User currentUser,
    String caption,
    String discussId,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .document(currentTeamId)
        .collection('departments')
        .document(currentDeptId)
        .collection('discussions');

    discussion = Discussion(
      postId: discussId,
      currentUserUid: currentUser.uid,
      caption: caption,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef
        .document(discussId)
        .setData(discussion.toMap(discussion));
  }

  Future<void> addDiscussionToReview(
    String currentGroupId,
    User currentUser,
    String caption,
    String postType,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
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
    return _collectionRef
        .document(postId)
        .setData(discussion.toMap(discussion));
  }

  Future<void> addPollToDept(
    String currentTeamId,
    String currentDeptId,
    User currentUser,
    String caption,
    String category,
    String pollType,
    String postType,
    String option1,
    String option2,
    String option3,
    String option4,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .document(currentTeamId)
        .collection('departments')
        .document(currentDeptId)
        .collection('discussions');

    poll = Poll(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      category: category,
      pollType: pollType,
      postType: postType,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      option5: '',
      option6: '',
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
    );
    return _collectionRef.document(postId).setData(poll.toMap(poll));
  }

  Future<void> addPollToProject(
    String currentTeamId,
    String currentDeptId,
    String currentProjectId,
    User currentUser,
    String caption,
    String category,
    String pollType,
    String postType,
    String option1,
    String option2,
    String option3,
    String option4,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('teams')
        .document(currentTeamId)
        .collection('departments')
        .document(currentDeptId)
        .collection('projects')
        .document(currentProjectId)
        .collection('discussions');

    poll = Poll(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      category: category,
      pollType: pollType,
      postType: postType,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      option5: '',
      option6: '',
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
    );
    return _collectionRef.document(postId).setData(poll.toMap(poll));
  }

  Future<void> addPollToForum(
    String currentGroupId,
    User currentUser,
    String caption,
    String category,
    String pollType,
    String postType,
    String option1,
    String option2,
    String option3,
    String option4,
    String option5,
    String option6,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
        .collection('posts');

    poll = Poll(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      category: category,
      pollType: pollType,
      postType: postType,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      option5: option5,
      option6: option6,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
    );
    return _collectionRef.document(postId).setData(poll.toMap(poll));
  }

  Future<void> addPollToReview(
    String currentGroupId,
    User currentUser,
    String caption,
    String category,
    String pollType,
    String postType,
    String option1,
    String option2,
    String option3,
    String option4,
    String option5,
    String option6,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
        .collection('reviews');

    poll = Poll(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      time: FieldValue.serverTimestamp(),
      category: category,
      pollType: pollType,
      postType: postType,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      option5: option5,
      option6: option6,
      postOwnerName: currentUser.displayName,
      postOwnerPhotoUrl: currentUser.photoUrl,
    );
    return _collectionRef.document(postId).setData(poll.toMap(poll));
  }

  Future<void> addEventToDb(
    User currentUser,
    String imgUrl,
    String caption,
    String location,
    String organiser,
    String website,
    String description,
    String agenda,
    String category,
    String type,
    String venue,
    String startEvent,
    String endEvent,
    String ticketWebsite,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('events');

    event = Event(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      location: location,
      eventOwnerName: currentUser.displayName,
      eventOwnerPhotoUrl: currentUser.photoUrl,
      organiser: organiser,
      website: website,
      description: description,
      agenda: agenda,
      category: category,
      type: type,
      venue: venue,
      startEvent: startEvent,
      endEvent: endEvent,
      ticketWebsite: ticketWebsite,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.document(postId).setData(event.toMap(event));
  }

  Future<void> addEventToForum(
    String currentGroupId,
    User currentUser,
    String imgUrl,
    String caption,
    String location,
    String organiser,
    String website,
    String description,
    String agenda,
    String category,
    String type,
    String venue,
    String startEvent,
    String endEvent,
    String ticketWebsite,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('groups')
        .document(currentGroupId)
        .collection('events');

    event = Event(
      postId: postId,
      currentUserUid: currentUser.uid,
      imgUrl: imgUrl,
      caption: caption,
      location: location,
      eventOwnerName: currentUser.displayName,
      eventOwnerPhotoUrl: currentUser.photoUrl,
      organiser: organiser,
      website: website,
      description: description,
      agenda: agenda,
      category: category,
      type: type,
      venue: venue,
      startEvent: startEvent,
      endEvent: endEvent,
      ticketWebsite: ticketWebsite,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.document(postId).setData(event.toMap(event));
  }

  Future<void> addNewsToDb(
      User currentUser, String imgUrl, String caption, String source) {
    CollectionReference _collectionRef = _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('news');

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
    return _collectionRef.document(postId).setData(news.toMap(news));
  }

  Future<void> addJobPostToDb(
    User currentUser,
    String caption,
    String location,
    String category,
    String salary,
    String timing,
    String description,
    String website,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('jobs');

    job = Job(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      location: location,
      jobOwnerName: currentUser.displayName,
      jobOwnerPhotoUrl: currentUser.photoUrl,
      category: category,
      salary: salary,
      timing: timing,
      description: description,
      website: website,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.document(postId).setData(job.toMap(job));
  }

  Future<void> addPromotionToDb(
    User currentUser,
    String caption,
    String location,
    String portfolio,
    String timing,
    String category,
    String description,
    String locations,
    String skills,
  ) {
    CollectionReference _collectionRef = _firestore
        .collection('users')
        .document(currentUser.uid)
        .collection('promotion');

    promotion = Promotion(
      postId: postId,
      currentUserUid: currentUser.uid,
      caption: caption,
      location: location,
      promotionOwnerName: currentUser.displayName,
      promotionOwnerPhotoUrl: currentUser.photoUrl,
      portfolio: portfolio,
      timing: timing,
      category: category,
      description: description,
      locations: locations,
      skills: skills,
      time: FieldValue.serverTimestamp(),
    );
    return _collectionRef.document(postId).setData(promotion.toMap(promotion));
  }

  Future<User> retrieveUserDetails(FirebaseUser user) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection('users').document(user.uid).get();
    return User.fromMap(_documentSnapshot.data);
  }

  Future<Group> retrieveGroupDetails(FirebaseUser group) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection('groups').document(group.uid).get();
    return Group.fromMap(_documentSnapshot.data);
  }

  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('posts')
        .orderBy('time', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserGroups(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('groups')
        .orderBy('time', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveGroupsPosts(String groupId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        .document(groupId)
        .collection('posts')
        .orderBy('time', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveTeamTasks(
    String teamTid,
    String deptTid,
    String projectTid,
    String listTid,
  ) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('teams')
        .document(teamTid)
        .collection('departments')
        .document(deptTid)
        .collection('projects')
        .document(projectTid)
        .collection('list')
        .document(listTid)
        .collection('tasks')
        //.orderBy('time', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserJobs(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('jobs')
        .orderBy('time', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserEvents(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('events')
        .orderBy('time', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserNews(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('news')
        .orderBy('time', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserApplications(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('promotion')
        .orderBy('time', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserFollowers(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('followers')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserFollowing(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('following')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserChatRooms(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('chatRoom')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> retrieveUserLikeFeed(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('items')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchPostCommentDetails(
      DocumentReference reference) async {
    QuerySnapshot snapshot =
        await reference.collection('comments').getDocuments();
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchPostLikeDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("likes").getDocuments();
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchTotalVotesDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("votes").getDocuments();
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchPerOptionVotesDetails(
      DocumentReference reference, String label) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection(label).getDocuments();
    return snapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchActivityFeedDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot =
        await reference.collection("feedItems").getDocuments();
    return snapshot.documents;
  }

  Future<bool> checkIfUserLikedOrNot(
      String userId, DocumentReference reference) async {
    DocumentSnapshot snapshot =
        await reference.collection('likes').document(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<bool> checkIfUserVotedOrNot(
      String userId, DocumentReference reference, String label) async {
    DocumentSnapshot snapshot =
        await reference.collection(label).document(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<List<DocumentSnapshot>> retrievePosts(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('posts')
          .orderBy('time', descending: true)
          .getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED LIST LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveGroupPosts(FirebaseUser group) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore
        .collection('groups')
        .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('posts')
          .orderBy('time', descending: true)
          .getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED LIST LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveGroupSuggestions(
      FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore
        .collection('groups')
        // .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('posts')
          .orderBy('time', descending: true)
          .getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED LIST LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveFeeds(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot =
        await _firestore.collection('users').getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot =
          await list[i].reference.collection('feedItems').getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('Feed LIST LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveEvents(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot =
        await _firestore.collection('users').getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('events')
          .orderBy('time', descending: true)
          .getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED Event LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveNews(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot =
        await _firestore.collection('users').getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('news')
          .orderBy('time', descending: true)
          .getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED News LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveJobs(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot =
        await _firestore.collection('users').getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('jobs')
          .orderBy('time', descending: true)
          .getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED Jobs LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrievePromotion(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot =
        await _firestore.collection('users').getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('promotion')
          .orderBy('time', descending: true)
          .getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED Promotion LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<DocumentSnapshot>> retrieveFollowers(FirebaseUser user) async {
    List<DocumentSnapshot> list = List<DocumentSnapshot>();
    List<DocumentSnapshot> updatedList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot;
    QuerySnapshot snapshot =
        await _firestore.collection('users').getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      if (snapshot.documents[i].documentID != user.uid) {
        list.add(snapshot.documents[i]);
      }
    }
    for (var i = 0; i < list.length; i++) {
      querySnapshot = await list[i]
          .reference
          .collection('following')
          .orderBy('timestamp', descending: true)
          .getDocuments();
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        updatedList.add(querySnapshot.documents[i]);
      }
    }
    // fetchSearchPosts(updatedList);
    print('UPDATED following LENGTH : ${updatedList.length}');
    return updatedList;
  }

  Future<List<String>> fetchAllUserNames(FirebaseUser user) async {
    List<String> userNameList = List<String>();
    QuerySnapshot querySnapshot =
        await _firestore.collection('users').getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        userNameList.add(querySnapshot.documents[i].data['displayName']);
      }
    }
    print('USERNAME LIST : ${userNameList.length}');
    return userNameList;
  }

  Future<String> fetchUidBySearchedName(String name) async {
    String uid;
    List<DocumentSnapshot> uidList = List<DocumentSnapshot>();
    QuerySnapshot querySnapshot =
        await _firestore.collection('users').getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      uidList.add(querySnapshot.documents[i]);
    }
    print('UID LIST : ${uidList.length}');
    for (var i = 0; i < uidList.length; i++) {
      if (uidList[i].data['uid'] == name) {
        uid = uidList[i].documentID;
      }
    }
    print('UID DOC ID : $uid');
    return uid;
  }

  Future<User> fetchUserDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').document(uid).get();
    return User.fromMap(documentSnapshot.data);
  }

  Future<Group> fetchGroupDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('groups').document(uid).get();
    return Group.fromMap(documentSnapshot.data);
  }

  Future<Team> fetchTeamDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('teams').document(uid).get();
    return Team.fromMap(documentSnapshot.data);
  }

  Future<Department> fetchDepartmentDetailsById(
      String uid, String departmentUid) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('teams')
        .document(uid)
        .collection('departments')
        .document(departmentUid)
        .get();
    return Department.fromMap(documentSnapshot.data);
  }

  Future<Project> fetchProjectDetailsById(
      String uid, String departmentUid, String projectId) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('teams')
        .document(uid)
        .collection('departments')
        .document(departmentUid)
        .collection('projects')
        .document(projectId)
        .get();
    return Project.fromMap(documentSnapshot.data);
  }

  Future<Project> fetchListDetailsById(String uid, String departmentUid,
      String projectId, String listUid) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('teams')
        .document(uid)
        .collection('departments')
        .document(departmentUid)
        .collection('projects')
        .document(projectId)
        .collection('list')
        .document(listUid)
        .get();
    return Project.fromMap(documentSnapshot.data);
  }

  Future<User> fetchPostDetailsById(String uid, String postId) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection('users')
        .document(uid)
        .collection('posts')
        .document(postId)
        .get();
    return User.fromMap(documentSnapshot.data);
  }

  Future<void> followUser(
      {String currentUserId,
      String followingUserId,
      User followingUser,
      User currentUser}) async {
    following = Following(
        ownerUid: followingUser.uid,
        ownerName: followingUser.displayName,
        ownerPhotoUrl: followingUser.photoUrl,
        accountType: followingUser.accountType,
        timestamp: FieldValue.serverTimestamp());

    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('followers')
        .document(followingUser.uid)
        .setData(following.toMap(following));

    follower = Follower(
        ownerUid: currentUserId,
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        accountType: currentUser.accountType,
        timestamp: FieldValue.serverTimestamp());

    return _firestore
        .collection('users')
        .document(followingUser.uid)
        .collection('following')
        .document(currentUserId)
        .setData(follower.toMap(follower));
  }

  Future<void> addChatRoom(
      {
      //String currentUserId,
      // String followingUserId,
      User followingUser,
      User currentUser}) async {
    _chatRoom = ChatRoom(
        ownerUid: followingUser.uid,
        ownerName: followingUser.displayName,
        ownerPhotoUrl: followingUser.photoUrl,
        timestamp: FieldValue.serverTimestamp());

    await _firestore
        .collection('messages')
        .document(currentUser.uid)
        .collection('chatRoom')
        .document(followingUser.uid)
        .setData(_chatRoom.toMap(_chatRoom));

    _chatRoom = ChatRoom(
        ownerUid: currentUser.uid,
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        timestamp: FieldValue.serverTimestamp());

    return _firestore
        .collection('messages')
        .document(followingUser.uid)
        .collection('chatRoom')
        .document(currentUser.uid)
        .setData(_chatRoom.toMap(_chatRoom));
  }

  Future<void> unFollowUser(
      {String currentUserId,
      String followingUserId,
      User followingUser,
      User currentUser}) async {
    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('followers')
        .document(followingUser.uid)
        .delete();

    return _firestore
        .collection('users')
        .document(followingUser.uid)
        .collection('following')
        .document(currentUserId)
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
        .document(currentGroupId)
        .collection('invites')
        .document(followingUserId)
        .setData(invite.toMap(invite));
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
        .document(currentTeam.uid)
        .collection('members')
        .document(followerId)
        .setData(member.toMap(member));

    var team = Team(
      uid: currentTeam.uid,
      teamName: currentTeam.teamName,
      teamProfilePhoto: currentTeam.teamProfilePhoto,
    );
    return _firestore
        .collection('users')
        .document(followerId)
        .collection('teams')
        .document(currentTeam.uid)
        .setData(team.toMap(team));
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
    return _firestore
        .collection('teams')
        .document(currentTeam.uid)
        .collection('departments')
        .document(currentDeptId)
        .collection('members')
        .document(followerId)
        .setData(member.toMap(member));

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
        .document(currentTeam.uid)
        .collection('departments')
        .document(currentDeptId)
        .collection('projects')
        .document(currentProjectId)
        .collection('members')
        .document(followerId)
        .setData(member.toMap(member));

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
        .document(currentTeam.uid)
        .collection('departments')
        .document(currentDeptId)
        .collection('projects')
        .document(currentProjectId)
        .updateData(project.toMap(project));

    var member = Member(
      ownerUid: followerId,
      ownerName: followerName,
      accountType: followerAccountType,
      ownerPhotoUrl: followerPhotoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    return _firestore
        .collection('teams')
        .document(currentTeam.uid)
        .collection('departments')
        .document(currentDeptId)
        .collection('projects')
        .document(currentProjectId)
        .collection('members')
        .document(followerId)
        .setData(member.toMap(member));

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
        .document(currentTeam.uid)
        .collection('departments')
        .document(currentDeptId)
        .updateData(dept.toMap(dept));

    var member = Member(
      ownerUid: followerId,
      ownerName: followerName,
      accountType: followerAccountType,
      ownerPhotoUrl: followerPhotoUrl,
      timestamp: FieldValue.serverTimestamp(),
    );
    return _firestore
        .collection('teams')
        .document(currentTeam.uid)
        .collection('departments')
        .document(currentDeptId)
        .collection('members')
        .document(followerId)
        .setData(member.toMap(member));

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
        .document(currentGroupId)
        .collection('invites')
        .document(followingUserId)
        .delete();
  }

  Future<bool> checkIsFollowing(String name, String currentUserId) async {
    bool isFollowing = false;
    String uid = await fetchUidBySearchedName(name);
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('following')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == uid) {
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
        .document(currentUserId)
        .collection('requests')
        // .where('type', isEqualTo: 'request')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == uid) {
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
        .document(currentGroupId)
        .collection('requests')
        // .where('type', isEqualTo: 'request')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == uid) {
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
        .document(currentUserId)
        .collection('invites')
        // .where('type', isEqualTo: 'request')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == uid) {
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
        .document(currentUserId)
        .collection('items')
        // .where('type', isEqualTo: 'request')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == uid) {
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
        .document(currentGroupId)
        .collection('members')
        // .where('type', isEqualTo: 'request')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == uid) {
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
        .document(currentTeamId)
        .collection('departments')
        .document(currentDeptId)
        .collection('members')
        // .where('type', isEqualTo: 'request')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == uid) {
        isMember = true;
      }
    }
    return isMember;
  }

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(uid)
        .collection(label)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> fetchVotes(
      {String gid, String postId, String label}) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        .document(gid)
        .collection('posts')
        .document(postId)
        .collection(label)
        .getDocuments();
    return querySnapshot.documents;
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = Map();
    map['groupProfilePhoto'] = photoUrl;
    return _firestore.collection('groups').document(uid).updateData(map);
  }

  Future<void> updateDetails(String uid, String name, String bio, String email,
      String phone, String website) async {
    Map<String, dynamic> map = Map();
    map['displayName'] = name;
    map['bio'] = bio;
    map['email'] = email;
    map['phone'] = phone;
    map['website'] = website;
    return _firestore.collection('users').document(uid).updateData(map);
  }

  Future<void> updateSchool(String uid, String school) async {
    Map<String, dynamic> map = Map();
    map['school'] = school;
    return _firestore.collection('users').document(uid).updateData(map);
  }

  Future<void> updateProducts(String uid, List<String> products) async {
    Map<String, dynamic> map = Map();
    map['products'] = products;
    return _firestore.collection('users').document(uid).updateData(map);
  }

  Future<List<String>> fetchUserNames(FirebaseUser user) async {
    DocumentReference documentReference =
        _firestore.collection('messages').document(user.uid);
    List<String> userNameList = List<String>();
    List<String> chatUsersList = List<String>();
    QuerySnapshot querySnapshot =
        await _firestore.collection('users').getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        print('USERNAMES : ${querySnapshot.documents[i].documentID}');
        userNameList.add(querySnapshot.documents[i].documentID);
        // querySnapshot.documents[
        //  i].reference.collection('collectionPath');
        //   userNameList.add(querySnapshot.documents[
        //  i].data['displayName']);
      }
    }
    for (var i = 0; i < userNameList.length; i++) {
      if (documentReference.collection(userNameList[i]) != null) {
        if (documentReference.collection(userNameList[i]).getDocuments() !=
            null) {
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

  Future<List<User>> fetchAllUsers(FirebaseUser user) async {
    List<User> userList = List<User>();
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
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('USERSLIST : ${userList.length}');
    return userList;
  }

  Future<List<Member>> fetchAllProjectMembers(
      String teamUid, String deptUid, String projectUid) async {
    List<Member> userList;
    QuerySnapshot querySnapshot = await _firestore
        .collection('teams')
        .document(teamUid)
        .collection('departments')
        .document(deptUid)
        .collection('projects')
        .document(projectUid)
        .collection('members')
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      //  if (querySnapshot.documents[i].documentID != user.uid) {
      userList.add(Member.fromMap(querySnapshot.documents[i].data));
      //userList.add(querySnapshot.doucments[i].data[User.fromMap(
      // mapData)]);
      // }
    }
    print('members : ${userList.length}');
    return userList;
  }

  Future<List<Group>> fetchAllGroups(FirebaseUser user) async {
    List<Group> groupList = List<Group>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        //   .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        groupList.add(Group.fromMap(querySnapshot.documents[i].data));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('Grouplist : ${groupList.length}');
    return groupList;
  }

  Future<List<Group>> fetchAllGroupSuggestions(FirebaseUser user) async {
    List<Group> groupList = List<Group>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('groups')
        //   .where('isPrivate', isEqualTo: false)
        .where('isHidden', isEqualTo: false)
        .limit(20)
        //.orderBy('displayName')
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        groupList.add(Group.fromMap(querySnapshot.documents[i].data));
        //userList.add(querySnapshot.doucments[i].data[User.fromMap(
        // mapData)]);
      }
    }
    print('Grouplist : ${groupList.length}');
    return groupList;
  }

  Future<List<User>> fetchAllCompanies(FirebaseUser user) async {
    List<User> companyList = List<User>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('accountType', isEqualTo: 'Company')
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        companyList.add(User.fromMap(querySnapshot.documents[i].data));
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
        .document(_message.senderUid)
        .collection('chatRoom')
        .document(receiverUid)
        .collection('messages')
        .document(msgId)
        .setData(map)
        .whenComplete(() {
      print('Messages added to db');
      msgId = Uuid().v4();
    });

    _firestore
        .collection('messages')
        .document(receiverUid)
        .collection('chatRoom')
        .document(_message.senderUid)
        .collection('messages')
        .document(msgId)
        .setData(map)
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
        .document(message.senderUid)
        .collection('chatRoom')
        .document(receiverUid)
        .collection('messages')
        .document(msgId)
        .setData(map);

    return _firestore
        .collection('messages')
        .document(receiverUid)
        .collection('chatRoom')
        .document(message.senderUid)
        .collection('messages')
        .document(msgId)
        .setData(map)
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
        .document(receiverGroup.uid)
        .collection('messages')
        .document(msgId)
        .setData(map)
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
        .document(receiverGroup.uid)
        .collection('messages')
        .document(msgId)
        .setData(map)
        .whenComplete(() {
      msgId = Uuid().v4();
    });
  }

  Future<List<DocumentSnapshot>> fetchFeed(FirebaseUser user) async {
    List<String> followingUIDs = List<String>();
    List<DocumentSnapshot> list = List<DocumentSnapshot>();

    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(user.uid)
        .collection('following')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      followingUIDs.add(querySnapshot.documents[i].documentID);
    }
    print("FOLLOWING UIDS : ${followingUIDs.length}");
    for (var i = 0; i < followingUIDs.length; i++) {
      print('SDDSSD : ${followingUIDs[i]}');

      //retreivePostByUID(followingUIDs[i]);
      // fetchUserDetailsById(followingUIDs[i]);

      QuerySnapshot postSnapshot = await _firestore
          .collection('users')
          .document(followingUIDs[i])
          .collection('posts')
          .getDocuments();
      //postSnapshot.documents;
      for (var i = 0; i < postSnapshot.documents.length; i++) {
        print('dad : ${postSnapshot.documents[i].documentID}');
        list.add(postSnapshot.documents[i]);
        print('ads : ${list.length}');
      }
    }
    return list;
  }

  Future<List<String>> fetchFollowingUids(FirebaseUser user) async {
    List<String> followingUIDs = List<String>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(user.uid)
        .collection('following')
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      followingUIDs.add(querySnapshot.documents[i].documentID);
    }
    for (var i = 0; i < followingUIDs.length; i++) {
      print('DDDD : ${followingUIDs[i]}');
    }
    return followingUIDs;
  }

  Future<List<User>> fetchFollowingUsers(FirebaseUser user) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(user.uid)
        .collection('following')
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      userList.add(User.fromMap(querySnapshot.documents[i].data));
      //userList.add(querySnapshot.doucments[i].data[User.fromMap(
      // mapData)]);

    }
    print('USERSLIST : ${userList.length}');
    return userList;
  }

  Future<List<User>> fetchFollowUsers(FirebaseUser user) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .document(user.uid)
        .collection('followers')
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != user.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
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
