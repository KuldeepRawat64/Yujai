import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/promotion_detail_page.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListItemPromotion extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;
  final int index;

  ListItemPromotion(
      {this.user, this.index, this.currentuser, this.documentSnapshot});

  @override
  _ListItemPromotionState createState() => _ListItemPromotionState();
}

class _ListItemPromotionState extends State<ListItemPromotion> {
  String selectedSubject;

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
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PromotionDetailScreen(
              user: widget.user,
              currentuser: widget.user,
              documentSnapshot: widget.documentSnapshot,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
        child: Container(
          decoration: ShapeDecoration(
            color: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              // side: BorderSide(color: Colors.grey[300]),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  //     left: screenSize.width * 0.2,
                  top: screenSize.height * 0.01,
                  right: screenSize.width * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        timeago
                            .format(widget.documentSnapshot['time'].toDate()),
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textbody2(context),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    widget.currentuser.uid ==
                            widget.documentSnapshot['ownerUid']
                        ? InkWell(
                            onTap: () {
                              showDelete(widget.documentSnapshot);
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
                              showReport(widget.documentSnapshot, context);
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  screenSize.width * 0.01,
                  0.0,
                  0.0,
                  screenSize.height * 0.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(screenSize.height * 0.02),
                          child: CircleAvatar(
                            radius: screenSize.height * 0.03,
                            backgroundColor: Colors.grey,
                            backgroundImage: CachedNetworkImageProvider(widget
                                .documentSnapshot['promotionOwnerPhotoUrl']),
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
                                    builder: (context) => PromotionDetailScreen(
                                      user: widget.user,
                                      currentuser: widget.user,
                                      documentSnapshot: widget.documentSnapshot,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: screenSize.height * 0.0),
                                child: Wrap(
                                  children: [
                                    new Text(
                                      widget.documentSnapshot['caption'],
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontWeight: FontWeight.bold,
                                          fontSize: textSubTitle(context),
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.005),
                              child: Wrap(
                                children: [
                                  new Text(
                                    widget
                                        .documentSnapshot['promotionOwnerName'],
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.documentSnapshot['location'] != null
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: screenSize.height * 0.005),
                                    child: new Text(
                                      widget.documentSnapshot['location'],
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.grey),
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
              SizedBox(height: screenSize.height * 0.02)
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

  deletePost(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .collection('promotion')
        // .document()
        // .delete();
        .doc(snapshot.data()['postId'])
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
