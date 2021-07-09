import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/group_page.dart';
import 'package:Yujai/pages/team_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

class NestedTabBarGroup extends StatefulWidget {
  final String uid;

  const NestedTabBarGroup({Key key, this.uid}) : super(key: key);

  @override
  _NestedTabBarGroupState createState() => _NestedTabBarGroupState();
}

class _NestedTabBarGroupState extends State<NestedTabBarGroup>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  var _repository = Repository();
  UserModel currentuser, user, followingUser;
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  List<DocumentSnapshot> listEvent = List<DocumentSnapshot>();
  List<DocumentSnapshot> listNews = List<DocumentSnapshot>();
  List<DocumentSnapshot> listJob = List<DocumentSnapshot>();
  List<DocumentSnapshot> listPromotion = List<DocumentSnapshot>();
  UserModel _user = UserModel();
  UserModel currentUser;
  List<Group> groupList = List<Group>();
  List<Group> myGroupList = List<Group>();
  List<Team> myTeamList = List<Team>();
  List<User> companyList = List<User>();
  String query = '';
  ScrollController _scrollController;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3 = ScrollController();
  List<String> followingUIDs = List<String>();
  bool _enabled = true;
  //Offset state <-------------------------------------
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoURL;

      _repository.fetchUserDetailsById(user.uid).then((user) {
        if (!mounted) return;
        setState(() {
          currentUser = user;
        });
      });
      print("USER : ${user.displayName}");
      _repository.fetchAllGroups(user).then((list) {
        if (!mounted) return;
        setState(() {
          groupList = list;
        });
      });
      _repository.fetchMyGroups(user).then((list) {
        if (!mounted) return;
        setState(() {
          myGroupList = list;
        });
      });
      _repository.fetchMyTeams(user).then((list) {
        if (!mounted) return;
        setState(() {
          myTeamList = list;
        });
      });
    });
    _nestedTabController =
        new TabController(length: 3, vsync: this, initialIndex: 0);
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
    _scrollController2 = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController2.offset;
          //force arefresh so the app bar can be updated
        });
      });
  }

  @override
  void dispose() {
    _nestedTabController?.dispose();
    _scrollController?.dispose();
    _scrollController1?.dispose();
    _scrollController2?.dispose();
    _scrollController3?.dispose();
    super.dispose();
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
    double screenHeight = MediaQuery.of(context).size.height;
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      controller: _scrollController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabBar(
          unselectedLabelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            //   fontWeight: FontWeight.bold,
          ),
          controller: _nestedTabController,
          indicatorColor: Colors.purpleAccent,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            //  fontWeight: FontWeight.bold,
          ),
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: 'My Groups',
            ),
            Tab(
              text: 'My Teams',
            ),
            Tab(
              text: 'All Groups',
            ),
          ],
        ),
        Container(
          color: const Color(0xFFf6f6f6),
          height: screenHeight * 0.75,
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              myGroupsList(),
              myTeamsList(),
              groupsList(),
            ],
          ),
        )
      ],
    );
  }

  Widget myGroupsList() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('groups')
            //  .orderBy('timestamp')
            .where('members', arrayContainsAny: [widget.uid]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.docs.length > 0) {
              return ListView.builder(
                //      controller: _scrollController3,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupPage(
                                        currentUser: _user,
                                        isMember: false,
                                        gid: snapshot.data.docs[index]['uid'],
                                        name: snapshot.data.docs[index]
                                            ['groupName'],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: 8.0,
                          ),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: const Color(0xffffffff),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                //  side: BorderSide(color: Colors.grey[300]),
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(snapshot
                                    .data.docs[index]['groupProfilePhoto']),
                              ),
                              title: Text(
                                // userList[index].toString(),
                                snapshot.data.docs[index]['groupName'],
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              trailing:
                                  snapshot.data.docs[index]['isPrivate'] == true
                                      ? Icon(Icons.lock_outline)
                                      : Icon(Icons.public),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              );
            }
            return NoContent('No groups', 'assets/images/group_no-image.png',
                'Create a group', ' by clicking on the + icon above');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    // return ListView.builder(
    //         //      controller: _scrollController3,
    //         itemCount: myGroupList.length,
    //         itemBuilder: ((context, index) {
    //           return Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               InkWell(
    //                 onTap: () {
    //                   Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (context) => GroupPage(
    //                                 currentUser: _user,
    //                                 isMember: false,
    //                                 gid: myGroupList[index].uid,
    //                                 name: myGroupList[index].groupName,
    //                               )));
    //                 },
    //                 child: Padding(
    //                   padding: const EdgeInsets.only(
    //                     left: 8.0,
    //                     right: 8.0,
    //                     top: 8.0,
    //                   ),
    //                   child: Container(
    //                     decoration: ShapeDecoration(
    //                       color: const Color(0xffffffff),
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(12.0),
    //                         //  side: BorderSide(color: Colors.grey[300]),
    //                       ),
    //                     ),
    //                     child: ListTile(
    //                       leading: CircleAvatar(
    //                         backgroundColor: Colors.white,
    //                         backgroundImage: NetworkImage(
    //                             myGroupList[index].groupProfilePhoto),
    //                       ),
    //                       title: Text(
    //                         // userList[index].toString(),
    //                         myGroupList[index].groupName,
    //                         style: TextStyle(
    //                           fontFamily: FontNameDefault,
    //                           fontSize: textSubTitle(context),
    //                         ),
    //                       ),
    //                       trailing: myGroupList[index].isPrivate == true
    //                           ? Icon(Icons.lock_outline)
    //                           : Icon(Icons.public),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           );
    //         }),
    //       );
    // : NoContent('No groups', 'assets/images/group_no-image.png',
    //     'Create a group', ' by clicking on the + icon above');
  }

  Widget myTeamsList() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teams')
            .orderBy('timestamp')
            .where('members', arrayContainsAny: [widget.uid]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.docs.length > 0) {
              return ListView.builder(
                //  controller: _scrollController1,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeamPage(
                                        currentUser: currentUser,
                                        isMember: false,
                                        gid: snapshot.data.docs[index]['uid'],
                                        name: snapshot.data.docs[index]
                                            ['teamName'],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: 8.0,
                          ),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: const Color(0xffffffff),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                //  side: BorderSide(color: Colors.grey[300]),
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data.docs[index]
                                        ['teamProfilePhoto']),
                              ),
                              title: Text(
                                // userList[index].toString(),
                                snapshot.data.docs[index]['teamName'],
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              trailing: Icon(Icons.work_outline),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              );
            }
            return NoContent('No teams', 'assets/images/team_no-image.png',
                'Contact ur company for team access', '');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget shimmerPromotion() {
    return Container(
        color: const Color(0xffffffff),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Shimmer.fromColors(
              child: ListView.builder(
                controller: _scrollController2,
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40.0)),
                              width: 60.0,
                              height: 60.0,
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
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0)),
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
              highlightColor: Colors.grey[100],
            ),
          ),
        ]));
  }

  Widget groupsList() {
    var screenSize = MediaQuery.of(context).size;
    return groupList.length > 0
        ? ListView.builder(
            controller: _scrollController3,
            itemCount: groupList.length,
            itemBuilder: ((context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupPage(
                                    currentUser: _user,
                                    isMember: false,
                                    gid: groupList[index].uid,
                                    name: groupList[index].groupName,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 8.0,
                      ),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: const Color(0xffffffff),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            //  side: BorderSide(color: Colors.grey[300]),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                groupList[index].groupProfilePhoto),
                          ),
                          title: Text(
                            // userList[index].toString(),
                            groupList[index].groupName,
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context),
                            ),
                          ),
                          trailing: groupList[index].isPrivate == true
                              ? Icon(Icons.lock_outline)
                              : Icon(Icons.public),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          )
        : NoContent('No groups', 'assets/images/group_no-image.png',
            'Create a group', ' by clicking on the + icon above');
  }
}
