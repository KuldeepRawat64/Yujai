import 'dart:async';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/list_post.dart';
import 'package:Yujai/widgets/list_post_forum.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

class GroupActivity extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final User currentUser;
  final Group group;

  const GroupActivity(
      {Key key,
      this.gid,
      this.name,
      this.isMember,
      this.currentUser,
      this.group})
      : super(key: key);

  @override
  _GroupActivityState createState() => _GroupActivityState();
}

class _GroupActivityState extends State<GroupActivity> {
  var _repository = Repository();
  User _user;
  IconData icon;
  Color color;
  final TextStyle style =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  ScrollController _scrollController1;
  bool _enabled = true;
  StreamSubscription<DocumentSnapshot> subscription;
  //Offset state <-------------------------------------
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
    _scrollController1 = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController1.offset;
          //force arefresh so the app bar can be updated
        });
      });
    icon = MdiIcons.heart;
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    _scrollController?.dispose();
    _scrollController1?.dispose();
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () => Navigator.pop(context)),
          elevation: 0.5,
          backgroundColor: const Color(0xffffffff),
          title: Text(
            'Activity',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: _user != null
            ? Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: forumWidget(),
              )
            : Center(child: CircularProgressIndicator()),
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

  Widget forumWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('groups')
          .document(widget.gid)
          .collection('posts')
          .orderBy('time', descending: true)
          .where('ownerUid', isEqualTo: widget.currentUser.uid)
          .snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: shimmer(),
          );
        } else {
          if (snapshot.data.documents.isEmpty) {
            if (snapshot.data.documents.isEmpty) {
              return NoContent(
                  'No activity',
                  'assets/images/picture.png',
                  false,
                  'Posts, polls and Discussions created by you will appear here',
                  '\n<-- To Create Post -->\n<-- Go to Group -->\n<-- Press the + button -->\n<-- Upload Post --> or \n<-- Start Discussion --> or \n<-- Create Poll -->');
            }

            //NoContent('assets/images/no_content.svg', 'No activity');
          }
          return SizedBox(
            height: screenSize.height * 0.9,
            child: ListView.builder(
              controller: _scrollController,
              //shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) => ListPostForum(
                  documentSnapshot: snapshot.data.documents[index],
                  index: index,
                  currentuser: widget.currentUser,
                  group: widget.group,
                  gid: widget.gid,
                  name: widget.name)),
            ),
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
}
