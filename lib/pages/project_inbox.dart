import 'dart:async';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/project.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/list_activity_feed.dart';
import 'package:Yujai/widgets/list_inbox.dart';
import 'package:Yujai/widgets/list_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../style.dart';

class ProjectInbox extends StatefulWidget {
  final String gid;
  final String name;
  final Team team;
  final Department dept;
  final Project project;
  final User currentuser;
  const ProjectInbox({
    this.gid,
    this.name,
    this.team,
    this.currentuser,
    this.dept,
    this.project,
  });

  @override
  _ProjectInboxState createState() => _ProjectInboxState();
}

class _ProjectInboxState extends State<ProjectInbox> {
  var _repository = Repository();
  User _user;
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
  void initState() {
    super.initState();
    retrieveUserDetails();
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
        backgroundColor: new Color(0xfff6f6f6),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
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
            'Inbox',
            style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: widget.gid != null && _user != null
            ? Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: postImagesWidget(),
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
    return SizedBox(
        height: screenSize.height,
        child:
            //  widget.currentuser.uid == widget.team.currentUserUid ||
            //         widget.currentuser.uid == widget.dept.currentUserUid ||
            //         widget.currentuser.uid == widget.project.currentUserUid
            //     ?
            StreamBuilder(
          stream: Firestore.instance
              .collection('teams')
              .document(widget.gid)
              .collection('departments')
              .document(widget.dept.uid)
              .collection('projects')
              .document(widget.project.uid)
              .collection('inbox')
              .orderBy('timestamp')
              .where('assigned', isEqualTo: widget.currentuser.uid)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              //     if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: ((context, index) =>
                    snapshot.data.documents[index].data['ownerUid'] !=
                            widget.currentuser.uid
                        ? ListItemInbox(
                            documentSnapshot: snapshot.data.documents[index],
                            index: index,
                          )
                        : Container()),
              );
              //   } else {
              //     return Center(
              //       child: shimmer(),
              //      );
              //      }
            } else {
              return Center(
                child: Container(),
              );
            }
          }),
        )
        // : StreamBuilder(
        //     stream: Firestore.instance
        //         .collection('teams')
        //         .document(widget.gid)
        //         .collection('departments')
        //         .document(widget.dept.uid)
        //         .collection('projects')
        //         .document(widget.project.uid)
        //         .collection('members')
        //         .document(widget.currentuser.uid)
        //         .collection('inbox')
        //         .orderBy('timestamp')
        //         //  .where('ownerUid', isEqualTo: widget.currentuser.uid)
        //         .snapshots(),
        //     builder: ((context, snapshot) {
        //       if (snapshot.hasData) {
        //         //     if (snapshot.connectionState == ConnectionState.done) {
        //         return ListView.builder(
        //             controller: _scrollController,
        //             shrinkWrap: true,
        //             itemCount: snapshot.data.documents.length,
        //             itemBuilder: ((context, index) => ListItemInbox(
        //                   documentSnapshot: snapshot.data.documents[index],
        //                   index: index,
        //                 )));
        //         //   } else {
        //         //     return Center(
        //         //       child: shimmer(),
        //         //      );
        //         //      }
        //       } else {
        //         return Center(
        //           child: Container(),
        //         );
        //       }
        //     }),
        //   ),
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
