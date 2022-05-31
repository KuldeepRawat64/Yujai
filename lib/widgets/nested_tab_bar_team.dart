import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/group_page.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../style.dart';

class NestedTabBarTeam extends StatefulWidget {
  @override
  _NestedTabBarTeamState createState() => _NestedTabBarTeamState();
}

class _NestedTabBarTeamState extends State<NestedTabBarTeam>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  var _repository = Repository();
  UserModel currentuser, user, followingUser;
  List<DocumentSnapshot> list = [];
  List<DocumentSnapshot> listEvent = [];
  List<DocumentSnapshot> listNews = [];
  List<DocumentSnapshot> listJob = [];
  List<DocumentSnapshot> listPromotion = [];
  UserModel _user = UserModel();
  UserModel currentUser;
  List<Group> groupList = [];
  List<UserModel> companyList = [];
  String query = '';
  ScrollController _scrollController;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3 = ScrollController();
  List<String> followingUIDs = [];
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
    });
    _nestedTabController =
        new TabController(length: 2, vsync: this, initialIndex: 0);
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
    return ListView(
      controller: _scrollController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabBar(
          unselectedLabelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            // fontWeight: FontWeight.bold,
          ),
          controller: _nestedTabController,
          indicatorColor: Colors.purpleAccent,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textBody1(context),
            fontWeight: FontWeight.bold,
          ),
          isScrollable: true,
          tabs: <Widget>[
            Tab(text: 'My Teams'),
            Tab(
              text: 'All Teams',
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.72,
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              _user != null ? teamWidget() : Container(),
              teamWidget()
            ],
          ),
        )
      ],
    );
  }

  Widget teamWidget() {
    var screenSize = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: screenSize.height * 0.04,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/progressImage.png'),
            ),
            SizedBox(
              height: screenSize.height * 0.03,
            ),
            Text(
              '*Note : This feature is under progress.',
              style: TextStyle(
                  fontSize: screenSize.height * 0.023,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget groupWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .collection('groups')
            // .orderBy('time', descending: true)
            .snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                controller: _scrollController1,
                itemCount: snapshot.data.documents.length,
                itemBuilder: ((context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupPage(
                                        currentUser: _user,
                                        isMember: false,
                                        gid: snapshot
                                            .data.documents[index].data['uid'],
                                        name: snapshot.data.documents[index]
                                            .data['groupName'],
                                      )));
                        },
                        child: ListTile(
                          title: Text(
                            snapshot.data.documents[index].data['groupName'],
                            style:
                                TextStyle(fontSize: screenSize.height * 0.023),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: snapshot.data.documents[index]
                                        .data['groupProfilePhoto'] ==
                                    ''
                                ? AssetImage('assets/images/group_no-image.png')
                                : CachedNetworkImageProvider(snapshot
                                    .data
                                    .documents[index]
                                    .data['groupProfilePhoto']),
                          ),
                          trailing: snapshot.data.documents[index]
                                      .data['isPrivate'] ==
                                  false
                              ? Icon(Icons.public)
                              : Icon(Icons.lock_outline),
                        ),
                      ),
                      Divider()
                    ],
                  );
                }));
          }
        }));
  }

  Widget shimmerPromotion() {
    return Container(
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
    return ListView.builder(
      controller: _scrollController3,
      itemCount: groupList.length,
      itemBuilder: ((context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
          child: Column(
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
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: groupList[index].groupProfilePhoto.isEmpty
                        ? AssetImage('assets/images/group_no-image.png')
                        : CachedNetworkImageProvider(
                            groupList[index].groupProfilePhoto),
                  ),
                  title: Text(
                    // userList[index].toString(),
                    groupList[index].groupName,
                    style: TextStyle(fontSize: screenSize.height * 0.023),
                  ),
                  trailing: groupList[index].isPrivate == true
                      ? Icon(Icons.lock_outline)
                      : Icon(Icons.public),
                ),
              ),
              Divider(),
            ],
          ),
        );
      }),
    );
  }
}
