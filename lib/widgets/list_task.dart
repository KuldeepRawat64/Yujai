import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/event_detail_page.dart';
import 'package:Yujai/pages/task_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../style.dart';

class ListItemTask extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final DocumentSnapshot documentSnapshotList;
  final User user, currentuser;
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
                      listId: widget.documentSnapshotList.data['listId'],
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
                            icon: widget.documentSnapshot.data['isCompleted'] ==
                                        null ||
                                    widget.documentSnapshot
                                            .data['isCompleted'] ==
                                        false
                                ? Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.grey,
                                  )
                                : Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                            onPressed: () {}),
                        Text(
                          widget.documentSnapshot['taskName'],
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
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
                        backgroundImage: widget.documentSnapshot
                                        .data['assignedPhoto'] !=
                                    '' &&
                                widget.documentSnapshot.data['assignedPhoto'] !=
                                    null
                            ? CachedNetworkImageProvider(
                                widget.documentSnapshot.data['assignedPhoto'])
                            : AssetImage('assets/images/no_image.png'),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.035,
                    ),
                    widget.documentSnapshot.data['dueDateRangeStart'] != null &&
                            widget.documentSnapshot.data['dueDateRangeStart'] !=
                                ''
                        ? Text(
                            '${widget.documentSnapshot.data['dueDateRangeStart']} - ${widget.documentSnapshot.data['dueDateRangeEnd']}',
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
                        stream: Firestore.instance
                            .collection('teams')
                            .document(widget.team.uid)
                            .collection('departments')
                            .document(widget.department.uid)
                            .collection('projects')
                            .document(widget.project.uid)
                            .collection('members')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: screenSize.height * 0.3,
                              width: screenSize.width * 0.8,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  //   scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        Firestore.instance
                                            .collection('teams')
                                            .document(widget.team.uid)
                                            .collection('departments')
                                            .document(widget.department.uid)
                                            .collection('projects')
                                            .document(widget.project.uid)
                                            .collection('list')
                                            .document(widget
                                                .documentSnapshotList
                                                .data['listId'])
                                            .collection('tasks')
                                            .document(widget.documentSnapshot
                                                .data['taskId'])
                                            .updateData({
                                          'assigned': snapshot
                                              .data
                                              .documents[index]
                                              .data['ownerUid'],
                                          'assignedName': snapshot
                                              .data
                                              .documents[index]
                                              .data['ownerName'],
                                          'assignedEmail': snapshot
                                              .data
                                              .documents[index]
                                              .data['ownerEmail'],
                                          'assignedPhoto': snapshot
                                              .data
                                              .documents[index]
                                              .data['ownerPhotoUrl']
                                        }).then((value) {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            radius: screenSize.height * 0.02,
                                            backgroundImage: snapshot
                                                                .data
                                                                .documents[index]
                                                                .data[
                                                            'ownerPhotoUrl'] !=
                                                        '' &&
                                                    snapshot
                                                                .data
                                                                .documents[index]
                                                                .data[
                                                            'ownerPhotoUrl'] !=
                                                        null
                                                ? NetworkImage(snapshot
                                                    .data
                                                    .documents[index]
                                                    .data['ownerPhotoUrl'])
                                                : AssetImage(
                                                    'assets/images/no_image.png'),
                                          ),
                                          title: Text(
                                            snapshot.data.documents[index]
                                                .data['ownerName'],
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textSubTitle(context),
                                            ),
                                          ),
                                          subtitle: Text(
                                            snapshot.data.documents[index]
                                                .data['ownerEmail'],
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context),
                                            ),
                                          )),
                                    );
                                  }),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
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
                                listId: listSnapshot.data['listId'],
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
    Firestore.instance
        .collection('teams')
        .document(widget.team.uid)
        .collection('departments')
        .document(widget.department.uid)
        .collection('projects')
        .document(widget.project.uid)
        .collection('list')
        .document(widget.documentSnapshotList.data['listId'])
        .collection('tasks')
        .document(snapshot.data['taskId'])
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
