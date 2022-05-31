import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class EventDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;

  EventDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  var _repository = Repository();
  bool seeMore = false;
  String selectedSubject = 'Spam';

  convertDate(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }

  convertTime(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.jm().format(date);
    return formattedDate;
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        body: CustomScrollView(
          slivers: [
            // SliverAppBar(
            //   leading: IconButton(
            //       icon: Icon(Icons.keyboard_arrow_left,
            //           color: Colors.white, size: screenSize.height * 0.045),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       }),
            //   actions: [
            //     IconButton(
            //         icon: Icon(Icons.more_horiz, color: Colors.white),
            //         onPressed: null)
            //   ],
            //   floating: true,
            //   backgroundColor: Color(0xFFEDF2F8),
            //   expandedHeight: screenSize.height * 0.2,
            //   flexibleSpace: FlexibleSpaceBar(
            //     background: CachedNetworkImage(
            //         fit: BoxFit.cover,
            //         imageUrl: widget.documentSnapshot.data['imgUrl']),
            //   ),
            // ),
            SliverList(delegate: SliverChildListDelegate([eventStack()]))
          ],
        ),
      ),
    );
  }

  Widget eventBody() {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: screenSize.height * 0.25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenSize.height * 0.025,
                    left: screenSize.height * 0.05,
                    right: screenSize.height * 0.05,
                    bottom: screenSize.height * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              widget.documentSnapshot['eventOwnerPhotoUrl']),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenSize.width * 0.3,
                              child: Text(
                                widget.documentSnapshot['caption'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontSize: textH1(context),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.01,
                            ),
                            widget.documentSnapshot['website'] != '' &&
                                    widget.documentSnapshot['website'] != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => MyWebView(
                                                  title: 'Event',
                                                  selectedUrl:
                                                      widget.documentSnapshot[
                                                          'website'])));
                                    },
                                    child: Container(
                                      width: screenSize.width * 0.6,
                                      child: Text(
                                        widget.documentSnapshot['website'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: FontNameDefault,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontSize: textSubTitle(context),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.today_outlined,
                            color: Colors.black87,
                            size: screenSize.height * 0.04,
                          ),
                          onPressed: null,
                        ),
                        SizedBox(
                          width: screenSize.height * 0.02,
                        ),
                        Container(
                          width: screenSize.width * 0.5,
                          child: Text(
                            '${convertDate(widget.documentSnapshot['startDate'])}, ${convertTime(widget.documentSnapshot['startTime'])} - ${convertDate(widget.documentSnapshot['endDate'])}, ${convertTime(widget.documentSnapshot['endTime'])}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.location_on_outlined,
                            color: Colors.black87,
                            size: screenSize.height * 0.04,
                          ),
                          onPressed: null,
                        ),
                        SizedBox(
                          width: screenSize.height * 0.02,
                        ),
                        Container(
                          width: screenSize.width * 0.5,
                          child: Text(
                            widget.documentSnapshot['city'] == '' ||
                                    widget.documentSnapshot['city'] == null
                                ? 'Online'
                                : widget.documentSnapshot['city'],
                            style: TextStyle(
                              color: Colors.black,
                              //    fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    widget.documentSnapshot['ticketWebsite'] != '' &&
                            widget.documentSnapshot['ticketWebsite'] != null
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: screenSize.height * 0.01,
                                left: screenSize.width * 0.01,
                                right: screenSize.width * 0.01),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyWebView(
                                              title: ' Registration',
                                              selectedUrl:
                                                  widget.documentSnapshot[
                                                      'ticketWebsite'],
                                            )));
                              },
                              child: Container(
                                  height: screenSize.height * 0.07,
                                  width: screenSize.width * 0.8,
                                  decoration: ShapeDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60.0))),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        screenSize.height * 0.015),
                                    child: Center(
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textAppTitle(context),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: screenSize.height * 0.01,
            //   ),
            //   child: Container(
            //     height: screenSize.height * 0.005,
            //     color: Colors.grey[200],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
              child: Container(
                //height: screenSize.height * 0.06,
                width: screenSize.width,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    top: screenSize.height * 0.012,
                  ),
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      //  color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: screenSize.width,
              padding: EdgeInsets.only(
                // top: screenSize.height * 0.012,
                bottom: screenSize.height * 0.012,
                left: screenSize.width / 30,
              ),
              child: widget.documentSnapshot['description'].toString().length <
                      350
                  ? Text(
                      widget.documentSnapshot['description'],
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: textSubTitle(context)),
                    )
                  : seeMore
                      ? Wrap(
                          children: [
                            Text(
                              widget.documentSnapshot['description'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: textSubTitle(context)),
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    seeMore = false;
                                  });
                                },
                                child: Text(
                                  'See less',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ))
                          ],
                        )
                      : Wrap(
                          children: [
                            Text(
                              widget.documentSnapshot['description'],
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  seeMore = true;
                                });
                              },
                              child: Text(
                                'See more',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            )
                          ],
                        ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: screenSize.height * 0.01,
            //   ),
            //   child: Container(
            //     height: screenSize.height * 0.005,
            //     color: Colors.grey[200],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
              child: Container(
                width: screenSize.width,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    top: screenSize.height * 0.012,
                  ),
                  child: Text(
                    'Speakers',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                //    left: screenSize.width / 30,
                bottom: screenSize.height * 0.012,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  widget.documentSnapshot['host'],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: screenSize.height * 0.01,
            //   ),
            //   child: Container(
            //     height: screenSize.height * 0.005,
            //     color: Colors.grey[200],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
              child: Container(
                width: screenSize.width,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    top: screenSize.height * 0.012,
                  ),
                  child: Text(
                    'Uploader',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (widget.documentSnapshot['ownerUid'] !=
                    widget.currentuser.uid) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FriendProfileScreen(
                          uid: widget.documentSnapshot['ownerUid'],
                          name: widget.documentSnapshot['eventOwnerName'])));
                }
              },
              child: Container(
                child: ListTile(
                  //  subtitle: Text(''),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        widget.documentSnapshot['eventOwnerPhotoUrl']),
                  ),
                  title: Text(
                    widget.documentSnapshot['eventOwnerName'],
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: screenSize.height * 0.01,
            //   ),
            //   child: Container(
            //     height: screenSize.height * 0.005,
            //     color: Colors.grey[200],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.01,
                right: screenSize.width / 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Event Discussion',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                        ),
                      ),
                      ElevatedButton(
                        child: Text(
                          'Discuss',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textButton(context),
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CommentsScreen(
                                        commentType: 'eventComment',
                                        snapshot: widget.documentSnapshot,
                                        followingUser: widget.user,
                                        documentReference:
                                            widget.documentSnapshot.reference,
                                        user: widget.currentuser,
                                      ))));
                        },
                      ),
                    ],
                  ),
                  commentWidget(widget.documentSnapshot.reference),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.012),
              child: Container(
                height: screenSize.height * 0.04,
                width: screenSize.width,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventStack() {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.topCenter,
      children: [
        Positioned(child: eventHeader()),
        Positioned(child: eventBody()),
      ],
    );
  }

  Widget eventHeader() {
    return Container(
      color: Colors.grey,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CachedNetworkImage(
            imageUrl: widget.documentSnapshot['imgUrl'],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.keyboard_arrow_left_outlined)),
            ),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                widget.currentuser.uid == widget.documentSnapshot['ownerUid']
                    ? deleteDialog(widget.documentSnapshot)
                    : showReport(widget.documentSnapshot);
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.more_vert_outlined),
              ),
            ),
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

  showReport(DocumentSnapshot snapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Report this post',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showFormDialog(context);
                  //   Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
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
              content: Form(
                child: Wrap(
                  //    mainAxisSize: MainAxisSize.min,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                          fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                        title: Text(
                          'Spam',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Spam',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Pornographic',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Pornographic',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Misleading',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Misleading',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Hacked',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                        groupValue: selectedSubject,
                        value: 'Hacked',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Offensive',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
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
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () {
                              send().then((value) => Navigator.pop(context));
                              // .then((value) => Navigator.pop(context));
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
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
        .doc(widget.currentuser.uid)
        .collection('events')
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

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} discussions',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                  color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            commentType: 'eventComment',
                            snapshot: widget.documentSnapshot,
                            followingUser: widget.user,
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
}
