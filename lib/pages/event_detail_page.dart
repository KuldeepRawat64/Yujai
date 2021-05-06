import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/image_detail.dart';

import '../style.dart';

class EventDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;

  EventDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        appBar: AppBar(
          elevation: 0.5,
          //   centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: const Color(0xffffffff),
          title: Text(
            'Details',
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: textAppTitle(context),
                fontFamily: FontNameDefault),
          ),
        ),
        body: eventStack(),
      ),
    );
  }

  Widget eventStack() {
    var screenSize = MediaQuery.of(context).size;
    String toLaunch = widget.documentSnapshot.data['ticketWebsite'];
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(2.0, 2.0),
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset.zero,
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  )
                ], borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      fit: StackFit.loose,
                      alignment: Alignment.bottomLeft,
                      children: [
                        widget.documentSnapshot.data['imgUrl'] != ''
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ImageDetail(
                                            image: widget.documentSnapshot
                                                .data['imgUrl'],
                                          )));
                                },
                                child: Container(
                                  height: screenSize.height * 0.17,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget
                                              .documentSnapshot.data['imgUrl'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: screenSize.height * 0.17,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.deepPurple,
                                        Colors.black54,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenSize.width / 30,
                            bottom: screenSize.height * 0.012,
                          ),
                          child: CircleAvatar(
                            radius: screenSize.height * 0.05,
                            backgroundColor: Colors.grey,
                            backgroundImage: CachedNetworkImageProvider(widget
                                .documentSnapshot.data['eventOwnerPhotoUrl']),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenSize.width / 30,
                        top: screenSize.height * 0.012,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InstaFriendProfileScreen(
                                  uid: widget.documentSnapshot.data['ownerUid'],
                                  name: widget.documentSnapshot
                                      .data['evenOwnerName'])));
                        },
                        child: Text(
                          widget.documentSnapshot.data['eventOwnerName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontNameDefault,
                            color: Colors.black,
                            fontSize: textSubTitle(context),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenSize.width / 30,
                        top: screenSize.height * 0.012,
                      ),
                      child: widget.documentSnapshot.data['location'] != '' &&
                              widget.documentSnapshot.data['venue'] != ''
                          ? Text(
                              widget.documentSnapshot.data['location'],
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                fontStyle: FontStyle.normal,
                                color: Colors.grey,
                              ),
                            )
                          : Text(
                              'Online',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                fontStyle: FontStyle.normal,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenSize.height * 0.012),
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width / 30),
                      child: Text(
                        widget.documentSnapshot.data['caption'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: FontNameDefault,
                          fontSize: textSubTitle(context),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: RaisedButton(
                            splashColor: Colors.yellow,
                            shape: StadiumBorder(),
                            color: Colors.deepPurple,
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyWebView(
                                        title: 'Register for Event',
                                        selectedUrl: toLaunch,
                                      )));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                      fontSize: textSubTitle(context),
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.012,
                bottom: screenSize.height * 0.012,
                left: screenSize.width / 30,
              ),
              child: Wrap(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.documentSnapshot.data['description'],
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: textBody1(context),
                    ),
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
            widget.documentSnapshot.data['agenda'] != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: screenSize.width / 30,
                          bottom: screenSize.height * 0.012,
                        ),
                        width: screenSize.width,
                        child: Padding(
                          padding: EdgeInsets.only(
                            //   left: screenSize.width / 30,
                            top: screenSize.height * 0.012,
                          ),
                          child: Text(
                            'Agenda',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenSize.height * 0.012,
                          bottom: screenSize.height * 0.012,
                          left: screenSize.width / 30,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.documentSnapshot.data['agenda'],
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontSize: textBody1(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
              ),
              child: Container(
                height: screenSize.height * 0.01,
                color: Colors.grey[200],
              ),
            ),
            Container(
              color: Colors.white,
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width / 30,
                      top: screenSize.height * 0.012,
                      bottom: screenSize.height * 0.012,
                    ),
                    child: Text(
                      'Event Type',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width / 30,
                      top: screenSize.height * 0.012,
                      bottom: screenSize.height * 0.012,
                    ),
                    child: Text(
                      widget.documentSnapshot.data['type'],
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black87),
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
                    padding: EdgeInsets.only(
                      left: screenSize.width / 30,
                      top: screenSize.height * 0.012,
                      bottom: screenSize.height * 0.012,
                    ),
                    child: Text(
                      'Event Category',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.012,
                      bottom: screenSize.height * 0.012,
                      left: screenSize.width / 30,
                    ),
                    child: Text(
                      widget.documentSnapshot.data['category'],
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black87),
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
                    padding: EdgeInsets.only(
                      left: screenSize.width / 30,
                      top: screenSize.height * 0.012,
                      bottom: screenSize.height * 0.012,
                    ),
                    child: Text(
                      'Venue',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenSize.height * 0.012,
                          left: screenSize.width / 30,
                          bottom: screenSize.height * 0.012,
                        ),
                        child: Text(
                          widget.documentSnapshot.data['venue'] != ''
                              ? widget.documentSnapshot.data['venue']
                              : 'Online',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.black87),
                        ),
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
                    'Organiser',
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
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.012,
                bottom: screenSize.height * 0.012,
              ),
              child: Text(
                widget.documentSnapshot.data['organiser'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                ),
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
                          fontSize: textSubTitle(context),
                        ),
                      ),
                      RaisedButton(
                        splashColor: Colors.yellow,
                        shape: StadiumBorder(),
                        color: Colors.deepPurple,
                        child: Text(
                          'Discuss',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CommentsScreen(
                                        commentType: 'commentEvent',
                                        snapshot: widget.documentSnapshot,
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
      ],
    );
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
