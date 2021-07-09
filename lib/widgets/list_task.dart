import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/event_detail_page.dart';
import 'package:Yujai/pages/task_detail.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  var _currentList;
  var _repository = Repository();
  final _formKey = GlobalKey<FormState>();

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
                  Navigator.pop(context);
                  deletePost(widget.documentSnapshot);
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.drive_file_move_outlined),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.01),
                      child: Text(
                        'Move task',
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
                  _moveTaskDialog();
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

  _moveTaskDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
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
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Select List',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textHeader(context)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.team.uid)
                                .collection('departments')
                                .doc(widget.department.uid)
                                .collection('projects')
                                .doc(widget.project.uid)
                                .collection('list')
                                .where('listId',
                                    isNotEqualTo:
                                        widget.documentSnapshotList['listId'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return const Center(
                                  child: const CircularProgressIndicator(),
                                );

                              return Container(
                                padding: EdgeInsets.all(5),
                                child: new DropdownButton(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  value: _currentList,
                                  isDense: true,
                                  items: snapshot.data.docs
                                      .map((DocumentSnapshot doc) {
                                    return new DropdownMenuItem(
                                        value: doc["listId"],
                                        child: Text(doc["listName"],
                                            style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textSubTitle(context),
                                            )));
                                  }).toList(),
                                  hint: Text("list",
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                      )),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentList = value;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        _currentList != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width * 0.01,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pop(context);
                                    _repository
                                        .getCurrentUser()
                                        .then((currentuser) {
                                      if (currentuser != null) {
                                        _repository
                                            .retreiveUserDetails(currentuser)
                                            .then((user) {
                                          _repository
                                              .addTaskToList(
                                                  widget.documentSnapshot[
                                                      'taskId'],
                                                  user,
                                                  widget.documentSnapshot[
                                                      'taskName'],
                                                  widget.documentSnapshot[
                                                      'description'],
                                                  widget.team.uid,
                                                  widget.department.uid,
                                                  widget.project.uid,
                                                  _currentList)
                                              .then((value) async {
                                            List<DocumentSnapshot> uidList =
                                                List<DocumentSnapshot>();
                                            QuerySnapshot<Map<String, dynamic>>
                                                commentSnapshot = await widget
                                                    .documentSnapshot.reference
                                                    .collection('comments')
                                                    .get();
                                            for (var i = 0;
                                                i < commentSnapshot.docs.length;
                                                i++) {
                                              uidList
                                                  .add(commentSnapshot.docs[i]);
                                            }
                                            print(
                                                'Comments LIST : ${uidList.length}');

                                            if (uidList.isNotEmpty) {
                                              FirebaseFirestore.instance
                                                  .collection('teams')
                                                  .doc(widget.team.uid)
                                                  .collection('departments')
                                                  .doc(widget.department.uid)
                                                  .collection('projects')
                                                  .doc(widget.project.uid)
                                                  .collection('list')
                                                  .doc(_currentList)
                                                  .collection('tasks')
                                                  .doc(widget.documentSnapshot[
                                                      'taskId'])
                                                  .collection('comments')
                                                  .add(uidList.first.data());
                                            }
                                            deletePost(widget.documentSnapshot);
                                            //  commentSnapshot.docs;

                                            print('Task moved to another list');
                                            Navigator.pop(context);
                                          }).catchError((e) => print(
                                                  'Error adding task: $e'));
                                        });
                                      } else {
                                        print('Current User is null');
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width * 0.4,
                                    child: Center(
                                      child: Text(
                                        'Move task',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
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
                                        'Move task',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.grey[600],
                                          fontSize: textSubTitle(context),
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.grey[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            width: 0.2, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
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
        doc.reference.collection('comments').get().then((docs) {
          docs.docs.forEach((element) {
            doc.reference
                .collection('comments')
                .doc(element.id)
                .delete()
                .then((value) => print('comments deleted'));
          });
        });
        //  Navigator.pop(context);
        print('post deleted');
      } else {
        return print('not owner');
      }
    });
  }

  // movePost(DocumentSnapshot snapshot) {
  //   FirebaseFirestore.instance
  //       .collection('teams')
  //       .doc(widget.team.uid)
  //       .collection('departments')
  //       .doc(widget.department.uid)
  //       .collection('projects')
  //       .doc(widget.project.uid)
  //       .collection('list')
  //       .doc(widget.documentSnapshotList['listId'])
  //       .collection('tasks')
  //       .doc(snapshot['taskId'])
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //       //  Navigator.pop(context);
  //       print('post deleted');
  //     } else {
  //       return print('not owner');
  //     }
  //   });
  // }
}
