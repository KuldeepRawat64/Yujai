import 'package:Yujai/models/comment.dart';
import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/team_feed.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class DiscussionComments extends StatefulWidget {
  final DocumentReference documentReference;
  final DocumentSnapshot snapshot;
  final User user;
  final User followingUser;
  final String gid;
  DiscussionComments(
      {this.documentReference,
      this.user,
      this.followingUser,
      this.snapshot,
      this.gid});

  @override
  _DiscussionCommentsState createState() => _DiscussionCommentsState();
}

class _DiscussionCommentsState extends State<DiscussionComments> {
  TextEditingController _commentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
 String actId = Uuid().v4();
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
              Divider(
                height: 20.0,
                color: Colors.grey,
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
        comment: _commentController.text,
        timeStamp: FieldValue.serverTimestamp(),
        ownerName: widget.user.displayName,
        ownerPhotoUrl: widget.user.photoUrl,
        ownerUid: widget.user.uid);
    widget.documentReference
        .collection("comments")
        .document()
        .setData(_comment.toMap(_comment))
        .whenComplete(() {
      _commentController.text = "";
    });
  }

  void addCommentToActivityFeed(DocumentSnapshot snapshot, User currentUser) {
    var _feed = TeamFeed(
      assigned: snapshot['ownerUid'],
      ownerName: currentUser.displayName,
      ownerUid: currentUser.uid,
      type: 'comment',
      ownerPhotoUrl: currentUser.photoUrl,
      imgUrl: snapshot['imgUrl'],
      postId: actId,
      timestamp: FieldValue.serverTimestamp(),
      commentData: _commentController.text,
    );
    Firestore.instance
        .collection('teams')
        .document(widget.gid)
        .collection('inbox')
        // .document(currentUser.uid)
        // .collection('comment')
        .document(actId)
        .setData(_feed.toMap(_feed))
        .then((value) {
          actId = Uuid().v4();
      print('Comment Feed added');
    });
  }

  Widget commentsListWidget() {
    print("Document Ref : ${widget.documentReference.path}");
    return Flexible(
      child: StreamBuilder(
        stream: widget.documentReference
            .collection("comments")
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) =>
                  commentItem(snapshot.data.documents[index])),
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
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      snapshot.data['ownerPhotoUrl']),
                  radius: 20,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Row(
                children: <Widget>[
                  Text(snapshot.data['ownerName'],
                      style: TextStyle(
                        fontSize: textSubTitle(context),
                        fontFamily: FontNameDefault,
                        fontWeight: FontWeight.bold,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(snapshot.data['comment'],
                        style: TextStyle(
                          fontSize: textBody1(context),
                          fontFamily: FontNameDefault,
                        )),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(timeago.format(snapshot.data['timestamp'].toDate()),
                style: TextStyle(
                  fontSize: textbody2(context),
                  fontFamily: FontNameDefault,
                )),
          )
        ],
      ),
    );
  }
}
