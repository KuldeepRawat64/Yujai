import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/education_widget.dart';
import 'package:Yujai/widgets/flow_widget.dart';
import 'package:Yujai/widgets/skill_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class PromotionDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;

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
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.more_vert),
          //     onPressed: null,
          //   )
          // ],
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
    DateTime myDateTime = widget.documentSnapshot['time'] != null
        ? (widget.documentSnapshot['time']).toDate()
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            widget.documentSnapshot['promotionOwnerPhotoUrl'],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: screenSize.height * 0.01),
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
                            padding:
                                EdgeInsets.only(top: screenSize.height * 0.005),
                            child: Text(
                              widget.documentSnapshot['caption'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontSize: textHeader(context)),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: screenSize.height * 0.005),
                            child: Text(
                              widget.documentSnapshot['promotionOwnerName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: FontNameDefault,
                                //fontSize: textSubTitle(context)
                              ),
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
                                widget.documentSnapshot['location'],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: FontNameDefault,
                                  //fontSize: textBody1(context)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  widget.documentSnapshot['portfolio'] != ''
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyWebView(
                                            title: 'Portfolio',
                                            selectedUrl: widget
                                                .documentSnapshot['portfolio'],
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
                    widget.documentSnapshot['description'],
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: textBody1(context)),
                  ),
                ],
              ),
            ),
            widget.documentSnapshot['skills'] != null ||
                    widget.documentSnapshot['skills'] != []
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenSize.width / 30,
                            top: screenSize.height * 0.012,
                          ),
                          child: Text(
                            'Skills',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textHeader(context),
                              //    color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return SkillEventRow(SkillEvent(
                                skill: widget.documentSnapshot['skills'][index]
                                    ['skill'],
                                level: widget.documentSnapshot['skills'][index]
                                    ['level']));
                          },
                          itemCount: widget.documentSnapshot['skills'].length),
                    ],
                  )
                : Container(),
            widget.documentSnapshot['experience'] != [] ||
                    widget.documentSnapshot['experience'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenSize.width / 30,
                            top: screenSize.height * 0.012,
                          ),
                          child: Text(
                            'Experience',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textHeader(context),
                              //    color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        // margin: EdgeInsets.symmetric(
                        //     horizontal: screenSize.width * 0.2,
                        //     vertical: screenSize.height * 0.02
                        //     ),
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Positioned(
                                left: 21,
                                top: 15,
                                bottom: 15,
                                child: VerticalDivider(
                                  width: 1,
                                  color: Colors.black54,
                                )),
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (BuildContext context, int index) {
                                  return FlowEventRow(FlowEvent(
                                      employmentType:
                                          widget.documentSnapshot['experience']
                                              [index]['employmentType'],
                                      isPresent: widget.documentSnapshot['experience']
                                          [index]['isPresent'],
                                      industry: widget.documentSnapshot['experience']
                                          [index]['industry'],
                                      company: widget.documentSnapshot['experience']
                                          [index]['company'],
                                      designation: widget.documentSnapshot['experience']
                                          [index]['designation'],
                                      startDate: widget.documentSnapshot['experience']
                                          [index]['startCompany'],
                                      endDate: widget.documentSnapshot['experience']
                                          [index]['endCompany']));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 2,
                                  );
                                },
                                itemCount: widget
                                    .documentSnapshot['experience'].length)
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.documentSnapshot['education'] != [] ||
                    widget.documentSnapshot['education'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenSize.width / 30,
                            top: screenSize.height * 0.012,
                          ),
                          child: Text(
                            'Education',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textHeader(context),
                              //    color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width / 30),
                        child: Card(
                          elevation: 0,
                          // margin: EdgeInsets.symmetric(
                          //     horizontal: screenSize.width * 0.035,
                          //     vertical: screenSize.height * 0.02),
                          child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) {
                                return FlowEducationRow(FlowEducation(
                                    isPresent:
                                        widget.documentSnapshot['education']
                                            [index]['isPresent'],
                                    university:
                                        widget.documentSnapshot['education']
                                            [index]['university'],
                                    degree: widget.documentSnapshot['education']
                                        [index]['degree'],
                                    field: widget.documentSnapshot['education']
                                        [index]['field'],
                                    startDate:
                                        widget.documentSnapshot['education']
                                            [index]['startUniversity'],
                                    endDate: widget.documentSnapshot['education']
                                        [index]['endUniversity']));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 2,
                                );
                              },
                              itemCount:
                                  widget.documentSnapshot['education'].length),
                        ),
                      ),
                    ],
                  )
                : Container(),
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
                      fontSize: textHeader(context),
                      //    color: Colors.black45,
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
                          widget.documentSnapshot['promotionOwnerPhotoUrl'],
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenSize.width / 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.documentSnapshot['promotionOwnerName'],
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
                                if (widget.documentSnapshot['ownerUid'] !=
                                    widget.currentuser.uid)
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FriendProfileScreen(
                                            uid: widget
                                                .documentSnapshot['ownerUid'],
                                            name: widget.documentSnapshot[
                                                'promotionOwnerName'],
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
