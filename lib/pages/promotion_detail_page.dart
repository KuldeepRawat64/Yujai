import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class PromotionDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;

  PromotionDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  _PromotionDetailScreenState createState() => _PromotionDetailScreenState();
}

class _PromotionDetailScreenState extends State<PromotionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        appBar: AppBar(
          elevation: 0.5,
          //     centerTitle: true,
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
                fontFamily: FontNameDefault,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: textAppTitle(context)),
          ),
        ),
        body: promoStack(),
      ),
    );
  }

  Widget promoStack() {
    var screenSize = MediaQuery.of(context).size;
    DateTime myDateTime = widget.documentSnapshot.data['time'] != null
        ? (widget.documentSnapshot.data['time']).toDate()
        : DateTime.now();
    //  String toLaunch = widget.documentSnapshot.data['portfolio'];
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          offset: Offset(1.0, 1.0),
                          spreadRadius: 1.0,
                          blurRadius: 1.0),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset.zero,
                          spreadRadius: 0,
                          blurRadius: 0)
                    ]),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width / 30,
                            vertical: screenSize.height * 0.012,
                          ),
                          child: CircleAvatar(
                            radius: screenSize.height * 0.045,
                            backgroundColor: Colors.grey,
                            backgroundImage: CachedNetworkImageProvider(
                              widget.documentSnapshot
                                  .data['promotionOwnerPhotoUrl'],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.01),
                              child: Text(
                                DateFormat.yMMMd().add_jm().format(myDateTime),
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black54,
                                    fontSize: textbody2(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.005),
                              child: Text(
                                widget.documentSnapshot.data['caption'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.005),
                              child: Text(
                                widget.documentSnapshot
                                    .data['promotionOwnerName'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    widget.documentSnapshot.data['portfolio'] != ''
                        ? Padding(
                            padding: EdgeInsets.all(screenSize.height * 0.012),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  splashColor: Colors.yellow,
                                  shape: StadiumBorder(),
                                  color: Colors.deepPurple,
                                  child: Text(
                                    'Portfolio',
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => MyWebView(
                                                  title: 'Portfolio',
                                                  selectedUrl: widget
                                                      .documentSnapshot
                                                      .data['portfolio'],
                                                )));
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(left: screenSize.width / 30),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: screenSize.height * 0.04,
                            color: Colors.black54,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width / 30),
                            child: Text(
                              widget.documentSnapshot.data['location'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.005,
                        left: screenSize.width / 30,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: screenSize.height * 0.04,
                            color: Colors.black54,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width / 30),
                            child: Text(
                              widget.documentSnapshot.data['timing'],
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.005,
                        left: screenSize.width / 30,
                        bottom: screenSize.height * 0.012,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.business,
                            size: screenSize.height * 0.04,
                            color: Colors.black54,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width / 30),
                            child: Text(
                              widget.documentSnapshot.data['category'],
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    top: screenSize.height * 0.012,
                  ),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: textSubTitle(context)),
                  ),
                ),
              ),
            ),
            Container(
              width: screenSize.width,
              color: Colors.white,
              padding: EdgeInsets.only(
                bottom: screenSize.height * 0.012,
                left: screenSize.width / 30,
                //   top: screenSize.height * 0.012,
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
            Container(
              color: Colors.white,
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenSize.height * 0.01,
                        left: screenSize.width / 30,
                        bottom: screenSize.height * 0.01),
                    child: Text(
                      'Preffered locations',
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
                          left: screenSize.width / 30,
                          bottom: screenSize.height * 0.012,
                        ),
                        child: Text(
                          widget.documentSnapshot.data['locations'],
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
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
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    top: screenSize.height * 0.012,
                  ),
                  child: Text(
                    'Skills',
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
                left: screenSize.width / 30,
                //  top: screenSize.height * 0.012,
                bottom: screenSize.height * 0.012,
              ),
              child: Wrap(
                children: [
                  Text(
                    widget.documentSnapshot.data['skills'],
                    style: TextStyle(
                        fontFamily: FontNameDefault,
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
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    top: screenSize.height * 0.012,
                  ),
                  child: Text(
                    'Contact',
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
                bottom: screenSize.height * 0.06,
                top: screenSize.height * 0.015,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width / 30),
                    child: CircleAvatar(
                        radius: screenSize.height * 0.045,
                        backgroundColor: Colors.grey,
                        backgroundImage: CachedNetworkImageProvider(
                          widget
                              .documentSnapshot.data['promotionOwnerPhotoUrl'],
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width / 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.documentSnapshot.data['promotionOwnerName'],
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            RaisedButton(
                              splashColor: Colors.yellow,
                              shape: StadiumBorder(),
                              color: Colors.deepPurple,
                              child: Text(
                                'Contact',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    fontSize: textButton(context),
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        InstaFriendProfileScreen(
                                          uid: widget.documentSnapshot
                                              .data['ownerUid'],
                                          name: widget.documentSnapshot
                                              .data['promotionOwnerName'],
                                        )));
                              },
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
