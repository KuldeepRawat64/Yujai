import 'dart:async';
import 'dart:io';
//import 'package:Yujai/models/job.dart';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/message.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/group_chat.dart';
//import 'package:Yujai/pages/article_upload.dart';
//import 'package:Yujai/pages/event_upload.dart';
import 'package:Yujai/resources/firebase_provider.dart';
//import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(FirebaseUser user) =>
      _firebaseProvider.addDataToDb(user);

  Future<FirebaseUser> signIn() => _firebaseProvider.signIn();

  Future<bool> authenticateUser(FirebaseUser user) =>
      _firebaseProvider.authenticateUser(user);

  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();

  Future<String> uploadImageToStorage(File imageFile) =>
      _firebaseProvider.uploadImageToStorage(imageFile);

  Future<void> addPostToDb(
          User currentUser, String imgUrl, String caption, String location) =>
      _firebaseProvider.addPostToDb(currentUser, imgUrl, caption, location);

  Future<void> addPostToForum(String currentGroupId, User currentUser,
          String imgUrl, String caption, String location) =>
      _firebaseProvider.addPostToForum(
          currentGroupId, currentUser, imgUrl, caption, location);

  Future<void> addListToProject(
          String currentListId,
          User currentUser,
          String listName,
          String currentTeamId,
          String currentDeptId,
          currentProjectId,
          int color) =>
      _firebaseProvider.addListToProject(currentListId, currentUser, listName,
          currentTeamId, currentDeptId, currentProjectId, color);

  Future<void> addTaskToList(
          String newTaskId,
          User currentUser,
          String taskName,
          String description,
          String currentTeamId,
          String currentDeptId,
          String currentProjectId,
          String currentListId) =>
      _firebaseProvider.addTaskToList(
          newTaskId,
          currentUser,
          taskName,
          description,
          currentTeamId,
          currentDeptId,
          currentProjectId,
          currentListId);

  Future<void> addApprovedPostToForum(
          String currentGroupId,
          String currentPostId,
          String ownerUid,
          String imgUrl,
          String caption,
          String location,
          String ownerName,
          String ownerPhotoUrl,
          String postType) =>
      _firebaseProvider.addApprovedPostToForum(
          currentGroupId,
          currentPostId,
          ownerUid,
          imgUrl,
          caption,
          location,
          ownerName,
          ownerPhotoUrl,
          postType);

  Future<void> addPostToReview(String currentGroupId, User currentUser,
          String imgUrl, String caption, String location, String postType) =>
      _firebaseProvider.addPostToReview(
          currentGroupId, currentUser, imgUrl, caption, location, postType);

  Future<void> addAdToForum(
          String currentGroupId,
          User currentUser,
          List<String> imgUrl,
          String caption,
          String description,
          String price,
          String condition,
          String city,
          String location,
          String category,
          GeoPoint geoPoint) =>
      _firebaseProvider.addAdToForum(
          currentGroupId,
          currentUser,
          imgUrl,
          caption,
          description,
          price,
          condition,
          city,
          location,
          category,
          geoPoint);

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
          String category) =>
      _firebaseProvider.addAdToReview(currentGroupId, currentUser, imgUrl,
          caption, description, price, condition, location, postType, category);

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
          String postType) =>
      _firebaseProvider.addApprovedAdToForum(
          currentGroupId,
          currentPostId,
          ownerUid,
          imgUrl,
          caption,
          description,
          price,
          condition,
          location,
          ownerName,
          ownerPhotoUrl,
          postType);

  Future<void> addDiscussionToForum(
          String currentGroupId, User currentUser, String caption) =>
      _firebaseProvider.addDiscussionToForum(
          currentGroupId, currentUser, caption);

  Future<void> addDiscussionToDb(User currentUser, String caption) =>
      _firebaseProvider.addDiscussionToDb(currentUser, caption);

  Future<void> addDiscussionToDept(String currentTeamId, String currentDeptId,
          User currentUser, String caption, String discussId) =>
      _firebaseProvider.addDiscussionToDept(
          currentTeamId, currentDeptId, currentUser, caption, discussId);

  Future<void> addDiscussionToProject(
          String currentTeamId,
          String currentDeptId,
          String currentProjectId,
          User currentUser,
          String caption) =>
      _firebaseProvider.addDiscussionToProject(
          currentTeamId, currentDeptId, currentProjectId, currentUser, caption);

  Future<void> addDiscussionToReview(String currentGroupId, User currentUser,
          String caption, String postType) =>
      _firebaseProvider.addDiscussionToReview(
          currentGroupId, currentUser, caption, postType);

  Future<void> addPollToForum(
    String currentGroupId,
    User currentUser,
    String caption,
    String postType,
    int pollLength,
    String option1,
    String option2,
    String option3,
    String option4,
  ) =>
      _firebaseProvider.addPollToForum(
        currentGroupId,
        currentUser,
        caption,
        pollLength,
        postType,
        option1,
        option2,
        option3,
        option4,
      );

  Future<void> addPollToProject(
          String currentTeamId,
          String currentDeptId,
          String currentProjectId,
          User currentUser,
          String caption,
          int pollLength,
          String postType,
          String option1,
          String option2,
          String option3,
          String option4) =>
      _firebaseProvider.addPollToProject(
          currentTeamId,
          currentDeptId,
          currentProjectId,
          currentUser,
          caption,
          pollLength,
          postType,
          option1,
          option2,
          option3,
          option4);

  Future<void> addPollToDept(
          String currentTeamId,
          String currentDeptId,
          User currentUser,
          String caption,
          int pollLength,
          String postType,
          String option1,
          String option2,
          String option3,
          String option4) =>
      _firebaseProvider.addPollToDept(currentTeamId, currentDeptId, currentUser,
          caption, pollLength, postType, option1, option2, option3, option4);

  Future<void> addPollToReview(
    String currentGroupId,
    User currentUser,
    String caption,
    String postType,
    int pollLength,
    String option1,
    String option2,
    String option3,
    String option4,
  ) =>
      _firebaseProvider.addPollToReview(
        currentGroupId,
        currentUser,
        caption,
        postType,
        pollLength,
        option1,
        option2,
        option3,
        option4,
      );

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
          String ownerPhotoUrl) =>
      _firebaseProvider.addApprovedPollToForum(
          currentGroupId,
          currentPostId,
          ownerUid,
          caption,
          option1,
          option2,
          option3,
          option4,
          postType,
          ownerName,
          ownerPhotoUrl);

  Future<void> addGroupToDb(
          User currentUser,
          String groupName,
          String description,
          String location,
          String agenda,
          bool isPrivate,
          bool isHidden,
          List<String> rules) =>
      _firebaseProvider.addGroupToDb(currentUser, groupName, description,
          location, agenda, isPrivate, isHidden, rules);

  Future<void> addProjectToDept(
          User currentUser,
          String teamUid,
          String departmentUid,
          String projectName,
          bool isPrivate,
          int color,
          String pId) =>
      _firebaseProvider.addProjectToDepartment(currentUser, teamUid,
          departmentUid, projectName, isPrivate, color, pId);

  Future<void> addDeptToteam(
          User currentUser,
          String teamUid,
          String departmentUid,
          String departmentName,
          bool isPrivate,
          int img,
          int color) =>
      _firebaseProvider.addDepartmentToTeam(currentUser, teamUid, departmentUid,
          departmentName, isPrivate, img, color);

  Future<void> addTeamToDb(User currentUser, String teamName,
          List<String> department, int color) =>
      _firebaseProvider.addTeamToDb(currentUser, teamName, department, color);

  Future<void> addOfflineEventToDb(
    User currentUser,
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
  ) =>
      _firebaseProvider.addOfflineEventToDb(
          currentUser,
          imgUrl,
          caption,
          city,
          venue,
          host,
          description,
          category,
          startDate,
          endDate,
          startTime,
          endTime,
          ticketWebsite,
          geoPoint);

  Future<void> addOnlineEventToDb(
    User currentUser,
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
  ) =>
      _firebaseProvider.addOnlineEventToDb(
        currentUser,
        imgUrl,
        caption,
        host,
        website,
        description,
        category,
        startDate,
        endDate,
        startTime,
        endTime,
        ticketWebsite,
      );

  Future<void> addOfflineEventToForum(
    String currentGroupId,
    User currentUser,
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
  ) =>
      _firebaseProvider.addOfflineEventToForum(
          currentGroupId,
          currentUser,
          imgUrl,
          caption,
          city,
          venue,
          host,
          description,
          category,
          startDate,
          endDate,
          startTime,
          endTime,
          ticketWebsite,
          geoPoint);

  Future<void> addOnlineEventToForum(
    String currentGroupId,
    User currentUser,
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
  ) =>
      _firebaseProvider.addOnlineEventToForum(
        currentGroupId,
        currentUser,
        imgUrl,
        caption,
        host,
        website,
        description,
        category,
        startDate,
        endDate,
        startTime,
        endTime,
        ticketWebsite,
      );

  Future<void> addNewsToDb(
          User currentUser, String imgUrl, String caption, String source) =>
      _firebaseProvider.addNewsToDb(currentUser, imgUrl, caption, source);

  Future<void> addJobToDb(User currentUser, String caption, String location,
          String industry, String description, String website) =>
      _firebaseProvider.addJobPostToDb(
          currentUser, caption, location, industry, description, website);

  Future<void> addPromotionToDb(
    User currentUser,
    String caption,
    String location,
    String portfolio,
    //  String timing,
    //    String category,
    String description,
    //    String locations,
    List<dynamic> skills,
    List<dynamic> experience,
    List<dynamic> education,
  ) =>
      _firebaseProvider.addPromotionToDb(currentUser, caption, location,
          portfolio, description, skills, experience, education);

  Future<User> retreiveUserDetails(FirebaseUser user) =>
      _firebaseProvider.retrieveUserDetails(user);

  Future<Group> retreiveGroupDetails(String group) =>
      _firebaseProvider.retrieveGroupDetails(group);

  Future<List<DocumentSnapshot>> retreiveUserPosts(String userId) =>
      _firebaseProvider.retrieveUserPosts(userId);

  Future<List<DocumentSnapshot>> retreiveUserGroups(String userId) =>
      _firebaseProvider.retrieveUserGroups(userId);

  Future<List<DocumentSnapshot>> retreiveTeamTask(
          String teamTid, String deptTid, String projectTid, String listTid) =>
      _firebaseProvider.retrieveTeamTasks(
          teamTid, deptTid, projectTid, listTid);

  Future<List<DocumentSnapshot>> retreiveGroupsPosts(String userId) =>
      _firebaseProvider.retrieveGroupsPosts(userId);

  Future<List<DocumentSnapshot>> retreiveUserJobs(String userId) =>
      _firebaseProvider.retrieveUserJobs(userId);

  Future<List<DocumentSnapshot>> retreiveUserNews(String userId) =>
      _firebaseProvider.retrieveUserNews(userId);

  Future<List<DocumentSnapshot>> retreiveUserEvents(String userId) =>
      _firebaseProvider.retrieveUserEvents(userId);

  Future<List<DocumentSnapshot>> retreiveUserApplications(String userId) =>
      _firebaseProvider.retrieveUserApplications(userId);

  Future<List<DocumentSnapshot>> retreiveUserFollowers(String userId) =>
      _firebaseProvider.retrieveUserFollowers(userId);

  Future<List<DocumentSnapshot>> retreiveUserFollowing(String userId) =>
      _firebaseProvider.retrieveUserFollowing(userId);

  Future<List<DocumentSnapshot>> retreiveUserChatRoom(String userId) =>
      _firebaseProvider.retrieveUserChatRooms(userId);

  Future<List<DocumentSnapshot>> retreiveUserLikeFeed(String userId) =>
      _firebaseProvider.retrieveUserLikeFeed(userId);

  Future<List<DocumentSnapshot>> fetchPostComments(
          DocumentReference reference) =>
      _firebaseProvider.fetchPostCommentDetails(reference);

  Future<List<DocumentSnapshot>> fetchActivityFeeds(
          DocumentReference reference) =>
      _firebaseProvider.fetchActivityFeedDetails(reference);

  Future<List<DocumentSnapshot>> fetchPostLikes(DocumentReference reference) =>
      _firebaseProvider.fetchPostLikeDetails(reference);

  Future<List<DocumentSnapshot>> fetchTotalVotes(DocumentReference reference) =>
      _firebaseProvider.fetchTotalVotesDetails(reference);

  Future<List<DocumentSnapshot>> fetchPerVotes(
          DocumentReference reference, String label) =>
      _firebaseProvider.fetchPerOptionVotesDetails(reference, label);

  Future<bool> checkIfUserLikedOrNot(
          String userId, DocumentReference reference) =>
      _firebaseProvider.checkIfUserLikedOrNot(userId, reference);

  Future<bool> checkIfUserVotedOrNot(
          String userId, DocumentReference reference, String label) =>
      _firebaseProvider.checkIfUserVotedOrNot(userId, reference, label);

  Future<List<DocumentSnapshot>> retrievePosts(FirebaseUser user) =>
      _firebaseProvider.retrievePosts(user);

  Future<List<DocumentSnapshot>> retrieveGroupPosts(FirebaseUser group) =>
      _firebaseProvider.retrieveGroupPosts(group);

  Future<List<DocumentSnapshot>> retrieveFeeds(FirebaseUser user) =>
      _firebaseProvider.retrieveFeeds(user);

  Future<List<DocumentSnapshot>> retrieveEvents(FirebaseUser user) =>
      _firebaseProvider.retrieveEvents(user);

  Future<List<DocumentSnapshot>> retrieveNews(FirebaseUser user) =>
      _firebaseProvider.retrieveNews(user);

  Future<List<DocumentSnapshot>> retrieveJobs(FirebaseUser user) =>
      _firebaseProvider.retrieveJobs(user);

  Future<List<DocumentSnapshot>> retrievePromotion(FirebaseUser user) =>
      _firebaseProvider.retrievePromotion(user);

  Future<List<DocumentSnapshot>> retrieveFollowers(FirebaseUser user) =>
      _firebaseProvider.retrieveFollowers(user);

  Future<List<String>> fetchAllUserNames(FirebaseUser user) =>
      _firebaseProvider.fetchAllUserNames(user);

  Future<String> fetchUidBySearchedName(String name) =>
      _firebaseProvider.fetchUidBySearchedName(name);

  Future<User> fetchUserDetailsById(String uid) =>
      _firebaseProvider.fetchUserDetailsById(uid);

  Future<Group> fetchGroupDetailsById(String uid) =>
      _firebaseProvider.fetchGroupDetailsById(uid);

  Future<Team> fetchTeamDetailsById(String uid) =>
      _firebaseProvider.fetchTeamDetailsById(uid);

  Future<Department> fetchDepartmentDetailsById(
          String uid, String departmentUid) =>
      _firebaseProvider.fetchDepartmentDetailsById(uid, departmentUid);

  Future<Project> fetchProjectDetailsById(
          String uid, String departmentUid, String projectId) =>
      _firebaseProvider.fetchProjectDetailsById(uid, departmentUid, projectId);

  Future<Project> fetchListDetailsById(
          String uid, String departmentUid, String projectId, String listUid) =>
      _firebaseProvider.fetchListDetailsById(
          uid, departmentUid, projectId, listUid);

  Future<User> fetchPostDetailsById(String uid, String postId) =>
      _firebaseProvider.fetchPostDetailsById(uid, postId);

  Future<void> followUser(
          {String currentUserId,
          String followingUserId,
          User followingUser,
          User currentUser}) =>
      _firebaseProvider.followUser(
          currentUserId: currentUserId,
          followingUserId: followingUserId,
          followingUser: followingUser,
          currentUser: currentUser);

  Future<void> addTeamMember(
          {Team currentTeam,
          String followerId,
          String followerName,
          String followerAccountType,
          String followerPhotoUrl}) =>
      _firebaseProvider.addTeamMember(
          currentTeam: currentTeam,
          followerId: followerId,
          followerName: followerName,
          followerAccountType: followerAccountType,
          followerPhotoUrl: followerPhotoUrl);

  Future<void> addDeptMember(
          {Team currentTeam,
          String currentDeptId,
          String followerId,
          String followerName,
          String followerAccountType,
          String followerPhotoUrl}) =>
      _firebaseProvider.addDeptMember(
          currentTeam: currentTeam,
          currentDeptId: currentDeptId,
          followerId: followerId,
          followerName: followerName,
          followerAccountType: followerAccountType,
          followerPhotoUrl: followerPhotoUrl);

  Future<void> addDeptAdmin(
          {Team currentTeam,
          int currentDeptColor,
          String currentDeptName,
          int currentDeptProfile,
          String currentDeptDesc,
          String currentDeptId,
          String followerId,
          String followerName,
          String followerAccountType,
          String followerPhotoUrl}) =>
      _firebaseProvider.addDeptAdmin(
          currentTeam: currentTeam,
          currentDeptId: currentDeptId,
          currentDeptColor: currentDeptColor,
          currentDeptName: currentDeptName,
          currentDeptProfile: currentDeptProfile,
          currentDeptDesc: currentDeptDesc,
          followerId: followerId,
          followerName: followerName,
          followerAccountType: followerAccountType,
          followerPhotoUrl: followerPhotoUrl);

  Future<void> addProjectMember(
          {Team currentTeam,
          String currentDeptId,
          String currentProjectId,
          String followerId,
          String followerName,
          String followerAccountType,
          String followerPhotoUrl}) =>
      _firebaseProvider.addProjectMember(
          currentTeam: currentTeam,
          currentDeptId: currentDeptId,
          currentProjectId: currentProjectId,
          followerId: followerId,
          followerName: followerName,
          followerAccountType: followerAccountType,
          followerPhotoUrl: followerPhotoUrl);

  Future<void> addProjectAdmin(
          {Team currentTeam,
          String currentProjectId,
          int currentProjectColor,
          String currentProjectName,
          int currentProjectProfile,
          String currentProjectDesc,
          String currentDeptId,
          String followerId,
          String followerName,
          String followerAccountType,
          String followerPhotoUrl}) =>
      _firebaseProvider.addProjectAdmin(
          currentTeam: currentTeam,
          currentProjectId: currentProjectId,
          currentDeptId: currentDeptId,
          currentProjectColor: currentProjectColor,
          currentProjectName: currentProjectName,
          currentProjectProfile: currentProjectProfile,
          currentProjectDesc: currentProjectDesc,
          followerId: followerId,
          followerName: followerName,
          followerAccountType: followerAccountType,
          followerPhotoUrl: followerPhotoUrl);

  Future<void> inviteUser({String currentGroupId, String followingUserId}) =>
      _firebaseProvider.inviteUser(
          currentGroupId: currentGroupId, followingUserId: followingUserId);

  Future<void> unFollowUser(
          {String currentUserId,
          String followingUserId,
          User followingUser,
          User currentUser}) =>
      _firebaseProvider.unFollowUser(
          currentUserId: currentUserId,
          followingUserId: followingUserId,
          followingUser: followingUser,
          currentUser: currentUser);

  Future<void> deleteInvite({String currentGroupId, String followingUserId}) =>
      _firebaseProvider.deleteInvite(
          currentGroupId: currentGroupId, followingUserId: followingUserId);

  Future<void> addChatRoom({User followingUser, User currentUser}) =>
      _firebaseProvider.addChatRoom(
          followingUser: followingUser, currentUser: currentUser);

  Future<bool> checkIsFollowing(String name, String currentUserId) =>
      _firebaseProvider.checkIsFollowing(name, currentUserId);

  Future<bool> checkIsRequested(String name, String currentUserId) =>
      _firebaseProvider.checkIsRequested(name, currentUserId);

  Future<bool> checkIsRequestedGroup(String name, String currentGroupId) =>
      _firebaseProvider.checkIsRequestedGroup(name, currentGroupId);

  Future<bool> checkIsMember(String name, String currentGroupId) =>
      _firebaseProvider.checkIsMember(name, currentGroupId);

  Future<bool> checkDeptMember(
          String name, String currentTeamId, String currentDeptId) =>
      _firebaseProvider.checkDepartmentMember(
          name, currentTeamId, currentDeptId);

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) =>
      _firebaseProvider.fetchStats(uid: uid, label: label);

  Future<List<DocumentSnapshot>> fetchVotes(
          {String gid, String postId, String label}) =>
      _firebaseProvider.fetchVotes(gid: gid, postId: postId, label: label);

  Future<void> updatePhoto(String photoUrl, String uid) =>
      _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(String uid, String name, String bio, String email,
          String phone, String website) =>
      _firebaseProvider.updateDetails(uid, name, bio, email, phone, website);

  Future<void> updateEducationDetails(
          String uid,
          String university,
          String stream,
          int startDate,
          int endDate,
          String cert1,
          String cert2,
          String cert3) =>
      _firebaseProvider.updateEducationDetails(
          uid, university, stream, startDate, endDate, cert1, cert2, cert3);

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
  ) =>
      _firebaseProvider.updateExperienceDetails(
        uid,
        company1,
        designationCompany1,
        startDateCompany1,
        endDateCompany1,
        company2,
        designationCompany2,
        startDateCompany2,
        endDateCompany2,
        company3,
        designationCompany3,
        startDateCompany3,
        endDateCompany3,
      );

  Future<void> updateSchool(String uid, String school) =>
      _firebaseProvider.updateSchool(uid, school);

  Future<void> updatePrducts(String uid, List<String> products) =>
      _firebaseProvider.updateProducts(uid, products);

  Future<List<String>> fetchUserNames(FirebaseUser user) =>
      _firebaseProvider.fetchUserNames(user);

  Future<List<User>> fetchAllUsers(FirebaseUser user) =>
      _firebaseProvider.fetchAllUsers(user);

  Future<List<Member>> fetchAllProjectMembers(
          String teamUid, String deptUid, String projectUid) =>
      _firebaseProvider.fetchAllProjectMembers(teamUid, deptUid, projectUid);

  Future<List<Group>> fetchAllGroups(FirebaseUser user) =>
      _firebaseProvider.fetchAllGroups(user);

  Future<List<Group>> fetchMyGroups(FirebaseUser user) =>
      _firebaseProvider.fetchMyGroups(user);

  Future<List<Team>> fetchMyTeams(FirebaseUser user) =>
      _firebaseProvider.fetchMyTeams(user);

  Future<List<User>> fetchAllCompanies(FirebaseUser user) =>
      _firebaseProvider.fetchAllCompanies(user);

  void uploadImageMsgToDb(String url, String receiverUid, String senderuid,
          String senderPhoto, String senderName) =>
      _firebaseProvider.uploadImageMsgToDb(
          url, receiverUid, senderuid, senderPhoto, senderName);

  Future<void> addMessageToDb(Message message, String receiverUid) =>
      _firebaseProvider.addMessageToDb(message, receiverUid);

  void uploadImageMsgToGroup(String url, Group receiverGroup, String senderuid,
          String senderPhoto, String senderName) =>
      _firebaseProvider.uploadImageMsgToGroup(
          url, receiverGroup, senderuid, senderPhoto, senderName);

  Future<void> addMessageToGroup(Message message, Group receiverGroup) =>
      _firebaseProvider.addMessageToGroup(message, receiverGroup);

  Future<List<DocumentSnapshot>> fetchFeed(FirebaseUser user) =>
      _firebaseProvider.fetchFeed(user);

  Future<List<String>> fetchFollowingUids(FirebaseUser user) =>
      _firebaseProvider.fetchFollowingUids(user);

  Future<List<User>> fetchFollowingUsers(FirebaseUser user) =>
      _firebaseProvider.fetchFollowingUsers(user);

  Future<List<User>> fetchFollowUsers(FirebaseUser user) =>
      _firebaseProvider.fetchFollowUsers(user);

  //Future<List<DocumentSnapshot>> retrievePostByUID(String uid) => _firebaseProvider.retrievePostByUID(uid);

}
