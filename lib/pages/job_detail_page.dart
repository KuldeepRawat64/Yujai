import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../style.dart';

class JobDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;

  JobDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  String selectedSubject;

  @override
  void initState() {
    super.initState();
    selectedSubject = 'Spam';
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
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  widget.currentuser.uid == widget.documentSnapshot['ownerUid']
                      ? showDelete(widget.documentSnapshot)
                      : showReport(widget.documentSnapshot);
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black54,
                ))
          ],
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: screenSize.height * 0.045,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: const Color(0xffffffff),
          title: Text(
            'Details',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: jobDetail(),
      ),
    );
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

  Widget jobDetail() {
    var screenSize = MediaQuery.of(context).size;
    DateTime myDateTime = widget.documentSnapshot['time'] != null
        ? (widget.documentSnapshot['time']).toDate()
        : DateTime.now();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenSize.width / 30,
                      screenSize.height * 0.012,
                      screenSize.width / 30,
                      0,
                    ),
                    child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.documentSnapshot['jobOwnerPhotoUrl']),
                        radius: screenSize.height * 0.04),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: screenSize.height * 0.012),
                        child: Text(
                          DateFormat.yMMMd().add_jm().format(myDateTime),
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            color: Colors.black54,
                            // fontSize: textbody2(context)
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0, top: screenSize.height * 0.01),
                        child: Text(
                          widget.documentSnapshot['caption'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            color: Colors.black,
                            fontSize: textSubTitle(context),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.0, top: screenSize.height * 0.012),
                        child: Text(
                          widget.documentSnapshot['jobOwnerName'],
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: textSubTitle(context)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 0.0, top: screenSize.height * 0.012),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text:
                                  '\u{20B9} ${widget.documentSnapshot['minSalary']} - \u{20B9} ${widget.documentSnapshot['maxSalary']}',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: textAppTitle(context)),
                            ),
                            TextSpan(
                              text: ' per month',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: textSubTitle(context)),
                            )
                          ]))),
                    ],
                  )
                ],
              ),
              widget.documentSnapshot['website'] != ''
                  ? Padding(
                      padding: EdgeInsets.all(screenSize.height * 0.012),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RaisedButton(
                            splashColor: Colors.yellow,
                            shape: StadiumBorder(),
                            color: Colors.deepPurple,
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyWebView(
                                            title: 'Apply for work',
                                            selectedUrl: widget
                                                .documentSnapshot['website'],
                                          )));
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        widget.documentSnapshot['industry'] != ''
            ? ListTile(
                leading: Icon(
                  Icons.business,
                  color: Colors.black,
                ),
                title: Text(
                  'Industry',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  widget.documentSnapshot['industry'],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    color: Colors.black54,
                  ),
                ),
              )
            : Container(),
        widget.documentSnapshot['workDays'] == ''
            ? ListTile(
                leading: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  'Working days',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  widget.documentSnapshot['workDays'],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    color: Colors.black54,
                  ),
                ),
              )
            : Container(),
        widget.documentSnapshot['timing'] == ''
            ? ListTile(
                leading: Icon(
                  MdiIcons.clockOutline,
                  color: Colors.black,
                ),
                title: Text(
                  'Timings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  widget.documentSnapshot['timing'],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    color: Colors.black54,
                  ),
                ),
              )
            : Container(),
        ListTile(
          leading: Icon(
            Icons.business_center_outlined,
            color: Colors.black,
          ),
          title: Text(
            'Job description',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            widget.documentSnapshot['description'],
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
              color: Colors.black54,
            ),
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        ListTile(
          leading: Icon(
            Icons.location_on_outlined,
            // size: 16,
            color: Colors.black,
          ),
          title: Text(
            'Location',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: Colors.grey,
                fontFamily: FontNameDefault,
                fontSize: textBody1(context)),
          ),
          subtitle: Text(
            widget.documentSnapshot['location'],
            style: TextStyle(
                color: Colors.grey,
                fontFamily: FontNameDefault,
                fontSize: textBody1(context)),
          ),
        ),
        Container(
          width: screenSize.width,
          padding: EdgeInsets.only(
              left: screenSize.width / 30,
              top: screenSize.height * 0.012,
              bottom: screenSize.height * 0.012),
          child: Text(
            'Employer',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textHeader(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          width: screenSize.width,
          padding: EdgeInsets.only(
              top: screenSize.height * 0.012,
              bottom: screenSize.height * 0.05,
              left: screenSize.width / 50),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: screenSize.height * 0.03,
                backgroundImage: CachedNetworkImageProvider(
                    widget.documentSnapshot['jobOwnerPhotoUrl']),
                backgroundColor: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: screenSize.width / 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FriendProfileScreen(
                                  uid: widget.documentSnapshot['ownerUid'],
                                  name: widget.documentSnapshot['jobOwnerName'],
                                )));
                      },
                      child: Text(
                        widget.documentSnapshot['jobOwnerName'],
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FriendProfileScreen(
                                        uid:
                                            widget.documentSnapshot['ownerUid'],
                                        name: widget
                                            .documentSnapshot['jobOwnerName'],
                                      )));
                            },
                            child: Container(
                              height: screenSize.height * 0.055,
                              width: screenSize.width / 3.5,
                              child: Center(
                                  child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.white,
                                  fontSize: textBody1(context),
                                ),
                              )),
                              decoration: ShapeDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width / 50,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black54,
                          size: screenSize.height * 0.04,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        )
      ],
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
        .collection('jobs')
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
