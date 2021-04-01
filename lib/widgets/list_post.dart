import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/like.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:Yujai/pages/likes_screen.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:transparent_image/transparent_image.dart';

import '../style.dart';

class ListItemPost extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;
  final int index;

  ListItemPost({
    this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
  });

  @override
  _ListItemPostState createState() => _ListItemPostState();
}

class _ListItemPostState extends State<ListItemPost> {
  var _repository = Repository();
  bool _isLiked = false;
  int timeInMillis = 1586348737122;
  int counter = 0;
  String selectedSubject;
  final _bodyController = TextEditingController();

  Widget commentWidget(DocumentReference reference) {
    var screenSize = MediaQuery.of(context).size;
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
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            snapshot: widget.documentSnapshot,
                            followingUser: widget.user,
                            documentReference: reference,
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: Container());
        }
      }),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text +
          '\n Owner ID : ${widget.documentSnapshot.data['ownerUid']}' +
          '\ Post ID : n${widget.documentSnapshot.data['postId']}' +
          '\n Sent from Yujai',
      subject: selectedSubject,
      recipients: ['animusitmanagement@gmail.com'],
      //attachmentPaths: [widget.documentSnapshot.data['imgUrl']],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
    print('$platformResponse');
    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(platformResponse),
    // ));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    selectedSubject = 'Spam';
    _repository
        .checkIfUserLikedOrNot(
            widget.currentuser.uid, widget.documentSnapshot.reference)
        .then((value) {
      if (!mounted) return;
      setState(() {
        _isLiked = value;
      });
    });
  }

  setSelectedSubject(String val) {
    setState(() {
      selectedSubject = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    //  print('build list');
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        // bottom: 5.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            // side: BorderSide(
            //   color: Colors.grey[300],
            // ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenSize.width * 0.02,
                screenSize.height * 0.012,
                screenSize.width * 0.02,
                screenSize.height * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        new CircleAvatar(
                            radius: screenSize.height * 0.03,
                            backgroundImage: CachedNetworkImageProvider(
                              widget.documentSnapshot.data['postOwnerPhotoUrl'],
                            )),
                        new SizedBox(
                          width: screenSize.width / 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InstaFriendProfileScreen(
                                                uid: widget.documentSnapshot
                                                    .data['ownerUid'],
                                                name: widget.documentSnapshot
                                                    .data['postOwnerName'])));
                              },
                              child: new Text(
                                widget.documentSnapshot.data['postOwnerName'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            widget.documentSnapshot.data['location'] != null
                                ? new Text(
                                    widget.documentSnapshot.data['location'],
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textbody2(context),
                                        color: Colors.grey),
                                  )
                                : Container(),
                          ],
                        )
                      ],
                    ),
                  ),
                  widget.currentuser.uid ==
                          widget.documentSnapshot.data['ownerUid']
                      ? InkWell(
                          onTap: () {
                            showDelete(widget.documentSnapshot);
                          },
                          child: Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                    side: BorderSide(
                                        width: 1.5, color: Colors.deepPurple)),
                                //color: Theme.of(context).accentColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 6.0,
                                  bottom: 6.0,
                                ),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textButton(context),
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        )
                      : InkWell(
                          onTap: () {
                            showReport(widget.documentSnapshot);
                          },
                          child: Container(
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0),
                                    side: BorderSide(
                                        width: 1.5, color: Colors.deepPurple)),
                                //color: Theme.of(context).accentColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 6.0,
                                  bottom: 6.0,
                                ),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textButton(context),
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageDetail(
                              image: widget.documentSnapshot.data['imgUrl'],
                            )));
              },
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.documentSnapshot.data['imgUrl'],
              ),
              // child: CachedNetworkImage(
              //   filterQuality: FilterQuality.medium,
              //   fadeInCurve: Curves.easeIn,
              //   fadeOutCurve: Curves.easeOut,
              //   imageUrl: widget.documentSnapshot.data['imgUrl'],
              //   placeholder: ((context, s) => Container(
              //         decoration: BoxDecoration(
              //           color: Colors.grey,
              //           image: DecorationImage(
              //             image: AssetImage('assets/images/placeholder.png'),
              //           ),
              //         ),
              //       )),
              //   width: screenSize.width,
              //   height: screenSize.height * 0.4,
              //   fit: BoxFit.cover,
              // ),
            ),
            widget.documentSnapshot.data['caption'] != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: screenSize.height * 0.01,
                            left: screenSize.width / 30),
                        child: Text(
                          widget.documentSnapshot.data['caption'],
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // commentWidget(widget.documentSnapshot.reference)
                    ],
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.all(screenSize.height * 0.012),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          child: _isLiked
                              ? Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Colors.deepPurple)),
                                    //color: Theme.of(context).accentColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 6.0,
                                      bottom: 6.0,
                                    ),
                                    child: Text(
                                      'Liked',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textButton(context),
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                              : Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        side: BorderSide(
                                            width: 1.5,
                                            color: Colors.deepPurple)),
                                    //color: Theme.of(context).accentColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 6.0,
                                      bottom: 6.0,
                                    ),
                                    child: Text(
                                      'Like',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textButton(context),
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                          onTap: () {
                            if (!_isLiked) {
                              setState(() {
                                _isLiked = true;
                              });

                              postLike(widget.documentSnapshot.reference);
                              addLikeToActivityFeed(
                                  widget.documentSnapshot, widget.user);
                            } else {
                              setState(() {
                                _isLiked = false;
                              });
                              postUnlike(widget.documentSnapshot.reference);
                              removeLikeFromActivityFeed(
                                  widget.documentSnapshot, widget.user);
                            }
                          }),
                      new SizedBox(
                        width: screenSize.width / 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CommentsScreen(
                                        snapshot: widget.documentSnapshot,
                                        followingUser: widget.user,
                                        documentReference:
                                            widget.documentSnapshot.reference,
                                        user: widget.currentuser,
                                      ))));
                        },
                        child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.deepPurple)),
                              //color: Theme.of(context).accentColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 6.0,
                                bottom: 6.0,
                              ),
                              child: Text(
                                'Comment',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textButton(context),
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future:
                  _repository.fetchPostLikes(widget.documentSnapshot.reference),
              builder: ((context,
                  AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                if (likesSnapshot.hasData) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LikesScreen(
                                    user: widget.user,
                                    documentReference:
                                        widget.documentSnapshot.reference,
                                  ))));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width / 30),
                      child: likesSnapshot.data.length > 1
                          ? Text(
                              "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              likesSnapshot.data.length == 1
                                  ? "Liked by ${likesSnapshot.data[0].data['ownerName']}"
                                  : "0 Likes",
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                } else {
                  return Center(child: Container());
                }
              }),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width / 30,
                  vertical: screenSize.height * 0.005,
                ),
                child: commentWidget(widget.documentSnapshot.reference)),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                bottom: screenSize.height * 0.012,
              ),
              child: Text(
                  timeago.format(widget.documentSnapshot.data['time'].toDate()),
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textbody2(context),
                      color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timestamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(widget.currentuser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  showDelete(DocumentSnapshot snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Confirm delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  deletePost(snapshot);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  showReport(DocumentSnapshot snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Report this post',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  _showFormDialog(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _showFormDialog(BuildContext context) async {
    var screenSize = MediaQuery.of(context).size;
    return await showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: ((BuildContext context, setState) {
            return AlertDialog(
              content: SizedBox(
                height: screenSize.height * 0.5,
                child: Wrap(
                  //  mainAxisSize: MainAxisSize.min,
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                        title: Text('Spam'),
                        groupValue: selectedSubject,
                        value: 'Spam',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text('Pornographic'),
                        groupValue: selectedSubject,
                        value: 'Pornographic',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text('Misleading'),
                        groupValue: selectedSubject,
                        value: 'Misleading',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text('Hacked'),
                        groupValue: selectedSubject,
                        value: 'Hacked',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text('Offensive'),
                        groupValue: selectedSubject,
                        value: 'Offensive',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: screenSize.height * 0.01,
                    //       horizontal: screenSize.width / 30),
                    //   child: Text('Comment'),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: screenSize.height * 0.01,
                    //       horizontal: screenSize.width / 30),
                    //   child: TextFormField(
                    //     controller: _bodyController,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.01,
                          horizontal: screenSize.width / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () {
                              send().then((value) => Navigator.pop(context));
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }));
        }));
  }

  deletePost(DocumentSnapshot snapshot) {
    Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .collection('posts')
        // .document()
        // .delete();
        .document(snapshot.data['postId'])
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

  void addLikeToActivityFeed(DocumentSnapshot snapshot, User currentUser) {
    // bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (widget.currentuser.uid == snapshot.data['ownerUid']) {
      return print('Owner liked');
    } else {
      var _feed = Feed(
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        type: 'like',
        ownerPhotoUrl: currentUser.photoUrl,
        imgUrl: snapshot['imgUrl'],
        postId: snapshot['postId'],
        timestamp: FieldValue.serverTimestamp(),
        commentData: '',
      );
      Firestore.instance
          .collection('users')
          .document(snapshot.data['ownerUid'])
          .collection('items')
          // .document(currentUser.uid)
          // .collection('likes')
          .document(snapshot.data['postId'])
          .setData(_feed.toMap(_feed))
          .then((value) {
        print('Feed added');
      });
    }
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .document(widget.currentuser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }

  void removeLikeFromActivityFeed(DocumentSnapshot snapshot, User currentUser) {
    //  bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (currentUser.uid == snapshot.data['ownerUid']) {
      return print('Owner feed');
    } else {
      Firestore.instance
          .collection('users')
          .document(snapshot.data['ownerUid'])
          .collection('items')
          //.where('postId',isEqualTo:snapshot['postId'])
          // .document(currentuser.uid)
          // .collection('likes')
          .document(snapshot.data['postId'])
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }
}
