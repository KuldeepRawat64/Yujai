import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/image_detail.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class EventDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;

  EventDetailScreen({this.documentSnapshot, this.user, this.currentuser});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  var _repository = Repository();
  bool seeMore = false;
  convertDate(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }

  convertTime(int timeinMilis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeinMilis);
    var formattedDate = DateFormat.jm().format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        body: CustomScrollView(
          slivers: [
            // SliverAppBar(
            //   leading: IconButton(
            //       icon: Icon(Icons.keyboard_arrow_left,
            //           color: Colors.white, size: screenSize.height * 0.045),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       }),
            //   actions: [
            //     IconButton(
            //         icon: Icon(Icons.more_horiz, color: Colors.white),
            //         onPressed: null)
            //   ],
            //   floating: true,
            //   backgroundColor: Color(0xFFEDF2F8),
            //   expandedHeight: screenSize.height * 0.2,
            //   flexibleSpace: FlexibleSpaceBar(
            //     background: CachedNetworkImage(
            //         fit: BoxFit.cover,
            //         imageUrl: widget.documentSnapshot.data['imgUrl']),
            //   ),
            // ),
            SliverList(delegate: SliverChildListDelegate([eventStack()]))
          ],
        ),
      ),
    );
  }

  Widget eventBody() {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: screenSize.height * 0.25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenSize.height * 0.025,
                    left: screenSize.height * 0.05,
                    right: screenSize.height * 0.05,
                    bottom: screenSize.height * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              widget.documentSnapshot['eventOwnerPhotoUrl']),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenSize.width * 0.3,
                              child: Text(
                                widget.documentSnapshot['caption'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontSize: textH1(context),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.01,
                            ),
                            widget.documentSnapshot['website'] != '' &&
                                    widget.documentSnapshot['website'] != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => MyWebView(
                                                  title: 'Event',
                                                  selectedUrl:
                                                      widget.documentSnapshot[
                                                          'website'])));
                                    },
                                    child: Container(
                                      width: screenSize.width * 0.6,
                                      child: Text(
                                        widget.documentSnapshot['website'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: FontNameDefault,
                                          color: Theme.of(context).accentColor,
                                          fontSize: textSubTitle(context),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.today_outlined,
                            color: Colors.black87,
                            size: screenSize.height * 0.04,
                          ),
                          onPressed: null,
                        ),
                        SizedBox(
                          width: screenSize.height * 0.02,
                        ),
                        Container(
                          width: screenSize.width * 0.5,
                          child: Text(
                            '${convertDate(widget.documentSnapshot['startDate'])}, ${convertTime(widget.documentSnapshot['startTime'])} - ${convertDate(widget.documentSnapshot['endDate'])}, ${convertTime(widget.documentSnapshot['endTime'])}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.location_on_outlined,
                            color: Colors.black87,
                            size: screenSize.height * 0.04,
                          ),
                          onPressed: null,
                        ),
                        SizedBox(
                          width: screenSize.height * 0.02,
                        ),
                        Container(
                          width: screenSize.width * 0.5,
                          child: Text(
                            widget.documentSnapshot['city'] == '' ||
                                    widget.documentSnapshot['city'] == null
                                ? 'Online'
                                : widget.documentSnapshot['city'],
                            style: TextStyle(
                              color: Colors.black,
                              //    fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenSize.height * 0.01,
                          left: screenSize.width * 0.01,
                          right: screenSize.width * 0.01),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyWebView(
                                        title: ' Registration',
                                        selectedUrl: widget
                                            .documentSnapshot['ticketWebsite'],
                                      )));
                        },
                        child: Container(
                            height: screenSize.height * 0.07,
                            width: screenSize.width * 0.8,
                            decoration: ShapeDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0))),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(screenSize.height * 0.015),
                              child: Center(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textAppTitle(context),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: screenSize.height * 0.01,
            //   ),
            //   child: Container(
            //     height: screenSize.height * 0.005,
            //     color: Colors.grey[200],
            //   ),
            // ),
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
                      fontSize: textHeader(context),
                      //  color: Colors.black45,
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
              child:
                  widget.documentSnapshot['description'].toString().length < 350
                      ? Text(
                          widget.documentSnapshot['description'],
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: textSubTitle(context)),
                        )
                      : seeMore
                          ? Wrap(
                              children: [
                                Text(
                                  widget.documentSnapshot['description'],
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: textSubTitle(context)),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      seeMore = false;
                                    });
                                  },
                                  child: Text(
                                    'See less',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: FontNameDefault,
                                        fontSize: textSubTitle(context),
                                        color: Theme.of(context).accentColor),
                                  ),
                                )
                              ],
                            )
                          : Wrap(
                              children: [
                                Text(
                                  widget.documentSnapshot['description']
                                      .toString()
                                      .substring(350),
                                  //  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      seeMore = true;
                                    });
                                  },
                                  child: Text(
                                    'See more',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: FontNameDefault,
                                        fontSize: textSubTitle(context),
                                        color: Theme.of(context).accentColor),
                                  ),
                                )
                              ],
                            ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: screenSize.height * 0.01,
            //   ),
            //   child: Container(
            //     height: screenSize.height * 0.005,
            //     color: Colors.grey[200],
            //   ),
            // ),
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
                    'Speakers',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                //    left: screenSize.width / 30,
                bottom: screenSize.height * 0.012,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  widget.documentSnapshot['host'],
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: screenSize.height * 0.01,
            //   ),
            //   child: Container(
            //     height: screenSize.height * 0.005,
            //     color: Colors.grey[200],
            //   ),
            // ),
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
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (widget.documentSnapshot['ownerUid'] !=
                    widget.currentuser.uid) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FriendProfileScreen(
                          uid: widget.documentSnapshot['ownerUid'],
                          name: widget.documentSnapshot['eventOwnerName'])));
                }
              },
              child: Container(
                child: ListTile(
                  //  subtitle: Text(''),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        widget.documentSnapshot['eventOwnerPhotoUrl']),
                  ),
                  title: Text(
                    widget.documentSnapshot['eventOwnerName'],
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: screenSize.height * 0.01,
            //   ),
            //   child: Container(
            //     height: screenSize.height * 0.005,
            //     color: Colors.grey[200],
            //   ),
            // ),
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
                          fontSize: textHeader(context),
                        ),
                      ),
                      RaisedButton(
                        splashColor: Colors.yellow,
                        shape: StadiumBorder(),
                        color: Colors.deepPurple,
                        child: Text(
                          'Discuss',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textButton(context),
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CommentsScreen(
                                        isGroupFeed: true,
                                        documentReference:
                                            widget.documentSnapshot.reference,
                                        user: widget.currentuser,
                                        snapshot: widget.documentSnapshot,
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
      ),
    );
  }

  Widget eventStack() {
    String toLaunch = widget.documentSnapshot['website'];
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.topCenter,
      children: [
        Positioned(child: eventHeader()),
        Positioned(child: eventBody()),
      ],
    );
  }

  Widget eventHeader() {
    return Container(
      color: Colors.grey,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          CachedNetworkImage(
            imageUrl: widget.documentSnapshot['imgUrl'],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.keyboard_arrow_left_outlined)),
            ),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.more_vert_outlined),
            ),
          )
        ],
      ),
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
