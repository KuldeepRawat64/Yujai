import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/event_detail_page.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Yujai/pages/event_detail_group.dart';
import 'package:intl/intl.dart';
import '../style.dart';

class ListItemEventHome extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;
  final int index;
  final String gid;
  final String name;
  final Group group;

  ListItemEventHome({
    this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
    this.gid,
    this.name,
    this.group,
  });

  @override
  _ListItemEventHomeState createState() => _ListItemEventHomeState();
}

class _ListItemEventHomeState extends State<ListItemEventHome> {
  String selectedSubject;

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
          '\ Post ID : ${widget.documentSnapshot['postId']}' +
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
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 8.0,
        ),
        child: Container(
          //  width: screenSize.width * 0.8,
          height: screenSize.height * 0.35,
          decoration: ShapeDecoration(
            color: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              //   side: BorderSide(color: Colors.grey[300]),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //    mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                      radius: screenSize.height * 0.03,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.documentSnapshot['eventOwnerPhotoUrl'])),
                  title: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendProfileScreen(
                                  uid: widget.documentSnapshot['ownerUid'],
                                  name: widget
                                      .documentSnapshot['eventOwnerName'])));
                    },
                    child: new Text(
                      widget.documentSnapshot['eventOwnerName'],
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: widget.documentSnapshot['city'] != '' &&
                          widget.documentSnapshot['city'] != null
                      ? Row(
                          children: [
                            new Text(
                              widget.documentSnapshot['city'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  //    fontSize: textBody1(context),
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              Icons.circle,
                              size: 6.0,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                //   left: screenSize.width / 30,
                                top: screenSize.height * 0.002,
                              ),
                              child: Text(
                                  widget.documentSnapshot['time'] != null
                                      ? timeago.format(widget
                                          .documentSnapshot['time']
                                          .toDate())
                                      : '',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      //   fontSize: textbody2(context),
                                      color: Colors.grey)),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            new Text(
                              'Online',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  //    fontSize: textBody1(context),
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              Icons.circle,
                              size: 6.0,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                //   left: screenSize.width / 30,
                                top: screenSize.height * 0.002,
                              ),
                              child: Text(
                                  widget.documentSnapshot['time'] != null
                                      ? timeago.format(widget
                                          .documentSnapshot['time']
                                          .toDate())
                                      : '',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      //   fontSize: textbody2(context),
                                      color: Colors.grey)),
                            ),
                          ],
                        ),
                  trailing: widget.currentuser.uid ==
                              widget.documentSnapshot['ownerUid'] ||
                          widget.group != null &&
                              widget.group.currentUserUid ==
                                  widget.currentuser.uid
                      ? InkWell(
                          onTap: () {
                            //    showDelete(widget.documentSnapshot);
                            //      deleteDialog(widget.documentSnapshot);
                          },
                          child: Container(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(
                                    //          borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                        width: 0.1, color: Colors.black54)),
                                //color: Theme.of(context).accentColor,
                              ),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenSize.height * 0.005,
                                    horizontal: screenSize.width * 0.02,
                                  ),
                                  child: Icon(Icons.more_horiz_outlined))),
                        )
                      : InkWell(
                          onTap: () {
                            //   showReport(widget.documentSnapshot);
                          },
                          child: Container(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(
                                    //          borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                        width: 0.1, color: Colors.black54)),
                                //color: Theme.of(context).accentColor,
                              ),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenSize.height * 0.005,
                                    horizontal: screenSize.width * 0.02,
                                  ),
                                  child: Icon(Icons.more_horiz_outlined))),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: screenSize.width / 50,
                    //  top: screenSize.height * 0.012,
                    left: screenSize.width / 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: screenSize.height * 0.18,
                          width: screenSize.width * 0.5,
                          decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    widget.documentSnapshot['imgUrl'],
                                  ),
                                  fit: BoxFit.cover),
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.height * 0.012))),
                        ),
                        new SizedBox(
                          width: screenSize.width * 0.02,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetailGroup(
                                              group: widget.group,
                                              user: widget.currentuser,
                                              currentuser: widget.currentuser,
                                              documentSnapshot:
                                                  widget.documentSnapshot,
                                            )));
                              },
                              child: Container(
                                width: screenSize.width * 0.25,
                                // height: screenSize.height * 0.045,
                                child: Text(
                                  widget.documentSnapshot['caption'],
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textHeader(context),
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.005,
                            ),
                            Container(
                              width: screenSize.width * 0.25,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${convertDate(widget.documentSnapshot['startDate'])}',
                                                style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      textSubTitle(context),
                                                ),
                                              ),

                                              Text(
                                                'To \n${convertDate(widget.documentSnapshot['endDate'])}',
                                                style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      textSubTitle(context),
                                                ),
                                              ),
                                              // Text(
                                              //   convertTime(widget
                                              //       .documentSnapshot
                                              //       .data['startTime']),
                                              //   style: TextStyle(
                                              //     fontFamily: FontNameDefault,
                                              //     color: Colors.black87,
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: textBody1(context),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 5.0,
                                      // ),
                                      // Text(
                                      //   'To',
                                      //   style: TextStyle(
                                      //     fontFamily: FontNameDefault,
                                      //     color: Colors.black87,
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: textBody1(context),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 5.0,
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Column(
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         Text(
                                      //           '${convertDate(widget.documentSnapshot.data['endDate'])},',
                                      //           style: TextStyle(
                                      //             fontFamily: FontNameDefault,
                                      //             color: Colors.black87,
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: textBody1(context),
                                      //           ),
                                      //         ),
                                      //         Text(
                                      //           convertTime(widget
                                      //               .documentSnapshot
                                      //               .data['endTime']),
                                      //           style: TextStyle(
                                      //             fontFamily: FontNameDefault,
                                      //             color: Colors.black87,
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: textBody1(context),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   width: screenSize.width * 0.15,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: screenSize.height * 0.01,
                    left: screenSize.width * 0.03),
                child: Container(
                  //   height: screenSize.height * 0.055,
                  child: Text(
                    widget.documentSnapshot['description'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                    ),
                  ),
                ),
              ),
              // widget.documentSnapshot.data['time'] == null
              //     ? Container()
              //     : Padding(
              //         padding: EdgeInsets.only(
              //             left: screenSize.width * 0.03,
              //             top: screenSize.height * 0.005),
              //         child: Text(
              //           timeago.format(
              //               widget.documentSnapshot.data['time'].toDate()),
              //           style: TextStyle(
              //             fontFamily: FontNameDefault,
              //             fontSize: textbody2(context),
              //             color: Colors.black54,
              //           ),
              //         ),
              //       ),
              SizedBox(
                height: screenSize.height * 0.04,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => EventDetailScreen(
                      // group: widget.group,
                      user: widget.currentuser,
                      currentuser: widget.currentuser,
                      documentSnapshot: widget.documentSnapshot,
                    ))));
      },
    );
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
                  style: TextStyle(
                      fontSize: textSubTitle(context),
                      fontFamily: FontNameDefault,
                      color: Colors.redAccent),
                ),
                onPressed: () {
                  deletePost(snapshot);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
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
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.redAccent),
                ),
                onPressed: () {
                  _showFormDialog(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
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
                      style: TextStyle(
                          fontSize: textHeader(context),
                          fontFamily: FontNameDefault,
                          fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                        title: Text(
                          'Spam',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context)),
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
                              fontSize: textSubTitle(context)),
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
                              fontSize: textSubTitle(context)),
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
                              fontSize: textSubTitle(context)),
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
                              fontSize: textSubTitle(context)),
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
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: textSubTitle(context),
                                  fontFamily: FontNameDefault,
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
