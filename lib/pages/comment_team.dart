import 'package:Yujai/models/comment.dart';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class CommentsScreenTeam extends StatefulWidget {
  final DocumentReference documentReference;
  final DocumentSnapshot snapshot;
  final Team team;
  final UserModel user;
  final UserModel followingUser;
  CommentsScreenTeam({
    this.documentReference,
    this.user,
    this.followingUser,
    this.snapshot,
    this.team,
  });

  @override
  _CommentsScreenTeamState createState() => _CommentsScreenTeamState();
}

class _CommentsScreenTeamState extends State<CommentsScreenTeam> {
  TextEditingController _commentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
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
        backgroundColor: const Color(0xfff6f6f6),
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
              SizedBox(
                height: 20,
              ),
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
      // color: Colors.white,
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
                textCapitalization: TextCapitalization.sentences,
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
                addCommentToActivityFeed(widget.snapshot, widget.user);
                _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
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
        .delete()
        .then((value) => Navigator.pop(context));
  }

  void addCommentToActivityFeed(
      DocumentSnapshot snapshot, UserModel currentUser) {
    var _feed = Feed(
      postOwnerUid: snapshot['ownerUid'],
      ownerName: currentUser.displayName,
      ownerUid: currentUser.uid,
      type: 'comment',
      ownerPhotoUrl: currentUser.photoUrl,
      imgUrl: snapshot['imgUrl'],
      postId: snapshot['postId'],
      timestamp: FieldValue.serverTimestamp(),
      commentData: _commentController.text,
    );
    FirebaseFirestore.instance
        .collection('teams')
        .doc(widget.team.uid)
        .collection('inbox')
        // .document(currentUser.uid)
        // .collection('comment')
        .doc(snapshot['postId'])
        .set(_feed.toMap(_feed))
        .then((value) {
      print('Comment Feed added');
    });
  }
  // void addCommentToActivityFeed(
  //     DocumentSnapshot snapshot, UserModel currentUser) {
  //   var _feed = Feed(
  //     postOwnerUid: snapshot['ownerUid'],
  //     ownerName: currentUser.displayName,
  //     ownerUid: currentUser.uid,
  //     type: widget.commentType == null ? 'comment' : widget.commentType,
  //     ownerPhotoUrl: currentUser.photoUrl,
  //     imgUrl: snapshot['imgUrl'],
  //     postId: snapshot['postId'],
  //     timestamp: FieldValue.serverTimestamp(),
  //     commentData: _commentController.text,
  //   );
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(snapshot['ownerUid'])
  //       .collection('items')
  //       // .document(currentUser.uid)
  //       // .collection('comment')
  //       .doc(snapshot['postId'])
  //       .set(_feed.toMap(_feed))
  //       .then((value) {
  //     print('Comment Feed added');
  //   });
  // }

  Widget commentsListWidget() {
    print("Document Ref : ${widget.documentReference.path}");
    return Expanded(
      child: StreamBuilder(
        stream: widget.documentReference
            .collection("comments")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              //  reverse: true,
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

  Widget commentItem(DocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(snapshot['ownerPhotoUrl']),
                radius: 20,
              ),
            ),
            title: Text(snapshot['ownerName'],
                style: TextStyle(
                  fontSize: textSubTitle(context),
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(snapshot['comment'],
                  style: TextStyle(
                    fontSize: textBody1(context),
                    fontFamily: FontNameDefault,
                  )),
            ),
            trailing: IconButton(
                onPressed: () {
                  deleteDialog(snapshot);
                },
                icon: Icon(Icons.delete_outline)),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: snapshot['timestamp'] != null
                ? Text(timeago.format(snapshot['timestamp'].toDate()),
                    style: TextStyle(
                      //  fontSize: textbody2(context),
                      fontFamily: FontNameDefault,
                    ))
                : Text(''),
          )
        ],
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
}
