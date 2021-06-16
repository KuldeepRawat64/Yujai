import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class JobDetailScreen extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;

  JobDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        appBar: AppBar(
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
        body: JobDetail(documentSnapshot: documentSnapshot),
      ),
    );
  }
}

class JobDetail extends StatelessWidget {
  const JobDetail({
    Key key,
    @required this.documentSnapshot,
  }) : super(key: key);

  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    DateTime myDateTime = documentSnapshot['time'] != null
        ? (documentSnapshot['time']).toDate()
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
                            documentSnapshot['jobOwnerPhotoUrl']),
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
                          documentSnapshot['caption'],
                          style: TextStyle(
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
                          documentSnapshot['jobOwnerName'],
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: textSubTitle(context)),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Text(
                            documentSnapshot['location'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: FontNameDefault,
                              //fontSize: textBody1(context)
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              documentSnapshot['website'] != ''
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
                                            selectedUrl:
                                                documentSnapshot['website'],
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
        Container(
          color: Colors.white,
          width: screenSize.width,
          padding: EdgeInsets.only(
            left: screenSize.width / 30,
            bottom: screenSize.height * 0.012,
            top: screenSize.height * 0.012,
          ),
          child: Wrap(
            children: [
              Text(
                documentSnapshot['description'],
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.02,
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
                    documentSnapshot['jobOwnerPhotoUrl']),
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
                                  uid: documentSnapshot['ownerUid'],
                                  name: documentSnapshot['jobOwnerName'],
                                )));
                      },
                      child: Text(
                        documentSnapshot['jobOwnerName'],
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
                                        uid: documentSnapshot['ownerUid'],
                                        name: documentSnapshot['jobOwnerName'],
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
}
