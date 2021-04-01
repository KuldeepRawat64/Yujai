import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';
import '../style.dart';
import 'list_post.dart';
import 'list_event.dart';
import 'list_news.dart';
import 'list_promotion.dart';

class NestedTabBar extends StatefulWidget {
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  var _repository = Repository();
  User currentuser, user, followingUser;
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  Future<List<DocumentSnapshot>> _listFuture;
  Future<List<DocumentSnapshot>> _eventFuture;
  Future<List<DocumentSnapshot>> _newsFuture;
  Future<List<DocumentSnapshot>> _promotionFuture;
  List<DocumentSnapshot> listEvent = List<DocumentSnapshot>();
  List<DocumentSnapshot> listNews = List<DocumentSnapshot>();
  List<DocumentSnapshot> listJob = List<DocumentSnapshot>();
  List<DocumentSnapshot> listPromotion = List<DocumentSnapshot>();
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();
  List<User> companyList = List<User>();
  String query = '';
  ScrollController _scrollController;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3;
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

      _repository.fetchUserDetailsById(user.uid).then((user) {
        if (!mounted) return;
        setState(() {
          currentUser = user;
        });
      });
      print("USER : ${user.displayName}");
      _repository.retrievePosts(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          list = updatedList;
        });
      });
      _repository.retrieveEvents(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          listEvent = updatedList;
        });
      });

      _repository.retrieveNews(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          listNews = updatedList;
        });
      });
      _repository.retrievePromotion(user).then((updatedList) {
        if (!mounted) return;
        setState(() {
          listPromotion = updatedList;
        });
      });
    });
    _nestedTabController =
        new TabController(length: 4, vsync: this, initialIndex: 0);
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
    _scrollController3 = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController3.offset;
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
    _listFuture = _repository.retrievePosts(currentUser);
    _eventFuture = _repository.retrieveEvents(currentUser);
    _newsFuture = _repository.retrieveNews(currentUser);
    _promotionFuture = _repository.retrievePromotion(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabBar(
          unselectedLabelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
           // fontWeight: FontWeight.bold,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          controller: _nestedTabController,
          indicatorColor: Colors.purpleAccent,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
          //  fontWeight: FontWeight.bold,
          ),
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: 'Events',
            ),
            Tab(
              text: 'Posts',
            ),
            Tab(
              text: 'Articles',
            ),
            Tab(
              text: 'Applications',
            ),
          ],
        ),
        Container(
          color: const Color(0xFFf6f6f6),
          height: screenHeight * 0.75,
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              eventImagesWidget(),
              postImagesWidgetFuture(),
              newsImageWidget(),
              promotionImagesWidget(),
            ],
          ),
        )
      ],
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

  Widget shimmerEvent() {
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

  Widget shimmerNews() {
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
                        height: 150,
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

  Widget postImagesWidgetFuture() {
    return FutureBuilder(
        future: _listFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: shimmer());
          } else {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    //shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: ((context, index) => ListItemPost(
                        documentSnapshot: list[index],
                        index: index,
                        user: _user,
                        currentuser: _user))));
          }
        });
  }

  Widget eventImagesWidget() {
    return FutureBuilder(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: shimmerEvent());
          } else {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController1,
                    itemCount: listEvent.length,
                    itemBuilder: ((context, index) => ListItemEvent(
                        documentSnapshot: listEvent[index],
                        index: index,
                        user: _user,
                        currentuser: _user))));
          }
        });
  }

  Widget promotionImagesWidget() {
    return FutureBuilder(
        future: _promotionFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: shimmerEvent());
          } else {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController2,
                    itemCount: listPromotion.length,
                    itemBuilder: ((context, index) => ListItemPromotion(
                        documentSnapshot: listPromotion[index],
                        index: index,
                        user: _user,
                        currentuser: _user))));
          }
        });
  }

  Widget newsImageWidget() {
    return FutureBuilder(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: shimmerNews());
          } else {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController3,
                    itemCount: listNews.length,
                    itemBuilder: ((context, index) => ListItemNews(
                        documentSnapshot: listNews[index],
                        index: index,
                        user: _user,
                        currentuser: _user))));
          }
        });
  }
}
