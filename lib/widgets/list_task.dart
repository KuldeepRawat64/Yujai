import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/event_detail_page.dart';
import 'package:Yujai/pages/task_detail.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../style.dart';

class ListItemTask extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final DocumentSnapshot documentSnapshotList;
  final UserModel user, currentuser;
  final int index;
  final String gid;
  final String name;
  final bool isMember;
  final Team team;
  final Department department;
  final Project project;
  final List<Member> memberlist;

  ListItemTask({
    this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
    this.gid,
    this.name,
    this.isMember,
    this.team,
    this.department,
    this.project,
    this.documentSnapshotList,
    this.memberlist,
  });

  @override
  _ListItemTaskState createState() => _ListItemTaskState();
}

class _ListItemTaskState extends State<ListItemTask> {
  bool showFab = true;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskDetail(
                      department: widget.department,
                      memberlist: widget.memberlist,
                      project: widget.project,
                      user: widget.currentuser,
                      currentuser: widget.currentuser,
                      documentSnapshot: widget.documentSnapshot,
                      teamId: widget.team.uid,
                      deptId: widget.department.uid,
                      projectId: widget.project.uid,
                      listId: widget.documentSnapshotList['listId'],
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: ShapeDecoration(
            color: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              //side: BorderSide(color: Colors.grey[300])
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: widget.documentSnapshot['isCompleted'] ==
                                        null ||
                                    widget.documentSnapshot['isCompleted'] ==
                                        false
                                ? Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.grey,
                                  )
                                : Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                            onPressed: () {
                              if (widget.documentSnapshot['isCompleted'] ==
                                      null ||
                                  widget.documentSnapshot['isCompleted'] ==
                                      false) {
                                FirebaseFirestore.instance
                                    .collection('teams')
                                    .doc(widget.team.uid)
                                    .collection('departments')
                                    .doc(widget.department.uid)
                                    .collection('projects')
                                    .doc(widget.project.uid)
                                    .collection('list')
                                    .doc(widget.documentSnapshotList['listId'])
                                    .collection('tasks')
                                    .doc(widget.documentSnapshot['taskId'])
                                    .update({'isCompleted': true});
                              } else {
                                FirebaseFirestore.instance
                                    .collection('teams')
                                    .doc(widget.team.uid)
                                    .collection('departments')
                                    .doc(widget.department.uid)
                                    .collection('projects')
                                    .doc(widget.project.uid)
                                    .collection('list')
                                    .doc(widget.documentSnapshotList['listId'])
                                    .collection('tasks')
                                    .doc(widget.documentSnapshot['taskId'])
                                    .update({'isCompleted': false});
                              }
                            }),
                        Container(
                          width: screenSize.width * 0.5,
                          child: Text(
                            widget.documentSnapshot['taskName'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: screenSize.width * 0.1,
                      height: screenSize.height * 0.06,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          //   side: BorderSide(color: Colors.grey[200]),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _showTaskEditDialog(widget.documentSnapshot,
                              widget.documentSnapshotList);
                          //  deletePost(widget.documentSnapshot);
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.035,
                    ),
                    InkWell(
                      onTap: () {
                        _showAssignedDialog();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: screenSize.height * 0.016,
                        backgroundImage:
                            widget.documentSnapshot['assignedPhoto'] != '' &&
                                    widget.documentSnapshot['assignedPhoto'] !=
                                        null
                                ? CachedNetworkImageProvider(
                                    widget.documentSnapshot['assignedPhoto'])
                                : AssetImage('assets/images/no_image.png'),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.035,
                    ),
                    widget.documentSnapshot['dueDateRangeStart'] != null &&
                            widget.documentSnapshot['dueDateRangeStart'] != ''
                        ? Text(
                            '${widget.documentSnapshot['dueDateRangeStart']} - ${widget.documentSnapshot['dueDateRangeEnd']}',
                            style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.grey),
                          )
                        : Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                            size: screenSize.height * 0.03,
                          )
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.005,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showAssignedDialog() async {
    var screenSize = MediaQuery.of(context).size;
    return await showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: ((BuildContext context, setState) {
            return AlertDialog(
              content: SizedBox(
                height: screenSize.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assignee',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('teams')
                            .doc(widget.team.uid)
                            .collection('departments')
                            .doc(widget.department.uid)
                            .collection('projects')
                            .doc(widget.project.uid)
                            .collection('members')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data.docs.length > 0) {
                            return Container(
                              height: screenSize.height * 0.3,
                              width: screenSize.width * 0.8,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  //   scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('teams')
                                            .doc(widget.team.uid)
                                            .collection('departments')
                                            .doc(widget.department.uid)
                                            .collection('projects')
                                            .doc(widget.project.uid)
                                            .collection('list')
                                            .doc(widget
                                                .documentSnapshotList['listId'])
                                            .collection('tasks')
                                            .doc(widget
                                                .documentSnapshot['taskId'])
                                            .update({
                                          'assigned': snapshot.data.docs[index]
                                              ['ownerUid'],
                                          'assignedName': snapshot
                                              .data.docs[index]['ownerName'],
                                          'assignedEmail': snapshot
                                              .data.docs[index]['ownerEmail'],
                                          'assignedPhoto': snapshot
                                              .data.docs[index]['ownerPhotoUrl']
                                        }).then((value) {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            radius: screenSize.height * 0.02,
                                            backgroundImage: snapshot.data
                                                                .docs[index]
                                                            ['ownerPhotoUrl'] !=
                                                        '' &&
                                                    snapshot.data.docs[index]
                                                            ['ownerPhotoUrl'] !=
                                                        null
                                                ? NetworkImage(
                                                    snapshot.data.docs[index]
                                                        ['ownerPhotoUrl'])
                                                : AssetImage(
                                                    'assets/images/no_image.png'),
                                          ),
                                          title: Text(
                                            snapshot.data.docs[index]
                                                ['ownerName'],
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textSubTitle(context),
                                            ),
                                          ),
                                          subtitle: Text(
                                            snapshot.data.docs[index]
                                                ['ownerEmail'],
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context),
                                            ),
                                          )),
                                    );
                                  }),
                            );
                          } else {
                            return NoContent(
                                'No members',
                                'assets/images/members.png',
                                'Add members to this project first',
                                '');
                          }
                        }),
                      ),
                    )
                  ],
                ),
              ),
            );
          }));
        }));
  }

  _showTaskEditDialog(
      DocumentSnapshot snapshot, DocumentSnapshot listSnapshot) {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.01),
                      child: Text(
                        'Edit task',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetail(
                                department: widget.department,
                                memberlist: widget.memberlist,
                                user: widget.currentuser,
                                currentuser: widget.currentuser,
                                documentSnapshot: snapshot,
                                teamId: widget.team.uid,
                                deptId: widget.department.uid,
                                projectId: widget.project.uid,
                                listId: listSnapshot['listId'],
                              ))).then((value) => Navigator.pop(context));
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.01),
                      child: Text(
                        'Delete task',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  deletePost(widget.documentSnapshot);
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.cancel_outlined),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.01),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  deletePost(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('teams')
        .doc(widget.team.uid)
        .collection('departments')
        .doc(widget.department.uid)
        .collection('projects')
        .doc(widget.project.uid)
        .collection('list')
        .doc(widget.documentSnapshotList['listId'])
        .collection('tasks')
        .doc(snapshot['taskId'])
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        Navigator.pop(context);
        print('post deleted');
      } else {
        return print('not owner');
      }
    });
  }
}
