import 'dart:async';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/group_invite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../style.dart';

class GroupRequest extends StatefulWidget {
  final String gid;
  final String name;
  final Group group;
  final UserModel currentuser;
  const GroupRequest({this.gid, this.name, this.group, this.currentuser});

  @override
  _GroupRequestState createState() => _GroupRequestState();
}

class _GroupRequestState extends State<GroupRequest> {
  IconData icon;
  Color color;
  final TextStyle style =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  bool _enabled = true;
  StreamSubscription<DocumentSnapshot> subscription;

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    _scrollController?.dispose();
    _scrollController1?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xfff6f6f6),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.015,
                horizontal: screenSize.width / 50,
              ),
              child: FlatButton(
                  //disabledColor: Theme.of(context).accentColor,
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupInvite(
                                  gid: widget.gid,
                                  name: widget.name,
                                  group: widget.group,
                                )));
                  },
                  child: Text(
                    'Invite',
                    style: TextStyle(
                        fontSize: textBody1(context),
                        fontFamily: FontNameDefault,
                        color: Colors.white),
                  )),
            ),
          ],
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () => Navigator.pop(context)),
          //    centerTitle: true,
          backgroundColor: const Color(0xffffffff),
          title: Text(
            'Group Requests',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: postImagesWidget(),
        ),
      ),
    );
  }

  Widget shimmer() {
    return Container(
      color: const Color(0xffffffff),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: Shimmer.fromColors(
              child: ListView.builder(
                controller: _scrollController1,
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40.0)),
                              width: 40.0,
                              height: 40.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80.0,
                                    height: 12.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 120.0,
                                    height: 12.0,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ]),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0)),
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0)),
                      Divider(thickness: 4.0, color: Colors.white)
                    ],
                  ),
                ),
                itemCount: 6,
              ),
              enabled: _enabled,
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100]),
        ),
      ]),
    );
  }

  Widget postImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.gid)
          .collection('requests')
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
              height: screenSize.height,
              child: ListView.builder(
                  controller: _scrollController,
                  //shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: const Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              // side: BorderSide(color: Colors.grey[300]),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenSize.height * 0.01,
                                        right: screenSize.width / 30),
                                    child: Text(
                                        snapshot.data.documents[index]
                                                    .data['time'] !=
                                                null
                                            ? timeago.format(snapshot.data
                                                .documents[index].data['time']
                                                .toDate())
                                            : '',
                                        style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textbody2(context),
                                            color: Colors.grey)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: screenSize.width / 30,
                                      top: screenSize.height * 0.02,
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(snapshot
                                              .data
                                              .documents[index]
                                              .data['ownerPhotoUrl']),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: screenSize.width / 30,
                                      top: screenSize.height * 0.02,
                                    ),
                                    child: Text(
                                      snapshot.data.documents[index]
                                          .data['ownerName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: FontNameDefault,
                                          fontSize: textSubTitle(context)),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: screenSize.width / 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FlatButton(
                                        //disabledColor: Theme.of(context).accentColor,
                                        color: Theme.of(context).accentColor,
                                        onPressed: () => joinGroup(
                                            snapshot.data.documents[index]),
                                        child: Text(
                                          'Approve',
                                          style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context),
                                              color: Colors.white),
                                        )),
                                    FlatButton(
                                        // disabledColor: Colors.grey[200],
                                        color: Colors.grey[200],
                                        onPressed: () =>
                                            removeInviteToActivityFeed(
                                                snapshot.data.documents[index]),
                                        child: Text(
                                          'Decline',
                                          style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              fontSize: textBody1(context),
                                              color: Colors.black),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))));
          //   } else {
          //     return Center(
          //       child: shimmer(),
          //      );
          //      }
        } else {
          return Center(
            child: shimmer(),
          );
        }
      }),
    );
  }

  Widget detailsWidget(String count, String label) {
    return Column(
      children: <Widget>[
        Text(count,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black)),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child:
              Text(label, style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        )
      ],
    );
  }

  joinGroup(DocumentSnapshot snapshot) async {
    var _member = Member(
      ownerName: snapshot['ownerName'],
      ownerUid: snapshot['ownerUid'],
      ownerPhotoUrl: snapshot['ownerPhotoUrl'],
      accountType: 'Member',
      timestamp: FieldValue.serverTimestamp(),
    );
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.gid)
        .collection('members')
        .doc(snapshot['ownerUid'])
        .set(_member.toMap(_member));

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.gid)
        .update({
      'members': FieldValue.arrayUnion([snapshot['ownerUid']])
    }).then((value) => removeInviteToActivityFeed(snapshot));
  }

  removeInviteToActivityFeed(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.gid)
        .collection('requests')
        // .document(currentUser.uid)
        // .collection('likes')
        .doc(snapshot['ownerUid'])
        .delete()
        .then((value) {
      print('Group Invite sent');
    });
  }
}
