import 'dart:async';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Yujai/pages/ad_detail_page.dart';
import 'package:transparent_image/transparent_image.dart';

class ListAd extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final UserModel currentuser;
  final int index;
  final String gid;
  final String name;
  final Group group;
  ListAd({
    // this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
    this.gid,
    this.name,
    this.group,
  });

  @override
  _ListAdState createState() => _ListAdState();
}

class _ListAdState extends State<ListAd> {
  int timeInMillis = 1586348737122;
  int counter = 0;
  String selectedSubject;
  final formatCurrency = new NumberFormat.simpleCurrency();

  Future<void> send() async {
    final Email email = Email(
      body: '\n Owner ID : ${widget.documentSnapshot.data()['ownerUid']}' +
          '\ Post ID : n${widget.documentSnapshot.data()['postId']}' +
          '\n Sent from Yujai',
      subject: selectedSubject,
      recipients: ['animusitmanagement@gmail.com'],
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
  }

  @override
  void initState() {
    super.initState();
    selectedSubject = 'Spam';
  }

  setSelectedSubject(String val) {
    setState(() {
      selectedSubject = val;
    });
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      direction: Axis.vertical,
      children: strings
          .map((items) => Padding(
                padding: EdgeInsets.all(screenSize.height * 0.006),
                child: Container(
                  height: screenSize.height * 0.05,
                  width: screenSize.width / 1.2,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                      child: Text(
                    items,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ))
          .toList(),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      labelPadding: EdgeInsets.all(screenSize.height * 0.005),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenSize.height * 0.02,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(screenSize.height * 0.01),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build list');
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdDetailScreen(
                        group: widget.group,
                        user: widget.currentuser,
                        currentuser: widget.currentuser,
                        documentSnapshot: widget.documentSnapshot,
                      )));
        },
        child: Container(
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(
                  offset: Offset(1, 1),
                  color: Colors.grey[200],
                  blurRadius: 2.0,
                  spreadRadius: 2.0),
            ],
            color: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              //   side: BorderSide(color: Colors.grey[300]),
            ),
          ),
          child: Wrap(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdDetailScreen(
                                user: widget.currentuser,
                                currentuser: widget.currentuser,
                                documentSnapshot: widget.documentSnapshot,
                              )));
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenSize.height * 0.015,
                      left: screenSize.height * 0.015,
                      right: screenSize.height * 0.015),
                  child: Stack(
                    children: [
                      Container(
                        height: screenSize.height * 0.2,
                        width: screenSize.width,
                        decoration: ShapeDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.documentSnapshot.data()['imgUrls']
                                        [0]),
                                fit: BoxFit.cover),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    screenSize.height * 0.005))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenSize.width * 0.03,
                            top: screenSize.height * 0.16),
                        child: CircleAvatar(
                          radius: screenSize.height * 0.035,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              radius: screenSize.height * 0.035,
                              backgroundImage: CachedNetworkImageProvider(
                                widget.documentSnapshot
                                    .data()['postOwnerPhotoUrl'],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 10,
                          bottom: 25,
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.deepPurple, Colors.purple]),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                            child: Text(
                              '\u{20B9}' +
                                  widget.documentSnapshot.data()['price'],
                              style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: FontNameDefault,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      Positioned(
                          top: 8,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              widget.currentuser.uid ==
                                          widget.documentSnapshot
                                              .data()['ownerUid'] ||
                                      widget.group != null &&
                                          widget.group.currentUserUid ==
                                              widget.currentuser.uid
                                  ? showDelete(widget.documentSnapshot)
                                  : showReport(widget.documentSnapshot);
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.more_vert,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          widget.documentSnapshot['caption'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context)),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          widget.documentSnapshot.data()['city'] != null &&
                                  widget.documentSnapshot.data()['city'] != ''
                              ? widget.documentSnapshot.data()['city']
                              : widget.documentSnapshot.data()['location'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                  Navigator.pop(context);
                  _showFormDialog();
                  //   Navigator.pop(context);
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

  _showFormDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return SimpleDialog(title: Text('Report'), children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          // .then((value) => Navigator.pop(context));
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
          ]);
        }));
  }

  deletePost(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.gid)
        .collection('marketplace')
        // .document()
        // .delete();
        .doc(snapshot['postId'])
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
        //  Navigator.pop(context);

        print('post deleted');
      } else {
        return print('not owner');
      }
    });
  }
}
