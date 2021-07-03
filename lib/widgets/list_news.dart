import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/like.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/likes_screen.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:transparent_image/transparent_image.dart';

class ListItemNews extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final UserModel user, currentuser;
  final int index;

  ListItemNews({
    this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
  });

  @override
  _ListItemNewsState createState() => _ListItemNewsState();
}

class _ListItemNewsState extends State<ListItemNews> {
  var _repository = Repository();
  bool _isLiked = false;
  String currentUserId, followingUserId;
  //User _user;
  IconData icon;
  Color color;
  bool isFollowing = false;
  bool followButtonClicked = false;
  String selectedSubject;
  final double offset = 1.0;

  Future<void> send() async {
    final Email email = Email(
      body: '\n Owner ID : ${widget.documentSnapshot['ownerUid']}' +
          '\ Post ID : n${widget.documentSnapshot['postId']}' +
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

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              '${snapshot.data.length}',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            commentType: 'articleComment',
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyWebView(
                    title: widget.documentSnapshot['caption'],
                    selectedUrl: widget.documentSnapshot['source'],
                  )));
        },
        child: Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
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
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FriendProfileScreen(
                                          uid: widget
                                              .documentSnapshot['ownerUid'],
                                          name: widget.documentSnapshot[
                                              'newsOwnerName'])));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: screenSize.height * 0.025,
                                backgroundColor: Colors.grey,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget
                                        .documentSnapshot['newsOwnerPhotoUrl']),
                              ),
                              title: new Text(
                                widget.documentSnapshot['newsOwnerName'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  widget.documentSnapshot['time'] != null
                                      ? timeago.format(widget
                                          .documentSnapshot['time']
                                          .toDate())
                                      : '',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      //   fontSize: textbody2(context),
                                      color: Colors.grey)),
                              trailing: widget.currentuser.uid ==
                                      widget.documentSnapshot['ownerUid']
                                  ? InkWell(
                                      onTap: () {
                                        showDelete(widget.documentSnapshot);
                                      },
                                      child: Container(
                                          decoration: ShapeDecoration(
                                            shape: CircleBorder(
                                                // borderRadius: BorderRadius.circular(60.0),
                                                side: BorderSide(
                                                    width: 0.1,
                                                    color: Colors.black54)),
                                            //color: Theme.of(context).accentColor,
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    screenSize.height * 0.005,
                                                horizontal:
                                                    screenSize.width * 0.02,
                                              ),
                                              child: Icon(
                                                  Icons.more_horiz_outlined))),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        showReport(
                                            widget.documentSnapshot, context);
                                      },
                                      child: Container(
                                          decoration: ShapeDecoration(
                                            shape: CircleBorder(
                                                //          borderRadius: BorderRadius.circular(12.0),
                                                side: BorderSide(
                                                    width: 0.1,
                                                    color: Colors.black54)),
                                            //color: Theme.of(context).accentColor,
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    screenSize.height * 0.005,
                                                horizontal:
                                                    screenSize.width * 0.02,
                                              ),
                                              child: Icon(
                                                  Icons.more_horiz_outlined))),
                                    ),
                            ),
                          ),
                          FadeInImage.assetNetwork(
                            height: screenSize.height * 0.22,
                            width: screenSize.width,
                            fadeInDuration: const Duration(milliseconds: 300),
                            placeholder: 'assets/images/placeholder.png',
                            image: widget.documentSnapshot['imgUrl'],
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width * 0.03,
                              top: screenSize.height * 0.01,
                              bottom: screenSize.height * 0.01,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.documentSnapshot['caption'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: screenSize.height * 0.005,
                                    //  bottom: screenSize.height * 0.005,
                                  ),
                                  child: Text(
                                    'Read more...',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.grey,
                                      fontSize: textBody1(context),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        leading: GestureDetector(
                            child: _isLiked
                                ? Container(
                                    decoration: ShapeDecoration(
                                      shape: CircleBorder(
                                          //  borderRadius: BorderRadius.circular(60.0),
                                          side: BorderSide(
                                              width: 0.1,
                                              color: Colors.black54)),
                                      //color: Theme.of(context).accentColor,
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: 6.0,
                                          bottom: 6.0,
                                        ),
                                        child: Icon(Icons.thumb_up_alt)))
                                : Container(
                                    decoration: ShapeDecoration(
                                      shape: CircleBorder(
                                          //    borderRadius: BorderRadius.circular(60.0),
                                          side: BorderSide(
                                              width: 0.1,
                                              color: Colors.black54)),
                                      //color: Theme.of(context).accentColor,
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: 6.0,
                                          bottom: 6.0,
                                        ),
                                        child:
                                            Icon(Icons.thumb_up_alt_outlined))),
                            onTap: () {
                              if (!_isLiked) {
                                setState(() {
                                  _isLiked = true;
                                });

                                postLike(widget.documentSnapshot.reference);
                                addLikeToActivityFeed(widget.documentSnapshot,
                                    widget.currentuser);
                              } else {
                                setState(() {
                                  _isLiked = false;
                                });

                                postUnlike(widget.documentSnapshot.reference);
                                removeLikeFromActivityFeed(
                                    widget.documentSnapshot,
                                    widget.currentuser);
                              }
                            }),
                        title: FutureBuilder(
                          future: _repository.fetchPostLikes(
                              widget.documentSnapshot.reference),
                          builder: ((context,
                              AsyncSnapshot<List<DocumentSnapshot>>
                                  likesSnapshot) {
                            if (likesSnapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => LikesScreen(
                                                user: widget.currentuser,
                                                documentReference: widget
                                                    .documentSnapshot.reference,
                                              ))));
                                },
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 6.0),
                                    child: likesSnapshot.data.length > 0
                                        ? SizedBox(
                                            height: screenSize.height * 0.06,
                                            width: screenSize.width * 0.2,
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 15.0,
                                                  backgroundColor: Colors.black,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          likesSnapshot.data[0][
                                                              'ownerPhotoUrl']),
                                                ),
                                                likesSnapshot.data.length > 1
                                                    ? Positioned(
                                                        left: 15.0,
                                                        child: CircleAvatar(
                                                          radius: 15.0,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                                  likesSnapshot
                                                                          .data[1]
                                                                      [
                                                                      'ownerPhotoUrl']),
                                                        ),
                                                      )
                                                    : Container(),
                                                likesSnapshot.data.length > 2
                                                    ? Positioned(
                                                        left: 30.0,
                                                        child: CircleAvatar(
                                                          radius: 15.0,
                                                          backgroundColor:
                                                              Colors.grey,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                                  likesSnapshot
                                                                          .data[2]
                                                                      [
                                                                      'ownerPhotoUrl']),
                                                        ),
                                                      )
                                                    : Container(),
                                                likesSnapshot.data.length > 3
                                                    ? Positioned(
                                                        left: 30.0,
                                                        child: CircleAvatar(
                                                          radius: 15.0,
                                                          backgroundColor:
                                                              Colors.grey,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                                  likesSnapshot
                                                                          .data[3]
                                                                      [
                                                                      'ownerPhotoUrl']),
                                                        ),
                                                      )
                                                    : Container(),
                                                likesSnapshot.data.length > 4
                                                    ? Positioned(
                                                        left: 30.0,
                                                        child: CircleAvatar(
                                                          radius: 15.0,
                                                          backgroundColor:
                                                              Colors.grey,
                                                          child: Text(
                                                              '${likesSnapshot.data.length}'),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          )

                                        //  Text(
                                        //     "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
                                        //     style: TextStyle(
                                        //         fontFamily: FontNameDefault,
                                        //         fontSize: textBody1(context),
                                        //         fontWeight: FontWeight.bold),
                                        //   )
                                        : Text(
                                            "0 ",
                                            style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                fontSize: textBody1(context)),
                                          ),
                                  ),
                                ),
                              );
                            } else {
                              return Center(child: Container());
                            }
                          }),
                        ),
                        trailing: SizedBox(
                          height: 40,
                          width: 100,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => CommentsScreen(
                                            //  group: widget.group,
                                            // isGroupFeed: true,
                                            commentType: 'articleComment',
                                            snapshot: widget.documentSnapshot,
                                            followingUser: widget.currentuser,
                                            documentReference: widget
                                                .documentSnapshot.reference,
                                            user: widget.currentuser,
                                          ))));
                            },
                            child: Container(
                              // decoration: ShapeDecoration(
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(60.0),
                              //       side: BorderSide(width: 0.1, color: Colors.black54)),
                              //   //color: Theme.of(context).accentColor,
                              // ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  commentWidget(
                                      widget.documentSnapshot.reference),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Icon(Icons.messenger_outline_sharp),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]))));
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timestamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .doc(widget.currentuser.uid)
        .set(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void addLikeToActivityFeed(DocumentSnapshot snapshot, UserModel currentUser) {
    // bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (widget.currentuser.uid != snapshot['ownerUid']) {
      var _feed = Feed(
        ownerName: currentUser.displayName,
        ownerUid: currentUser.uid,
        type: 'articleLike',
        ownerPhotoUrl: currentUser.photoUrl,
        imgUrl: snapshot['imgUrl'],
        postId: snapshot['postId'],
        timestamp: FieldValue.serverTimestamp(),
        commentData: '',
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(snapshot['ownerUid'])
          .collection('items')
          // .document(currentUser.uid)
          // .collection('likes')
          .doc(snapshot['postId'])
          .set(_feed.toMap(_feed))
          .then((value) {
        print('Feed added');
      });
    } else {
      return print('Owner liked');
    }
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .doc(widget.currentuser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
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
                            'Delete Post',
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
                          'Are you sure you want to delete this post?',
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
                              Navigator.pop(context);
                              deletePost(snapshot);
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

  void removeLikeFromActivityFeed(
      DocumentSnapshot snapshot, UserModel currentUser) {
    // bool ownerId = widget.user.uid == widget.currentuser.uid;
    if (widget.currentuser.uid != snapshot['ownerUid']) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(snapshot['ownerUid'])
          .collection('items')
          //.where('postId',isEqualTo:snapshot['postId'])
          // .document(currentuser.uid)
          // .collection('likes')
          .doc(snapshot['postId'])
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    } else {
      return print('Owner feed');
    }
  }

  showDelete(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Delete',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  deleteDialog(snapshot);
                  //   Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.normal),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  showReport(DocumentSnapshot snapshot, BuildContext context) {
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
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('posts')
        // .document()
        // .delete();
        .doc(snapshot['postId'])
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
