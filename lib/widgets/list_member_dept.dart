import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/team_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class ListItemMemberDept extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final UserModel user, currentuser;
  final int index;
  final String gid;
  final String name;
  final Group group;
  final Team team;
  final Department dept;
  ListItemMemberDept({
    this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
    this.gid,
    this.name,
    this.group,
    this.team,
    this.dept,
  });

  @override
  _ListItemMemberDeptState createState() => _ListItemMemberDeptState();
}

class _ListItemMemberDeptState extends State<ListItemMemberDept> {
  var _repository = Repository();

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
    _repository
        .checkIsMember(widget.documentSnapshot.data()['ownerUid'], widget.gid,
            widget.group != null ? true : false)
        .then((value) {
      print("value:$value");
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
              widget.documentSnapshot.data()['accountType'],
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
              ),
            ),
            title: Text(
              widget.documentSnapshot.data()['ownerName'],
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textSubTitle(context),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  widget.documentSnapshot.data()['ownerPhotoUrl']),
            ),
            trailing: widget.currentuser.uid == widget.team.currentUserUid ||
                    widget.currentuser.uid == widget.dept.currentUserUid ||
                    widget.currentuser.uid ==
                        widget.documentSnapshot.data()['ownerUid']
                ? widget.team.currentUserUid !=
                        widget.documentSnapshot.data()['ownerUid']
                    ? InkWell(
                        onTap: () {
                          optionDept();
                        },
                        child: Icon(Icons.more_vert,
                            color: Theme.of(context).primaryColorLight,
                            size: screenSize.height * 0.035),
                      )
                    : Text('')
                : Text(''),
          )),
    );
  }

  optionDept() {
    return showDialog(
        context: context,
        builder: ((context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                  content: Stack(
                clipBehavior: Clip.none,
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
                  widget.currentuser.uid == widget.team.currentUserUid ||
                          widget.documentSnapshot.data()['ownerUid'] ==
                              widget.dept.currentUserUid
                      ? Column(mainAxisSize: MainAxisSize.min, children: [
                          ListTile(
                            onTap: () {
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
                            },
                            leading: Icon(Icons.cancel_outlined),
                            title: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          )
                        ])
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {
                                leaveDialog();
                              },
                              leading: Icon(Icons.remove_circle_outline),
                              title: Text(
                                'Leave',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              leading: Icon(Icons.cancel_outlined),
                              title: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                            ),
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
                          'Are you sure you want to remove this member from department?',
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

  leaveDialog() {
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
                            'Leave department',
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
                          'Are you sure you want to leave this department?',
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TeamPage()));
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

  addMember(DocumentSnapshot snapshot) {
    _repository.addTeamMember(
        currentTeam: widget.team,
        followerId: snapshot['ownerUid'],
        followerName: snapshot['ownerName'],
        //  followerAccountType: widget.team.teamName + 'Member',
        followerPhotoUrl: snapshot['ownerPhotoUrl']);
    addInviteToActivityFeed();
  }

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
