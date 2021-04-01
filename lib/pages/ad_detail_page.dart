import 'package:Yujai/models/user.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'friend_profile.dart';

class AdDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;

  AdDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  _AdDetailScreenState createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  String selectedSubject;
  @override
  void initState() {
    super.initState();
    selectedSubject = 'Spam';
  }

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
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.redAccent),
                ),
                onPressed: () {
                  _showFormDialog();
                  //   Navigator.pop(context);
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

  _showFormDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return SimpleDialog(
              title: Text(
                'Report',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textHeader(context)),
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            onTap: send,
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left,
                      color: Colors.white, size: screenSize.height * 0.045),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: [
                IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () {
                      widget.currentuser.uid ==
                              widget.documentSnapshot.data['ownerUid']
                          ? showDelete(widget.documentSnapshot)
                          : showReport(widget.documentSnapshot);
                    })
              ],
              backgroundColor: Color(0xFFEDF2F8),
              expandedHeight: screenSize.height * 0.4,
              flexibleSpace: FlexibleSpaceBar(
                background: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageDetail(
                                  image: widget.documentSnapshot.data['imgUrl'],
                                )));
                  },
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.documentSnapshot.data['imgUrl']),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                    [AdStack(documentSnapshot: widget.documentSnapshot)]))
          ],
        ),
      ),
    );
  }
}

class AdStack extends StatelessWidget {
  const AdStack({
    Key key,
    @required this.documentSnapshot,
  }) : super(key: key);

  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      children: [
        Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                right: screenSize.width / 30,
                top: screenSize.height * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      documentSnapshot.data['time'] != null
                          ? timeago
                              .format(documentSnapshot.data['time'].toDate())
                          : '',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textbody2(context),
                          color: Colors.grey)),
                  Text(documentSnapshot.data['price'],
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenSize.height * 0.012),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenSize.width / 30),
              child: Text(
                documentSnapshot.data['caption'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.01,
          ),
          child: Container(
            height: screenSize.height * 0.01,
            color: Colors.grey[200],
          ),
        ),
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
                'Description',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.black45,
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
          child: Wrap(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                documentSnapshot.data['description'],
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: textBody1(context)),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.01,
          ),
          child: Container(
            height: screenSize.height * 0.01,
            color: Colors.grey[200],
          ),
        ),
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
                'Details',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width / 30),
                    child: Text(
                      'Product Condition',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width / 30,
                    ),
                    child: Chip(
                      backgroundColor: Colors.grey[100],
                      label: Text(documentSnapshot.data['condition']),
                      labelStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width / 30),
                    child: Text(
                      'Location',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context)),
                    ),
                  ),
                  Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenSize.width / 30,
                          bottom: screenSize.height * 0.012,
                        ),
                        child: Chip(
                          backgroundColor: Colors.grey[100],
                          label: Text(
                            documentSnapshot.data['location'],
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context)),
                          ),
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
          ),
          child: Container(
            height: screenSize.height * 0.01,
            color: Colors.grey[200],
          ),
        ),
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
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InstaFriendProfileScreen(
                      uid: documentSnapshot.data['ownerUid'],
                      name: documentSnapshot.data['postOwnerName'])));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ]),
                child: ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.account_box_outlined),
                    onPressed: null,
                  ),
                  subtitle: Text(''),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        documentSnapshot.data['postOwnerPhotoUrl']),
                  ),
                  title: Text(
                    documentSnapshot.data['postOwnerName'],
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(top: screenSize.height * 0.012),
          child: Container(
            height: screenSize.height * 0.04,
            width: screenSize.width,
          ),
        ),
      ],
    );
  }
}
