import 'package:Yujai/models/comment.dart';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/team_feed.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class DiscussionComments extends StatefulWidget {
  final DocumentReference documentReference;
  final DocumentSnapshot<Map<String, dynamic>> snapshot;
  final Team team;
  final Department dept;
  final Project project;
  final UserModel user;
  final UserModel followingUser;
  final String gid;
  DiscussionComments(
      {this.documentReference,
      this.user,
      this.followingUser,
      this.snapshot,
      this.gid,
      this.team,
      this.dept,
      this.project});

  @override
  _DiscussionCommentsState createState() => _DiscussionCommentsState();
}

class _DiscussionCommentsState extends State<DiscussionComments> {
  TextEditingController _commentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  String actId = Uuid().v4();
  String commentId = Uuid().v4();

  @override
  void dispose() {
    super.dispose();
    _commentController?.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          title: Text(
            'Comments',
            style: TextStyle(
              fontFamily: FontNameDefault,
              color: Colors.black54,
              fontSize: textAppTitle(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              commentsListWidget(),
              // Divider(
              //   //   height: 20.0,
              //   color: Colors.grey,
              // ),
              commentInputWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget commentInputWidget() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.15,
      margin: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: screenSize.height * 0.04,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(widget.user.photoUrl),
          ),
          Flexible(
            child: Container(
              height: screenSize.height * 0.09,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                style: TextStyle(
                    fontFamily: FontNameDefault, fontSize: textBody1(context)),
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Add a comment...",
                ),
                onFieldSubmitted: (value) {
                  _commentController.text = value;
                },
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              if (_commentController.text != '') {
                postComment();
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
                addCommentToActivityFeed(widget.snapshot, widget.user);
              }
            },
          )
        ],
      ),
    );
  }

  postComment() {
    var _comment = Comment(
        postId: commentId,
        comment: _commentController.text,
        timeStamp: FieldValue.serverTimestamp(),
        ownerName: widget.user.displayName,
        ownerPhotoUrl: widget.user.photoUrl,
        ownerUid: widget.user.uid);
    widget.documentReference
        .collection("comments")
        .doc(commentId)
        .set(_comment.toMap(_comment))
        .whenComplete(() {
      _commentController.text = "";
      commentId = Uuid().v4();
    });
  }

  deleteComment(DocumentSnapshot snapshot) {
    widget.documentReference
        .collection('comments')
        .doc(snapshot['postId'])
        .delete();
  }

  void addCommentToActivityFeed(
      DocumentSnapshot<Map<String, dynamic>> snapshot, UserModel currentUser) {
    if (widget.user.uid != widget.snapshot['ownerUid']) {
      var _feed = TeamFeed(
        gid: widget.team.uid,
        actId: actId,
        deptId: widget.dept.uid,
        projectId: widget.project != null ? widget.project.uid : '',
        assigned: [snapshot.data()['ownerUid']],
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        type: 'comment',
        ownerPhotoUrl: currentUser.photoUrl,
        imgUrl: snapshot.data()['imgUrl'],
        postId: snapshot.data()['postId'],
        timestamp: FieldValue.serverTimestamp(),
        commentData: _commentController.text,
      );
      FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('inbox')
          // .document(currentUser.uid)
          // .collection('comment')
          .doc(actId)
          .set(_feed.toMap(_feed))
          .then((value) {
        actId = Uuid().v4();
        print('Comment Feed added');
      });
    }
  }

  Widget commentsListWidget() {
    print("Document Ref : ${widget.documentReference.path}");
    return Flexible(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: widget.documentReference
            .collection("comments")
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data.docs.length,
              itemBuilder: ((context, index) =>
                  commentItem(snapshot.data.docs[index])),
            );
          }
        }),
      ),
    );
  }

  deleteDialog(DocumentSnapshot snapshot) {
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
                            'Delete comment',
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
                          'Are you sure you want to delete this comment?',
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
                              deleteComment(snapshot);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width * 0.3,
                              child: Center(
                                child: Text(
                                  'Delete',
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

  Widget commentItem(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    snapshot.data()['ownerPhotoUrl']),
                radius: 20,
              ),
            ),
            title: Text(snapshot.data()['ownerName'],
                style: TextStyle(
                  fontSize: textSubTitle(context),
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(snapshot.data()['comment'],
                  style: TextStyle(
                    fontSize: textBody1(context),
                    fontFamily: FontNameDefault,
                  )),
            ),
            trailing: widget.user.uid == snapshot.data()['ownerUid'] ||
                    widget.team.currentUserUid == widget.user.uid ||
                    widget.dept.currentUserUid == widget.user.uid ||
                    widget.user.uid == widget.snapshot['ownerUid']
                ? IconButton(
                    onPressed: () {
                      deleteDialog(snapshot);
                    },
                    icon: Icon(Icons.delete_outline))
                : Text(''),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: snapshot.data()['timestamp'] != null
                ? Text(timeago.format(snapshot.data()['timestamp'].toDate()),
                    style: TextStyle(
                      color: Colors.grey,
                      //    fontSize: textbody2(context),
                      fontFamily: FontNameDefault,
                    ))
                : Text(''),
          )
        ],
      ),
    );
  }
}
