import 'dart:io';
import 'dart:math';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:image/image.dart' as Im;
import 'package:Yujai/models/comment.dart';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;

class TaskDetail extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final UserModel user, currentuser;
  final String teamId, deptId, projectId, listId;
  final Project project;
  final Department department;
  final List<Member> memberlist;

  TaskDetail({
    this.documentSnapshot,
    this.user,
    this.currentuser,
    this.teamId,
    this.deptId,
    this.projectId,
    this.listId,
    this.project,
    this.memberlist,
    this.department,
  });

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

GlobalKey myFormKey = new GlobalKey();

class _TaskDetailState extends State<TaskDetail> {
  var _repository = Repository();
  bool isTapped = false;
  int counter = 0;
  ScrollController _scrollController;
  //Offset state <-------------------------------------
  double offset = 0.0;
  bool _isEditingText = false;
  bool _isEditingDesc = false;
  bool _isEditingDate = false;
  TextEditingController _taskNameController;
  String initialText = "Initial Text";
  TextEditingController _descriptionController;
  TextEditingController _commentTextController;
  String initialDescription = "Initial Text";
  DateTimeRange myDateRange;
  String inputString = "";
  TextFormField input;
  List<Member> memberlist;
  File imageFile;
  String postId = Uuid().v4();
  String imgurl = '';

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
    _taskNameController =
        TextEditingController(text: widget.documentSnapshot['taskName'] ?? '');
    _descriptionController = TextEditingController(
        text: widget.documentSnapshot['description'] ?? '');
    _commentTextController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          decoration:
              InputDecoration(filled: true, fillColor: const Color(0xffffffff)),
          style: TextStyle(
              fontFamily: FontNameDefault, fontSize: textHeader(context)),
          onChanged: (newValue) {
            if (_taskNameController.text.isNotEmpty)
              widget.documentSnapshot.reference.update({'taskName': newValue});
          },
          onSubmitted: (newValue) {
            if (_taskNameController.text.isNotEmpty)
              widget.documentSnapshot.reference.update({'taskName': newValue});
            setState(() {
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _taskNameController,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream: widget.documentSnapshot.reference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: snapshot.data['taskName'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textHeader(context),
                ),
              );
            //  Text(
            //   snapshot.data['taskName'],
            //   style: TextStyle(
            //     fontFamily: FontNameDefault,
            //     fontWeight: FontWeight.bold,
            //     fontSize: textHeader(context),
            //   ),
            // );
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _editAssignedMember() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: widget.documentSnapshot.reference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return TextButton(
              onPressed: () {
                _showAssignedDialog();
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: screenSize.height * 0.02,
                    backgroundImage: snapshot.data['assignedPhoto'] != '' &&
                            snapshot.data['assignedPhoto'] != null
                        ? NetworkImage(snapshot.data['assignedPhoto'])
                        : AssetImage('assets/images/no_image.png'),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.01,
                  ),
                  Text(
                    snapshot.data['assignedName'] != '' &&
                            snapshot.data['assignedName'] != null
                        ? snapshot.data['assignedName']
                        : 'Unassigned',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width * 0.01,
                  ),
                  snapshot.data['assignedName'] != ''
                      ? InkWell(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('teams')
                                .doc(widget.teamId)
                                .collection('departments')
                                .doc(widget.department.uid)
                                .collection('projects')
                                .doc(widget.project.uid)
                                .collection('list')
                                .doc(widget.listId)
                                .collection('tasks')
                                .doc(snapshot.data['taskId'])
                                .update({
                              'assigned': '',
                              'assignedName': '',
                              'assignedEmail': '',
                              'assignedPhoto': ''
                            });
                          },
                          child: snapshot.data['assignedName'] != '' &&
                                  snapshot.data['assignedName'] != null
                              ? Icon(Icons.cancel_outlined)
                              : Text(''))
                      : Container()
                ],
              ),
            );
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _editDescTextField() {
    if (_isEditingDesc)
      return Expanded(
        child: TextField(
          decoration:
              InputDecoration(filled: true, fillColor: const Color(0xffffffff)),
          style: TextStyle(
              fontFamily: FontNameDefault, fontSize: textBody1(context)),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 3,
          onChanged: (newValue) {
            if (_taskNameController.text.isNotEmpty)
              widget.documentSnapshot.reference
                  .update({'description': newValue});
          },
          onSubmitted: (newValue) {
            if (_taskNameController.text.isNotEmpty)
              widget.documentSnapshot.reference
                  .update({'description': newValue});
            setState(() {
              _isEditingDesc = false;
            });
          },
          autofocus: true,
          controller: _descriptionController,
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingDesc = true;
        });
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream: widget.documentSnapshot.reference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: snapshot.data['description'] != '' &&
                        snapshot.data['description'] != null
                    ? snapshot.data['description']
                    : 'Add description',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.black,
                  fontSize: textBody1(context),
                ),
              );
            //  Text(
            //   snapshot.data['description'] != '' &&
            //           snapshot.data['description'] != null
            //       ? snapshot.data['description']
            //       : 'Add description',
            //   style: TextStyle(
            //     fontFamily: FontNameDefault,
            //     color: Colors.black,
            //     fontSize: textBody1(context),
            //   ),
            // );
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _editDateRangeTextField() {
    var screenSize = MediaQuery.of(context).size;
    if (_isEditingDate)
      return Expanded(
        child: Container(
          height: screenSize.height * 0.13,
          child: DateRangeField(
            dateFormat: DateFormat.MMMd(),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffffffff),
              suffixIcon: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                    setState(() {
                      _isEditingDate = false;
                    });
                  }),
              contentPadding: EdgeInsets.all(screenSize.height * 0.005),
              labelText: 'Date Range',
              prefixIcon: Icon(Icons.date_range_outlined),
              hintText: 'Please select a start and end date',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            initialValue:
                DateTimeRange(start: DateTime.now(), end: DateTime.now()),
            validator: (value) {
              if (value.start.isBefore(DateTime.now())) {
                return 'Please enter a valid date';
              }
              return null;
            },
            autoValidate: true,
            onChanged: (value) {
              widget.documentSnapshot.reference.update({
                'dueDateRangeStart': DateFormat.MMMd().format(value.start),
                'dueDateRangeEnd': DateFormat.MMMd().format(value.end)
                //'${value.start.month.toString() } / ${ value.start.day.toString()} - ${value.end.month.toString() } / ${ value.end.day.toString()}'
              });
              setState(() {
                myDateRange = value;
              });
            },
          ),
        ),
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingDate = true;
        });
      },
      child: widget.documentSnapshot['dueDateRangeStart'] != '' &&
              widget.documentSnapshot['dueDateRangeStart'] != null
          ? Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.03,
                ),
                Icon(Icons.date_range_outlined),
                SizedBox(
                  width: screenSize.width * 0.005,
                ),
                Text(
                  '${widget.documentSnapshot['dueDateRangeStart']} - ${widget.documentSnapshot['dueDateRangeEnd']}',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.black,
                    fontSize: textBody1(context),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.03,
                ),
                Icon(Icons.date_range_outlined),
                SizedBox(
                  width: screenSize.width * 0.005,
                ),
                Text(
                  'Add date range',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.black,
                    fontSize: textBody1(context),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xfff6f6f6),
            //  body: CustomScrollView(
            //    controller: _scrollController,
            appBar: AppBar(
              elevation: 0.5,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () => _showTaskEditDialog(),
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.black87,
                      )),
                )
              ],
              title: Row(
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Detail',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      fontSize: textAppTitle(context),
                    ),
                  ),
                ],
              ),
              leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left,
                      color: Colors.black87, size: screenSize.height * 0.045),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              backgroundColor: const Color(0xffffffff),
            ),
            body: Container(
              height: screenSize.height * 0.88,
              child: Column(
                children: [
                  Expanded(
                    child: eventStack(),
                  ),
                  Container(child: commentInputWidget()),
                ],
              ),
            )));
  }

  _showTaskEditDialog() {
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
                        'Delete task',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  deletePost(widget.documentSnapshot);
                  Navigator.pop(context);
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
                            fontSize: textSubTitle(context)),
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
                      'Members',
                      style: TextStyle(
                          fontSize: textHeader(context),
                          fontFamily: FontNameDefault,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('teams')
                            .doc(widget.teamId)
                            .collection('departments')
                            .doc(widget.department.uid)
                            // .collection('projects')
                            // .doc(widget.project.uid)
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
                                            .doc(widget.teamId)
                                            .collection('departments')
                                            .doc(widget.department.uid)
                                            .collection('projects')
                                            .doc(widget.project.uid)
                                            .collection('list')
                                            .doc(widget.listId)
                                            .collection('tasks')
                                            .doc(widget
                                                .documentSnapshot['taskId'])
                                            .update({
                                          'assigned': snapshot.data.docs[index]
                                              ['ownerUid'],
                                          'assignedName': snapshot
                                              .data.docs[index]['ownerName'],
                                          // 'assignedEmail': snapshot
                                          //     .data.docs[index]['ownerEmail'],
                                          'assignedPhoto': snapshot
                                              .data.docs[index]['ownerPhotoUrl']
                                        }).then((value) {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: screenSize.height * 0.02,
                                          backgroundImage: snapshot
                                                              .data.docs[index]
                                                          ['ownerPhotoUrl'] !=
                                                      '' &&
                                                  snapshot.data.docs[index]
                                                          ['ownerPhotoUrl'] !=
                                                      null
                                              ? NetworkImage(snapshot.data
                                                  .docs[index]['ownerPhotoUrl'])
                                              : AssetImage(
                                                  'assets/images/no_image.png'),
                                        ),
                                        title: Text(
                                          snapshot.data.docs[index]
                                              ['ownerName'],
                                          style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textSubTitle(context)),
                                        ),
                                        // subtitle: Text(
                                        //   'Email',
                                        //   style: TextStyle(
                                        //       fontFamily: FontNameDefault,
                                        //       fontSize: textBody1(context)),
                                        // )
                                      ),
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

  Widget commentInputWidget() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      // height: screenSize.height * 0.15,
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
      child: Row(
        children: <Widget>[
          imgurl == ''
              ? CircleAvatar(
                  radius: screenSize.height * 0.02,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.user.photoUrl),
                )
              : Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: screenSize.height * 0.07,
                      width: screenSize.width * 0.15,
                      child: Image.network(
                        imgurl,
                        loadingBuilder: ((context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                        errorBuilder: (context, error, stackTrace) =>
                            Text('error$error'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    InkWell(
                        onTap: () async {
                          Reference photoref =
                              FirebaseStorage.instance.refFromURL(imgurl);
                          await photoref.delete().then((value) {
                            setState(() {
                              imgurl = '';
                            });
                          });
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        )),
                  ],
                ),
          Expanded(
            child: Container(
              width: screenSize.width * 0.5,
              padding:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //  alignment: Alignment.bottomLeft,
                children: [
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context)),
                    controller: _commentTextController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xfffffff),
                      prefixIcon: InkWell(
                        onTap: () {
                          _pickImage('Gallery').then((selectedImage) {
                            setState(() {
                              imageFile = selectedImage;
                            });
                            compressImage();
                            _repository
                                .uploadImageToStorage(imageFile)
                                .then((url) {
                              setState(() {
                                imgurl = url;
                              });
                            });
                          });
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: screenSize.width * 0.01),
                          child: Icon(Icons.photo_outlined),
                        ),
                      ),
                      suffixIcon: InkWell(
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          if (_commentTextController.text != '') {
                            var _comment = Comment(
                                postId: postId,
                                imgUrl: imgurl,
                                comment: _commentTextController.text,
                                timeStamp: FieldValue.serverTimestamp(),
                                ownerName: widget.currentuser.displayName,
                                ownerPhotoUrl: widget.currentuser.photoUrl,
                                ownerUid: widget.currentuser.uid);
                            widget.documentSnapshot.reference
                                .collection("comments")
                                .doc()
                                .set(_comment.toMap(_comment))
                                .whenComplete(() {
                              _commentTextController.text = "";
                              imgurl = '';
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                              postId = Uuid().v4();
                            });

                            //  addCommentToActivityFeed(widget.snapshot, widget.user);
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                        ),
                      ),
                      hintText: "Add a comment...",
                    ),
                    onFieldSubmitted: (value) {
                      _commentTextController.text = value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commentReplyInputWidget() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      // height: screenSize.height * 0.15,
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
      child: Row(
        children: <Widget>[
          imgurl == ''
              ? CircleAvatar(
                  radius: screenSize.height * 0.02,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.user.photoUrl),
                )
              : Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: screenSize.height * 0.07,
                      width: screenSize.width * 0.15,
                      child: Image.network(
                        imgurl,
                        loadingBuilder: ((context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                        errorBuilder: (context, error, stackTrace) =>
                            Text('error$error'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    InkWell(
                        onTap: () async {
                          Reference photoref =
                              FirebaseStorage.instance.refFromURL(imgurl);
                          await photoref.delete().then((value) {
                            setState(() {
                              imgurl = '';
                            });
                          });
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        )),
                  ],
                ),
          Expanded(
            child: Container(
              width: screenSize.width * 0.5,
              padding:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //  alignment: Alignment.bottomLeft,
                children: [
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context)),
                    //controller: widget.documentSnapshot.data['taskId'],
                    decoration: InputDecoration(
                      prefixIcon: InkWell(
                        onTap: () {
                          _pickImage('Gallery').then((selectedImage) {
                            setState(() {
                              imageFile = selectedImage;
                            });
                            compressImage();
                            _repository
                                .uploadImageToStorage(imageFile)
                                .then((url) {
                              setState(() {
                                imgurl = url;
                              });
                            });
                          });
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: screenSize.width * 0.01),
                          child: Icon(Icons.photo_outlined),
                        ),
                      ),
                      suffixIcon: InkWell(
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          if (_commentTextController.text != '') {
                            var _comment = Comment(
                                postId: postId,
                                imgUrl: imgurl,
                                comment: _commentTextController.text,
                                timeStamp: FieldValue.serverTimestamp(),
                                ownerName: widget.currentuser.displayName,
                                ownerPhotoUrl: widget.currentuser.photoUrl,
                                ownerUid: widget.currentuser.uid);
                            widget.documentSnapshot.reference
                                .collection("comments")
                                .doc()
                                .set(_comment.toMap(_comment))
                                .whenComplete(() {
                              _commentTextController.text = "";
                              postId = Uuid().v4();
                            });

                            //  addCommentToActivityFeed(widget.snapshot, widget.user);
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                        ),
                      ),
                      hintText: "Add a comment...",
                    ),
                    onFieldSubmitted: (value) {
                      _commentTextController.text = value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventStack() {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      // reverse: true,
      controller: _scrollController,
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(
        screenSize.width * 0.05,
        screenSize.height * 0.03,
        screenSize.width * 0.05,
        screenSize.height * 0.2,
      ),
      children: [
        _editTitleTextField(),
        Row(
          children: [
            Text(
              'Assignee',
              style: TextStyle(
                color: Colors.black,
                fontSize: textSubTitle(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.05,
            ),
            _editAssignedMember()
          ],
        ),
        Row(children: [
          Text(
            'Due date',
            style: TextStyle(
              color: Colors.black,
              fontSize: textSubTitle(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: screenSize.width * 0.07,
          ),
          _editDateRangeTextField(),
        ]),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        Row(
          children: [
            Text(
              'Description',
              style: TextStyle(
                color: Colors.black,
                fontSize: textSubTitle(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.08,
            ),
            _editDescTextField(),
          ],
        ),
        Divider(),
        StreamBuilder(
          stream: widget.documentSnapshot.reference
              .collection('comments')
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: ((context, index) =>
                      commentItem(snapshot.data.docs[index])));
            }
          },
        ),
      ],
    );
  }

  Widget projectMember() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.teamId)
          .collection('departments')
          .doc(widget.department.uid)
          .collection('projects')
          .doc(widget.project.uid)
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
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('teams')
                          .doc(widget.teamId)
                          .collection('departments')
                          .doc(widget.department.uid)
                          .collection('projects')
                          .doc(widget.project.uid)
                          .collection('list')
                          .doc(widget.listId)
                          .collection('tasks')
                          .doc(widget.documentSnapshot['taskId'])
                          .update({
                        'assigned': snapshot.data.docs[index]['ownerUid'],
                        'assignedName': snapshot.data.docs[index]['ownerName'],
                        'assignedEmail': snapshot.data.docs[index]
                            ['ownerEmail'],
                        'assignedPhoto': snapshot.data.docs[index]
                            ['ownerPhotoUrl']
                      }).then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: screenSize.height * 0.02,
                          backgroundImage: snapshot.data.docs[index]
                                          ['ownerPhotoUrl'] !=
                                      '' ||
                                  snapshot.data.docs[index]['ownerPhotoUrl'] !=
                                      null
                              ? NetworkImage(
                                  snapshot.data.docs[index]['ownerPhotoUrl'])
                              : AssetImage('assets/images/no_image.png'),
                        ),
                        title: Text(
                          snapshot.data.docs[index]['ownerName'],
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context)),
                        ),
                        subtitle: Text(
                          snapshot.data.docs[index]['ownerEmail'],
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context)),
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
    );
  }

  _verticalDivider() => BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      );

  Widget commentItem(DocumentSnapshot snapshot) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.01,
        bottom: screenSize.height * 0.01,
      ),
      child: Container(
        decoration: _verticalDivider(),
        child: Padding(
          padding: EdgeInsets.only(left: screenSize.height * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: snapshot['ownerPhotoUrl'] != '' ||
                            snapshot['ownerPhotoUrl'] != null
                        ? CachedNetworkImageProvider(snapshot['ownerPhotoUrl'])
                        : AssetImage('assets/images/no_image.png'),
                    radius: screenSize.height * 0.02,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        snapshot['ownerName'],
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.black,
                          fontSize: textSubTitle(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          text: snapshot['comment'],
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.black,
                            fontSize: textBody1(context),
                            //  fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshot['imgUrl'] != ''
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageDetail(
                                          image: snapshot['imgUrl'],
                                        )));
                          },
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.medium,
                            fadeInCurve: Curves.easeIn,
                            fadeOutCurve: Curves.easeOut,
                            imageUrl: snapshot['imgUrl'],
                            placeholder: ((context, s) => Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/placeholder.png'),
                                      ),
                                    ),
                                  ),
                                )),
                            width: screenSize.width * 0.7,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      snapshot.data != null && snapshot['timestamp'] != null
                          ? timeago.format(snapshot['timestamp'].toDate())
                          // .replaceAll('about', '')
                          // .replaceAll('ago', '')
                          : '',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.grey,
                        //  fontSize: textbody2(context),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} discussions',
              style: TextStyle(color: Colors.grey),
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

  deletePost(DocumentSnapshot snapshot) {
    snapshot.reference.get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        Navigator.pop(context);
        print('task deleted');
      } else {
        return print('task could not delete');
      }
    });
  }

  postComment() {
    var _comment = Comment(
        comment: _commentTextController.text,
        timeStamp: FieldValue.serverTimestamp(),
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid);
    widget.documentSnapshot.reference
        .collection("comments")
        .doc()
        .set(_comment.toMap(_comment))
        .whenComplete(() {
      _commentTextController.text = "";
    });
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);
    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, height: 500);
    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 55));
    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }
}
