import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/event_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListItemEventHome extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;
  final int index;

  ListItemEventHome({
    this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
  });

  @override
  _ListItemEventHomeState createState() => _ListItemEventHomeState();
}

class _ListItemEventHomeState extends State<ListItemEventHome> {
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
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                )
              ],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: screenSize.width / 50,
                    top: screenSize.height * 0.012,
                    left: screenSize.width / 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: screenSize.height * 0.04,
                          backgroundColor: Colors.grey,
                          backgroundImage: CachedNetworkImageProvider(widget
                              .documentSnapshot.data['eventOwnerPhotoUrl']),
                        ),
                        new SizedBox(
                          width: screenSize.width / 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetailScreen(
                                              user: widget.user,
                                              currentuser: widget.user,
                                              documentSnapshot:
                                                  widget.documentSnapshot,
                                            )));
                              },
                              child: Wrap(
                                children: [
                                  new Text(
                                    widget.documentSnapshot.data['caption'],
                                    style: TextStyle(
                                        fontSize: screenSize.height * 0.022,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.005,
                            ),
                            Text(
                              widget.documentSnapshot.data['startEvent'],
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: screenSize.height * 0.022,
                              ),
                            ),
                            Text(
                              'To',
                              style: TextStyle(
                                fontSize: screenSize.height * 0.022,
                              ),
                            ),
                            Text(
                              widget.documentSnapshot.data['endEvent'],
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: screenSize.height * 0.022,
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.01,
                            ),
                            widget.documentSnapshot.data['location'] != null &&
                                    widget.documentSnapshot.data['location']
                                        .isNotEmpty
                                ? new Text(
                                    widget.documentSnapshot.data['location'],
                                    style: TextStyle(
                                        fontSize: screenSize.height * 0.022,
                                        color: Colors.grey),
                                  )
                                : Text(
                                    'Online',
                                    style: TextStyle(
                                        fontSize: screenSize.height * 0.022,
                                        color: Colors.grey),
                                  ),
                          ],
                        ),
                        widget.currentuser.uid ==
                                widget.documentSnapshot.data['ownerUid']
                            ? FlatButton(
                                color: Colors.white,
                                child: Container(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Colors.deepPurple)),
                                      //color: Theme.of(context).accentColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        'More',
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                onPressed: () {
                                  showDelete(widget.documentSnapshot);
                                })
                            : FlatButton(
                                color: Colors.white,
                                child: Container(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Colors.deepPurple)),
                                      //color: Theme.of(context).accentColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        'More',
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                onPressed: () {
                                  showReport(widget.documentSnapshot, context);
                                })
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: screenSize.width / 1.1,
                  height: screenSize.height * 0.055,
                  child: Text(
                    widget.documentSnapshot.data['description'],
                    style: TextStyle(
                      fontSize: screenSize.height * 0.022,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                child: Text(
                  timeago.format(widget.documentSnapshot.data['time'].toDate()),
                  style: TextStyle(
                    fontSize: screenSize.height * 0.02,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
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
                      user: widget.user,
                      currentuser: widget.user,
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
