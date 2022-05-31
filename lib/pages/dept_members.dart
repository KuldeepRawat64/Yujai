import 'dart:async';
import 'package:Yujai/models/department.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/list_member_dept.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../style.dart';

class DeptMembers extends StatefulWidget {
  final String gid;
  final String name;
  final Team group;
  final Department dept;
  final UserModel currentuser;
  const DeptMembers(
      {this.gid, this.name, this.group, this.currentuser, this.dept});

  @override
  _DeptMembersState createState() => _DeptMembersState();
}

class _DeptMembersState extends State<DeptMembers> {
  var _repository = Repository();
  UserModel _user;
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
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
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
            'Members',
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.gid)
          .collection('departments')
          .doc(widget.dept.uid)
          .collection('members')
          .orderBy('accountType')
          .orderBy('ownerName')
          .snapshots(),
      // builder: ((context, snapshot) {
      //   if (snapshot.hasData) {
      //     //     if (snapshot.connectionState == ConnectionState.done) {
      //     return SizedBox(
      //         height: screenSize.height,
      //         child: ListView.builder(
      //             controller: _scrollController,
      //             //shrinkWrap: true,
      //             itemCount: snapshot.data.documents.length,
      //             itemBuilder: ((context, index) => ListItemMemberDept(
      //                 dept: widget.dept,
      //                 team: widget.group,
      //                 gid: widget.gid,
      //                 name: widget.name,
      //                 documentSnapshot: snapshot.data.documents[index],
      //                 index: index,
      //                 currentuser: _user,
      //                 user: _user))));
      //     //   } else {
      //     //     return Center(
      //     //       child: shimmer(),
      //     //      );
      //     //      }
      //   } else {
      //     return Center(
      //       child: shimmer(),
      //     );
      //   }
      // }),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const NoContent('Error', 'assets/images/error.png',
                'Something wrong happened', '');
          } else if (snapshot.hasData && snapshot.data.docs.length > 0) {
            return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                //  controller: _scrollController,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) =>
                    //  Text(snapshot.data.docs[index]['postId']))
                    ListItemMemberDept(
                        dept: widget.dept,
                        team: widget.group,
                        gid: widget.gid,
                        name: widget.name,
                        documentSnapshot: snapshot.data.docs[index],
                        index: index,
                        currentuser: _user,
                        user: _user)));
          } else {
            return NoContent('No members', 'assets/images/members.png', '', '');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
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
