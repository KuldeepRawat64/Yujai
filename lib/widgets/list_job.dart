import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/job_detail_page.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListItemJob extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;
  final int index;

  ListItemJob({this.user, this.index, this.currentuser, this.documentSnapshot});

  @override
  _ListItemJobState createState() => _ListItemJobState();
}

class _ListItemJobState extends State<ListItemJob> {
  String selectedSubject;

  Future<void> send() async {
    final Email email = Email(
      body: '\n Owner ID : ${widget.documentSnapshot.data['ownerUid']}' +
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
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(
              user: widget.user,
              currentuser: widget.user,
              documentSnapshot: widget.documentSnapshot,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.0,
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
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: screenSize.width * 0.23,
                  right: screenSize.width / 30,
                  top: screenSize.height * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.documentSnapshot.data['timing'],
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
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
                              showReport(widget.documentSnapshot, context);
                            },
                            child: Container(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60.0),
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
                                    'More',
                                    style: TextStyle(
                                        fontSize: textButton(context),
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    bottom: screenSize.height * 0.012),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: ShapeDecoration(
                            color: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenSize.height * 0.01),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenSize.height * 0.02),
                            child: CircleAvatar(
                              radius: screenSize.height * 0.03,
                              backgroundColor: Colors.grey,
                              backgroundImage: CachedNetworkImageProvider(widget
                                  .documentSnapshot.data['jobOwnerPhotoUrl']),
                            ),
                          ),
                        ),
                        new SizedBox(
                          width: screenSize.width / 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => JobDetailScreen(
                                      user: widget.user,
                                      currentuser: widget.user,
                                      documentSnapshot: widget.documentSnapshot,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: screenSize.height * 0.012),
                                child: new Text(
                                  widget.documentSnapshot.data['caption'],
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context),
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01),
                              child: new Text(
                                widget.documentSnapshot.data['jobOwnerName'],
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                            ),
                            widget.documentSnapshot.data['location'] != null ||
                                    widget.documentSnapshot.data['location']
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: screenSize.height * 0.01),
                                    child: new Text(
                                      widget.documentSnapshot.data['location'],
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        color: Colors.grey,
                                        fontSize: textBody1(context),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                    new IconButton(
                      icon: Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                        size: screenSize.height * 0.04,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              // Divider()
              //    SizedBox(height: screenSize.height * 0.02)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  timeago.format(widget.documentSnapshot.data['time'].toDate()),
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textbody2(context),
                    color: Colors.black54,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
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
                      fontSize: textSubTitle(context),
                      color: Colors.black),
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
                      fontSize: textSubTitle(context),
                      color: Colors.black),
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
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                          fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                        title: Text(
                          'Spam',
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
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
                            fontSize: textSubTitle(context),
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
                            fontSize: textSubTitle(context),
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
                            fontSize: textSubTitle(context),
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
                            fontSize: textSubTitle(context),
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
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                                fontFamily: FontNameDefault,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              send().then((value) => Navigator.pop(context));
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
}
