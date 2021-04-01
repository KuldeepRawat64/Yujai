import 'dart:math';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/team_feed.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/event_detail_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/list_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

import '../style.dart';

class ListItemTaskList extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;
  final int index;
  final String gid;
  final String name;
  final bool isMember;
  final Team team;
  final Department department;
  final Project project;
  final List<Member> memberlist;

  ListItemTaskList({
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
    this.memberlist,
  });

  @override
  _ListItemTaskListState createState() => _ListItemTaskListState();
}

class _ListItemTaskListState extends State<ListItemTaskList> {
  var _repository = Repository();
  TextEditingController _listNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String newListId = Uuid().v4();
  bool valueFirst = false;
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  String newTaskId = Uuid().v4();
  String actId = Uuid().v4();
  Color currentColor = Colors.deepPurple;
  void changeColor(Color color) => setState(() => currentColor = color);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width * 0.8,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: Color(
                    widget.documentSnapshot.data['color'],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    widget.documentSnapshot.data['listName'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.white),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _showListEditDialog();
                      //   deletePost(widget.documentSnapshot);
                    },
                    icon: Icon(Icons.more_horiz),
                    color: Colors.grey,
                  ),
                  IconButton(
                      onPressed: () {
                        _showAddDialog();
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.grey,
                      )),
                ],
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: widget.documentSnapshot.reference
                  .collection('tasks')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: ((context, listSnapshot) {
                if (widget.documentSnapshot != null && listSnapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: listSnapshot.data.documents.length,
                      itemBuilder: ((context, index) => ListItemTask(
                            documentSnapshotList: widget.documentSnapshot,
                            team: widget.team,
                            department: widget.department,
                            project: widget.project,
                            documentSnapshot:
                                listSnapshot.data.documents[index],
                            user: widget.currentuser,
                            currentuser: widget.currentuser,
                          )));
                } else {
                  return Container();
                }
              })),
        ],
      ),
    );
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
        // .delete();
        .document(snapshot.data['listId'])
        // .delete();
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

  _showAddDialog() {
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
                    Icon(Icons.check_circle_outline),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.01),
                      child: Text(
                        'Create task',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  _showFormDialog(widget.documentSnapshot)
                      .then((val) => Navigator.pop(context));
                },
              ),
              SimpleDialogOption(
                child: Row(
                  children: [
                    Icon(Icons.list_outlined),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.01),
                      child: Text(
                        'Create list',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  _showListDialog().then((val) => Navigator.pop(context));
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
                          fontSize: textSubTitle(context),
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

  _showListEditDialog() {
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
                    Icon(Icons.delete_outline),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.01),
                      child: Text(
                        'Delete list',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
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
                    CircleAvatar(
                      radius: screenSize.height * 0.015,
                      backgroundColor:
                          Color(widget.documentSnapshot.data['color']),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width * 0.01),
                      child: Text(
                        'Change color',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Select a color',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: Color(
                              widget.documentSnapshot.data['color'],
                            ),
                            onColorChanged: (Color color) {
                              Firestore.instance
                                  .collection('teams')
                                  .document(widget.team.uid)
                                  .collection('departments')
                                  .document(widget.department.uid)
                                  .collection('projects')
                                  .document(widget.project.uid)
                                  .collection('list')
                                  // .delete();
                                  .document(
                                      widget.documentSnapshot.data['listId'])
                                  .updateData({'color': color.value})
                                  .then((value) => Navigator.pop(context))
                                  .then((value) => Navigator.pop(context));
                            },
                          ),
                        ),
                      );
                    },
                  );
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
                          fontSize: textSubTitle(context),
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

  _showListDialog() {
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
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'New List',
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
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'List name',
                            ),
                            onChanged: (val) {
                              if (_listNameController.text.isNotEmpty) {
                                setState(() {
                                  valueFirst = true;
                                });
                              } else {
                                setState(() {
                                  valueFirst = false;
                                });
                              }
                            },
                            controller: _listNameController,
                          ),
                        ),
                        valueFirst
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
                                              .addListToProject(
                                                  newListId,
                                                  user,
                                                  _listNameController.text,
                                                  widget.team.uid,
                                                  widget.department.uid,
                                                  widget.project.uid,
                                                  Colors
                                                      .primaries[Random()
                                                          .nextInt(Colors
                                                              .primaries
                                                              .length)]
                                                      .value)
                                              .then((value) {
                                            newListId = Uuid().v4();
                                            _listNameController.text = '';
                                            valueFirst = false;
                                            print('List added to project');
                                            Navigator.pop(context);
                                          }).catchError((e) => print(
                                                  'Error adding list: $e'));
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
                                        'Create list',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: FontNameDefault,
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
                                        'Create list',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: FontNameDefault,
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

  _showFormDialog(DocumentSnapshot snapshot) {
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
                    child: Wrap(
                      // mainAxisSize: MainAxisSize.max,
                      //  crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'New Task',
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
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Task name',
                            ),
                            onChanged: (val) {
                              if (_taskNameController.text.isNotEmpty) {
                                setState(() {
                                  valueFirst = true;
                                });
                              } else {
                                setState(() {
                                  valueFirst = false;
                                });
                              }
                            },
                            controller: _taskNameController,
                          ),
                        ),
                        Container(
                          child: TextField(
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                            ),
                            minLines: 1,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Description',
                            ),
                            // onChanged: (val) {
                            //   if (_taskDescriptionController.text.isNotEmpty) {
                            //     setState(() {
                            //       valueFirst = true;
                            //     });
                            //   } else {
                            //     setState(() {
                            //       valueFirst = false;
                            //     });
                            //   }
                            // },
                            controller: _taskDescriptionController,
                          ),
                        ),
                        valueFirst
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
                                                  newTaskId,
                                                  user,
                                                  _taskNameController.text,
                                                  _taskDescriptionController.text,
                                                  widget.team.uid,
                                                  widget.department.uid,
                                                  widget.project.uid,
                                                  snapshot.data['listId'])
                                              .then((value) {
                                            newTaskId = Uuid().v4();
                                            _taskNameController.text = '';
                                            _taskDescriptionController.text =
                                                '';
                                            valueFirst = false;
                                            print('Task added to list');
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
                                        'Create task',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: FontNameDefault,
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
                                        'Create task',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: FontNameDefault,
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
    void addInbox(String type, User currentUser) {
    // bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (currentUser.uid == widget.team.currentUserUid) {
      return print('Owner liked');
    } else {
      var _feed = TeamFeed(
        assigned: [widget.team.currentUserUid],
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        type:type,
        ownerPhotoUrl: currentUser.photoUrl,
        imgUrl: '',
        postId: actId,
        timestamp: FieldValue.serverTimestamp(),
        commentData: '',
      );
      Firestore.instance
          .collection('teams')
          .document(widget.gid)
          .collection('inbox')
          // .document(currentUser.uid)
          // .collection('likes')
          .document(actId)
          .setData(_feed.toMap(_feed))
          .then((value) {
        print('Inbox added');
      });
    }
  }
}
