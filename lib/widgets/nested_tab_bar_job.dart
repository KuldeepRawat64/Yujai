import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/no_job.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../style.dart';
import 'list_job.dart';
import 'package:Yujai/pages/search_data.dart';

class NestedTabBarJob extends StatefulWidget {
  @override
  _NestedTabBarJobState createState() => _NestedTabBarJobState();
}

class _NestedTabBarJobState extends State<NestedTabBarJob>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  var _repository = Repository();
  User currentuser, user, followingUser;
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  List<DocumentSnapshot> listEvent = List<DocumentSnapshot>();
  List<DocumentSnapshot> listNews = List<DocumentSnapshot>();
  List<DocumentSnapshot> listJob = List<DocumentSnapshot>();
  List<DocumentSnapshot> listPromotion = List<DocumentSnapshot>();
  Future<List<DocumentSnapshot>> _listFuture;
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();
  List<User> companyList = List<User>();
  ScrollController _scrollController;
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();
  List<String> followingUIDs = List<String>();
  bool _enabled = true;
  //Offset state <-------------------------------------
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    fetchFeed();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoUrl;
      print("USER : ${user.displayName}");
      _repository.fetchUserDetailsById(user.uid).then((user) {
        if (!mounted) return;
        setState(() {
          currentUser = user;
        });
      });
      _repository.retrieveJobs(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          listJob = updatedList;
        });
      });
      _repository.fetchAllCompanies(user).then((list) {
        if (!mounted) return;
        setState(() {
          companyList = list;
        });
      });
    });
    _nestedTabController =
        new TabController(length: 1, vsync: this, initialIndex: 0);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
  }

  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    if (!mounted) return;
    setState(() {
      this.currentuser = user;
    });

    followingUIDs = await _repository.fetchFollowingUids(currentUser);

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DSDASDASD : ${followingUIDs[i]}");
      // _future = _repository.retrievePostByUID(followingUIDs[i]);
      this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
      print("user : ${this.user.uid}");
      usersList.add(this.user);
      print("USERSLIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        if (!mounted) return;
        setState(() {
          followingUser = usersList[i];
          print("FOLLOWING USER : ${followingUser.uid}");
        });
      }
    }
    _listFuture = _repository.retrieveJobs(currentUser);
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      controller: _scrollController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabBar(
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
            Tab(
              text: 'Job Listings',
            ),
          ],
        ),
        Container(
          color: const Color(0xFFf6f6f6),
          height: screenSize.height * 0.75,
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              jobImagesWidget(),
              //    jobSearch(),
              //    companiesList(),
            ],
          ),
        )
      ],
    );
  }

  Widget companiesList() {
    var screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      controller: _scrollController1,
      itemCount: companyList.length,
      itemBuilder: ((context, index) => Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.grey[300])),
              ),
              child: ListTile(
                onTap: () {
                  //   showResults(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => FriendProfileScreen(
                              uid: companyList[index].uid,
                              name: companyList[index].displayName))));
                },
                leading: Container(
                  decoration: ShapeDecoration(
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.height * 0.01)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenSize.height * 0.012),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          companyList[index].photoUrl),
                    ),
                  ),
                ),
                title: Text(
                  companyList[index].displayName,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                  ),
                ),
                subtitle: Text(
                  companyList[index].location.isNotEmpty
                      ? companyList[index].location.length > 10
                          ? companyList[index].location.contains('Mumbai')
                              ? 'Mumbai'
                              : 'India'
                          : companyList[index].location
                      : '',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget jobSearch() {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Divider(),
        GestureDetector(
          onTap: () {
            showSearch(
                context: context,
                delegate: JobsSearch(
                    postList: listJob, user: _user, currentUser: _user));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: screenSize.height * 0.04,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                padding: EdgeInsets.only(left: screenSize.width / 30),
                child: Text(
                  'Search for work or jobs',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget shimmerJobs() {
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

  Widget jobImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _listFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: shimmerJobs());
          } else {
            if (snapshot.data.length > 0) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ListView.builder(
                      controller: _scrollController3,
                      //shrinkWrap: true,
                      itemCount: listJob.length,
                      itemBuilder: ((context, index) => ListItemJob(
                          documentSnapshot: listJob[index],
                          index: index,
                          user: _user,
                          currentuser: _user))));
            }
            return Container(
                width: screenSize.width,
                height: screenSize.height * 0.3,
                child: NoJob());
          }
        });
  }
}
