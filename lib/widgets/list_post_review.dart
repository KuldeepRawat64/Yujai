import 'dart:async';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:transparent_image/transparent_image.dart';

import '../style.dart';

class ListPostReview extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User currentuser;
  final int index;
  final String gid;
  final String name;
  final Group group;
  ListPostReview({
    // this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
    this.gid,
    this.name,
    this.group,
  });

  @override
  _ListPostReviewState createState() => _ListPostReviewState();
}

class _ListPostReviewState extends State<ListPostReview> {
  var _repository = Repository();
  int timeInMillis = 1586348737122;
  int counter = 0;
  String selectedSubject;
  final _bodyController = TextEditingController();
  List<DocumentSnapshot> listVotes = [];
  List<DocumentSnapshot> listVotes2 = [];
  List<DocumentSnapshot> listVotes3 = [];
  List<DocumentSnapshot> listVotes4 = [];
  List<DocumentSnapshot> listVotes5 = [];
  List<DocumentSnapshot> listVotes6 = [];
  List<DocumentSnapshot> totalVotes = [];

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text +
          '\n Owner ID : ${widget.documentSnapshot.data['ownerUid']}' +
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
  }

  setSelectedSubject(String val) {
    setState(() {
      selectedSubject = val;
    });
  }

  approval() {
    if (widget.documentSnapshot.data['postType'] == 'post') {
      _repository
          .addApprovedPostToForum(
        widget.gid,
        widget.documentSnapshot.data['postId'],
        widget.documentSnapshot.data['ownerUid'],
        widget.documentSnapshot.data['imgUrl'],
        widget.documentSnapshot.data['caption'],
        widget.documentSnapshot.data['location'],
        widget.documentSnapshot.data['postOwnerName'],
        widget.documentSnapshot.data['postOwnerPhotoUrl'],
        widget.documentSnapshot.data['postType'],
      )
          .then((value) {
        deletePost(widget.documentSnapshot);
      });
    } else if (widget.documentSnapshot.data['postType'] == 'poll') {
      _repository
          .addApprovedPollToForum(
        widget.gid,
        widget.documentSnapshot.data['postId'],
        widget.documentSnapshot.data['ownerUid'],
        widget.documentSnapshot.data['caption'],
        widget.documentSnapshot.data['option1'],
        widget.documentSnapshot.data['option2'],
        widget.documentSnapshot.data['option3'],
        widget.documentSnapshot.data['option4'],
        widget.documentSnapshot.data['postType'],
        widget.documentSnapshot.data['postOwnerName'],
        widget.documentSnapshot.data['postOwnerPhotoUrl'],
      )
          .then((value) {
        deletePost(widget.documentSnapshot);
      });
    } else if (widget.documentSnapshot.data['postType'] == 'marketplace') {
      _repository
          .addApprovedAdToForum(
        widget.gid,
        widget.documentSnapshot.data['postId'],
        widget.documentSnapshot.data['ownerUid'],
        widget.documentSnapshot.data['imgUrl'],
        widget.documentSnapshot.data['caption'],
        widget.documentSnapshot.data['description'],
        widget.documentSnapshot.data['price'],
        widget.documentSnapshot.data['condition'],
        widget.documentSnapshot.data['location'],
        widget.documentSnapshot.data['postOwnerName'],
        widget.documentSnapshot.data['postOwnerPhotoUrl'],
        widget.documentSnapshot.data['postType'],
      )
          .then((value) {
        deletePost(widget.documentSnapshot);
      });
    }
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
                        fontSize: textBody1(context),
                        fontFamily: FontNameDefault,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build list');
    var screenSize = MediaQuery.of(context).size;
    return widget.documentSnapshot.data['postType'] == 'marketplace'
        ? Container(
            decoration: ShapeDecoration(
              color: const Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                // side: BorderSide(color: Colors.grey[300]),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageDetail(
                                  image: widget.documentSnapshot.data['imgUrl'],
                                )));
                  },
                  child: CachedNetworkImage(
                    filterQuality: FilterQuality.medium,
                    fadeInCurve: Curves.easeIn,
                    fadeOutCurve: Curves.easeOut,
                    imageUrl: widget.documentSnapshot.data['imgUrl'],
                    placeholder: ((context, s) => Center(
                          child: CircularProgressIndicator(),
                        )),
                    width: screenSize.width,
                    height: screenSize.height * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenSize.height * 0.01,
                          left: screenSize.width / 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'INR ${widget.documentSnapshot.data['price']}',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.all(screenSize.height * 0.012),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new Icon(
                                      MdiIcons.bookmark,
                                      color: Colors.white,
                                      size: screenSize.height * 0.035,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: FlatButton(
                                          //disabledColor: Theme.of(context).accentColor,
                                          color: Theme.of(context).accentColor,
                                          onPressed: () => approval,
                                          child: Text(
                                            'Approve',
                                            style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                fontSize: textBody1(context),
                                                color: Colors.white),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: FlatButton(
                                          // disabledColor: Colors.grey[200],
                                          color: Colors.grey[200],
                                          onPressed: () {
                                            deletePost(widget.documentSnapshot);
                                          },
                                          child: Text('Decline',
                                              style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: textBody1(context),
                                                  color: Colors.black))),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.documentSnapshot.data['caption'],
                            style:
                                TextStyle(fontSize: screenSize.height * 0.018),
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
                    // commentWidget(widget.documentSnapshot.reference)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    bottom: screenSize.height * 0.012,
                  ),
                  child: Text(
                    widget.documentSnapshot.data['time'] != null
                        ? timeago.format(
                            widget.documentSnapshot.data['time'].toDate())
                        : '',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textbody2(context),
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
          )
        : Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.grey[300])),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenSize.width / 30,
                    screenSize.height * 0.012,
                    screenSize.width / 50,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new CircleAvatar(
                              radius: screenSize.height * 0.03,
                              backgroundImage: CachedNetworkImageProvider(widget
                                  .documentSnapshot.data['postOwnerPhotoUrl'])),
                          new SizedBox(
                            width: screenSize.width / 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FriendProfileScreen(
                                                  uid:
                                                      widget.documentSnapshot
                                                          .data['ownerUid'],
                                                  name: widget.documentSnapshot
                                                      .data['postOwnerName'])));
                                },
                                child: new Text(
                                  widget.documentSnapshot.data['postOwnerName'],
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textSubTitle(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              widget.documentSnapshot.data['location'] != null
                                  ? new Text(
                                      widget.documentSnapshot.data['location'],
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.grey),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                widget.documentSnapshot.data['postType'] == 'poll'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: screenSize.height * 0.005,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              showCategory(widget.documentSnapshot, context),
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  backgroundColor: Colors.blue[50],
                                  label: Text(
                                    widget.documentSnapshot.data['pollType'],
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context),
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenSize.height * 0.01,
                            ),
                            child: Container(
                              decoration: ShapeDecoration(
                                  color: Colors.grey[50],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(40.0))),
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height * 0.01,
                                  top: screenSize.height * 0.01,
                                  left: screenSize.width / 30),
                              child: Text(
                                widget.documentSnapshot.data['caption'],
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              screenSize.width / 30,
                              screenSize.height * 0.01,
                              screenSize.width / 30,
                              screenSize.height * 0.01,
                            ),
                            child: Column(
                              children: [
                                widget.documentSnapshot.data['option1'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: screenSize.height * 0.05,
                                              width: screenSize.width / 1.2,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                widget.documentSnapshot
                                                    .data['option1'],
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize:
                                                        textBody1(context),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option2'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Center(
                                                child: Text(
                                              widget.documentSnapshot
                                                  .data['option2'],
                                              style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: textBody1(context),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option3'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Center(
                                                child: Text(
                                              widget.documentSnapshot
                                                  .data['option3'],
                                              style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: textBody1(context),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option4'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Center(
                                                child: Text(
                                              widget.documentSnapshot
                                                  .data['option4'],
                                              style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: textBody1(context),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option5'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Center(
                                                child: Text(
                                              widget.documentSnapshot
                                                  .data['option5'],
                                              style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: textBody1(context),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                widget.documentSnapshot.data['option6'] != ''
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: screenSize.height * 0.01),
                                          Container(
                                            height: screenSize.height * 0.05,
                                            width: screenSize.width / 1.2,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Center(
                                                child: Text(
                                              widget.documentSnapshot
                                                  .data['option6'],
                                              style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: textBody1(context),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      )
                    : widget.documentSnapshot.data['imgUrl'] != null
                        ? Padding(
                            padding:
                                EdgeInsets.only(top: screenSize.height * 0.01),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageDetail(
                                              image: widget.documentSnapshot
                                                  .data['imgUrl'],
                                            )));
                              },
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: widget.documentSnapshot.data['imgUrl'],
                              ),
                            ),
                          )
                        : Container(),
                widget.documentSnapshot.data['caption'] != '' &&
                        widget.documentSnapshot.data['postType'] != 'poll'
                    ? widget.documentSnapshot.data['imgUrl'] != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: screenSize.height * 0.01,
                                    left: screenSize.width / 30),
                                child: Text(
                                  widget.documentSnapshot.data['caption'],
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                  ),
                                ),
                              ),
                              // commentWidget(widget.documentSnapshot.reference)
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01,
                                ),
                                child: Container(
                                  decoration: ShapeDecoration(
                                      color: Colors.grey[50],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0))),
                                  padding: EdgeInsets.only(
                                      bottom: screenSize.height * 0.01,
                                      top: screenSize.height * 0.01,
                                      left: screenSize.width / 30),
                                  child: Text(
                                    widget.documentSnapshot.data['caption'],
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(screenSize.height * 0.012),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Icon(
                        MdiIcons.bookmark,
                        color: Colors.white,
                        size: screenSize.height * 0.035,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: FlatButton(
                            //disabledColor: Theme.of(context).accentColor,
                            color: Theme.of(context).accentColor,
                            onPressed: approval,
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.white),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: FlatButton(
                            // disabledColor: Colors.grey[200],
                            color: Colors.grey[200],
                            onPressed: () {
                              deletePost(widget.documentSnapshot);
                            },
                            child: Text('Decline',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                    color: Colors.black))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    bottom: screenSize.height * 0.012,
                  ),
                  child: Text(
                      widget.documentSnapshot.data['time'] != null
                          ? timeago.format(
                              widget.documentSnapshot.data['time'].toDate())
                          : '',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textbody2(context),
                          color: Colors.grey)),
                ),
              ],
            ),
          );
  }

  deletePost(DocumentSnapshot snapshot) {
    Firestore.instance
        .collection('groups')
        .document(widget.gid)
        .collection('reviews')
        // .document()
        // .delete();
        .document(snapshot.data['postId'])
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

  showCategory(DocumentSnapshot snapshot, BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    if (snapshot.data['category'] == 'Entertainment') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            Icons.tv,
            color: Colors.green,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.green),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Social') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            Icons.group,
            color: Colors.blue,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.blue),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Science') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.spaceStation,
            color: Colors.orange,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.orange),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Politics') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.pollBox,
            color: Colors.brown,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.brown),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Technology') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.robot,
            color: Colors.pink,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.pink),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Other') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            Icons.more,
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.grey),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Environment') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.tree,
            color: Colors.greenAccent,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.greenAccent),
          ),
        ),
      );
    } else if (snapshot.data['category'] == 'Sports') {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            MdiIcons.tennisBall,
            color: Colors.purple,
          ),
          backgroundColor: Colors.white,
          label: Text(
            widget.documentSnapshot.data['category'],
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.purple),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Chip(
          avatar: Icon(
            Icons.more,
            color: Colors.grey,
          ),
          backgroundColor: Colors.white,
          label: Text(
            'Other',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
                color: Colors.grey),
          ),
        ),
      );
    }
  }
}
