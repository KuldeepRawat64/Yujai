import 'dart:async';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Yujai/pages/ad_detail_page.dart';
import 'package:transparent_image/transparent_image.dart';

class ListAd extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User currentuser;
  final int index;
  final String gid;
  final String name;
  ListAd({
    // this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
    this.gid,
    this.name,
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
      body: '\n Owner ID : ${widget.documentSnapshot.data['ownerUid']}' +
          '\ Post ID : n${widget.documentSnapshot.data['postId']}' +
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
                        user: widget.currentuser,
                        currentuser: widget.currentuser,
                        documentSnapshot: widget.documentSnapshot,
                      )));
        },
        child: Container(
          decoration: ShapeDecoration(
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
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.documentSnapshot.data['imgUrl'],
                  height: screenSize.height * 0.4,
                  width: screenSize.width,
                  fit: BoxFit.cover,
                ),
              ),
              Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenSize.height * 0.01,
                        left: screenSize.width * 0.012),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: screenSize.width * 0.01,
                                bottom: screenSize.height * 0.01,
                              ),
                              child: Text(
                                  widget.documentSnapshot.data['time'] != null
                                      ? timeago.format(widget
                                          .documentSnapshot.data['time']
                                          .toDate())
                                      : '',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textbody2(context),
                                      color: Colors.grey)),
                            ),
                          ],
                        ),
                        Text(
                          widget.documentSnapshot.data['price'],
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          widget.documentSnapshot.data['caption'],
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
                          widget.documentSnapshot.data['location'],
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
                        onTap: send,
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
    Firestore.instance
        .collection('users')
        .document(snapshot.data['ownerUid'])
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
