import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class ListItemMember extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;
  final int index;
  final String gid;
  final String name;
  final Group group;
  final Team team;
  ListItemMember(
      {this.user,
      this.index,
      this.currentuser,
      this.documentSnapshot,
      this.gid,
      this.name,
      this.group,
      this.team});

  @override
  _ListItemMemberState createState() => _ListItemMemberState();
}

class _ListItemMemberState extends State<ListItemMember> {
  var _repository = Repository();
  bool _isInvited;
  final _formKey = GlobalKey<FormState>();
  var _currentDept;
  Department _department;

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} comments',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                  color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _isInvited = false;
    _repository
        .checkIsMember(widget.documentSnapshot['ownerUid'], widget.gid,
            widget.group != null ? true : false)
        .then((value) {
      print("value:$value");
      if (!mounted) return;
      setState(() {
        _isInvited = value;
      });
    });
  }

  fetchUserDetailsById(String deptId) async {
    Department department =
        await _repository.fetchDepartmentDetailsById(widget.gid, deptId);
    if (!mounted) return;
    setState(() {
      _department = department;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Container(
          decoration: ShapeDecoration(
            color: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              //  side: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: ListTile(
              subtitle: Text(
                widget.documentSnapshot['accountType'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                ),
              ),
              title: Text(
                widget.documentSnapshot['ownerName'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    widget.documentSnapshot['ownerPhotoUrl']),
              ),
              trailing: widget.documentSnapshot != null &&
                      widget.documentSnapshot['accountType'] != 'admin'
                  ? InkWell(
                      onTap: optionTeam,
                      child: Icon(Icons.more_vert,
                          color: Theme.of(context).accentColor,
                          size: screenSize.height * 0.035))
                  : Icon(
                      Icons.security_outlined,
                      color: Colors.black54,
                      size: screenSize.height * 0.03,
                    ))),
    );
  }

  optionTeam() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                  content: Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          deleteDialog();
                        },
                        leading: Icon(Icons.remove_circle_outline),
                        title: Text(
                          'Remove',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          addToDeptMember();
                        },
                        leading: Icon(Icons.work_outline),
                        title: Text(
                          'Assign member',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          addToDeptAdmin();
                        },
                        leading: Icon(Icons.admin_panel_settings_outlined),
                        title: Text(
                          'Assign admin',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ));
            }),
          );
        }));
  }

  addToDeptAdmin() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                  content: Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentDept = null;
                        });
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select department',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.gid)
                                .collection('departments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                    child: const CircularProgressIndicator());
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: DropdownButton(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      value: _currentDept,
                                      isDense: true,
                                      items: snapshot.data.docs
                                          .map((DocumentSnapshot doc) {
                                        return DropdownMenuItem(
                                            value: doc['uid'],
                                            child: Text(
                                              doc['departmentName'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: FontNameDefault,
                                                  fontSize:
                                                      textSubTitle(context)),
                                            ));
                                      }).toList(),
                                      hint: Text(
                                        'Department',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                      onChanged: (val) async {
                                        setState(() {
                                          _currentDept = val;
                                        });
                                        if (_currentDept != null) {
                                          Department department =
                                              await _repository
                                                  .fetchDepartmentDetailsById(
                                                      widget.gid, _currentDept);
                                          if (!mounted) return;
                                          setState(() {
                                            _department = department;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  _currentDept != null
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: screenSize.height * 0.015,
                                            horizontal: screenSize.width * 0.01,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              _repository.addDeptAdmin(
                                                  currentDeptColor:
                                                      _department.color,
                                                  currentDeptName: _department
                                                      .departmentName,
                                                  currentDeptProfile: _department
                                                      .departmentProfilePhoto,
                                                  currentDeptDesc:
                                                      _department.description,
                                                  currentTeam: widget.team,
                                                  currentDeptId: _currentDept,
                                                  followerId:
                                                      widget.documentSnapshot[
                                                          'ownerUid'],
                                                  followerName:
                                                      widget.documentSnapshot[
                                                          'ownerName'],
                                                  followerAccountType: 'Admin',
                                                  followerPhotoUrl:
                                                      widget.documentSnapshot[
                                                          'ownerPhotoUrl']);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: screenSize.height * 0.055,
                                              width: screenSize.width * 0.4,
                                              child: Center(
                                                child: Text(
                                                  'Add admin',
                                                  style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    color: Colors.white,
                                                    fontSize:
                                                        textSubTitle(context),
                                                  ),
                                                ),
                                              ),
                                              decoration: ShapeDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: screenSize.height * 0.015,
                                            horizontal: screenSize.width * 0.01,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: screenSize.height * 0.055,
                                              width: screenSize.width * 0.4,
                                              child: Center(
                                                child: Text(
                                                  'Add admin',
                                                  style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    color: Colors.grey[600],
                                                    fontSize:
                                                        textSubTitle(context),
                                                  ),
                                                ),
                                              ),
                                              decoration: ShapeDecoration(
                                                color: Colors.grey[100],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  side: BorderSide(
                                                      width: 0.2,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              );
                            },
                          )),
                    ],
                  )
                ],
              ));
            }),
          );
        }));
  }

  deleteDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              //    overflow: Overflow.visible,
              children: [
                Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Remove member',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textHeader(context),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: screenSize.height * 0.09,
                        child: Text(
                          'Are you sure you want to remove this member from team?',
                          style: TextStyle(color: Colors.black54),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _repository
                                  .removeTeamMember(
                                      currentTeam: widget.team,
                                      followerId:
                                          widget.documentSnapshot['ownerUid'])
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.015,
                            horizontal: screenSize.width * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }));
  }

  addToDeptMember() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                  content: Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentDept = null;
                        });
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select department',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.gid)
                                .collection('departments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                    child: const CircularProgressIndicator());
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: DropdownButton(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      value: _currentDept,
                                      isDense: true,
                                      items: snapshot.data.docs
                                          .map((DocumentSnapshot doc) {
                                        return DropdownMenuItem(
                                            value: doc['uid'],
                                            child: Text(
                                              doc['departmentName'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: FontNameDefault,
                                                  fontSize:
                                                      textSubTitle(context)),
                                            ));
                                      }).toList(),
                                      hint: Text(
                                        'Department',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context)),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          _currentDept = val;
                                        });
                                      },
                                    ),
                                  ),
                                  _currentDept != null
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: screenSize.height * 0.015,
                                            horizontal: screenSize.width * 0.01,
                                          ),
                                          child: GestureDetector(
                                              onTap: () {
                                                _repository.addDeptMember(
                                                    currentTeam: widget.team,
                                                    currentDeptId: _currentDept,
                                                    followerId:
                                                        widget.documentSnapshot[
                                                            'ownerUid'],
                                                    followerName:
                                                        widget.documentSnapshot[
                                                            'ownerName'],
                                                    followerAccountType:
                                                        'Member',
                                                    followerPhotoUrl:
                                                        widget.documentSnapshot[
                                                            'ownerPhotoUrl']);
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height:
                                                    screenSize.height * 0.055,
                                                width: screenSize.width * 0.4,
                                                child: Center(
                                                  child: Text(
                                                    'Add member',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontNameDefault,
                                                      color: Colors.white,
                                                      fontSize:
                                                          textSubTitle(context),
                                                    ),
                                                  ),
                                                ),
                                                decoration: ShapeDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                ),
                                              )),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: screenSize.height * 0.015,
                                            horizontal: screenSize.width * 0.01,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: screenSize.height * 0.055,
                                              width: screenSize.width * 0.4,
                                              child: Center(
                                                child: Text(
                                                  'Add member',
                                                  style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    color: Colors.grey[600],
                                                    fontSize:
                                                        textSubTitle(context),
                                                  ),
                                                ),
                                              ),
                                              decoration: ShapeDecoration(
                                                color: Colors.grey[100],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  side: BorderSide(
                                                      width: 0.2,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              );
                            },
                          )),
                    ],
                  )
                ],
              ));
            }),
          );
        }));
  }

  // addMember(DocumentSnapshot snapshot) {
  //   _repository.addTeamMember(
  //       currentTeam: widget.team,
  //       followerId: snapshot.data['ownerUid'],
  //       followerName: snapshot.data['ownerName'],
  //       followerAccountType: widget.team.teamName + 'Member',
  //       followerPhotoUrl: snapshot.data['ownerPhotoUrl']);
  //   addInviteToActivityFeed();
  // }

  inviteUser() {
    print('User Invited');
    _repository.inviteUser(
        currentGroupId: widget.gid,
        followingUserId: widget.documentSnapshot['ownerUid']);
    addInviteToActivityFeed();
  }

  void addInviteToActivityFeed() {
    if (widget.group != null) {
      var _feed = Feed(
        ownerName: widget.currentuser.displayName,
        ownerUid: widget.currentuser.uid,
        type: 'team invite',
        ownerPhotoUrl: widget.currentuser.photoUrl,
        gid: widget.group.uid,
        gname: widget.group.groupName,
        groupProfilePhoto: widget.group.groupProfilePhoto,
        timestamp: FieldValue.serverTimestamp(),
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.documentSnapshot['ownerUid'])
          .collection('requests')
          // .document(currentUser.uid)
          // .collection('likes')
          .doc(widget.currentuser.uid)
          .set(_feed.toMap(_feed))
          .then((value) {
        print('Team Invite sent');
      });
    } else {
      var _feed = Feed(
        ownerName: widget.currentuser.displayName,
        ownerUid: widget.currentuser.uid,
        type: 'team invite',
        ownerPhotoUrl: widget.currentuser.photoUrl,
        gid: widget.team.uid,
        gname: widget.team.teamName,
        groupProfilePhoto: widget.team.teamProfilePhoto,
        timestamp: FieldValue.serverTimestamp(),
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.documentSnapshot['ownerUid'])
          .collection('requests')
          // .document(currentUser.uid)
          // .collection('likes')
          .doc(widget.currentuser.uid)
          .set(_feed.toMap(_feed))
          .then((value) {
        print('Team Invite sent');
      });
    }
  }

  deleteInvite() {
    print('Invite deleted');
    _repository.deleteInvite(
        currentGroupId: widget.gid,
        followingUserId: widget.documentSnapshot['ownerUid']);
    removeInviteToActivityFeed();
  }

  void removeInviteToActivityFeed() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.documentSnapshot['ownerUid'])
        .collection('requests')
        // .document(currentUser.uid)
        // .collection('likes')
        .doc(widget.currentuser.uid)
        .delete()
        .then((value) {
      print('Group Invite sent');
    });
  }
}
