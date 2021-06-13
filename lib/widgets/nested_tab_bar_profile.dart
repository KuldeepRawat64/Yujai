import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/flow_widget.dart';
import 'package:Yujai/widgets/no_event.dart';
import 'package:Yujai/widgets/no_news.dart';
import 'package:Yujai/widgets/no_post.dart';
import 'package:Yujai/widgets/skill_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../style.dart';
import 'list_post.dart';
import 'list_event.dart';
import 'list_news.dart';
import 'list_promotion.dart';

class NestedTabBarProfile extends StatefulWidget {
  final User profileUser;
  final User currentUser;

  const NestedTabBarProfile({Key key, this.profileUser, this.currentUser})
      : super(key: key);
  @override
  _NestedTabBarProfileState createState() => _NestedTabBarProfileState();
}

class _NestedTabBarProfileState extends State<NestedTabBarProfile>
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
    //  _promotionFuture = _repository.retrievePromotion(currentUser);
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
            fontWeight: FontWeight.bold,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 25.0),
          controller: _nestedTabController,
          indicatorColor: Colors.purpleAccent,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            fontWeight: FontWeight.bold,
          ),
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: 'Overview',
            ),
            Tab(
              text: 'Skills',
            ),
            Tab(
              text: 'Experience',
            ),

            // Tab(
            //   text: 'Applications',
            // ),
          ],
        ),
        Container(
          color: const Color(0xFFf6f6f6),
          height: screenHeight * 0.75,
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              overviewProfile(),
              skillProfile(),
              expProfile(),
              //  promotionImagesWidget(),
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

  // Widget postImagesWidgetFuture() {
  //   var screenSize = MediaQuery.of(context).size;
  //   return FutureBuilder(
  //       future: _listFuture,
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(child: shimmer());
  //         } else {
  //           if (snapshot.data.length > 0) {
  //             return SizedBox(
  //                 height: MediaQuery.of(context).size.height,
  //                 child: Column(
  //                   children: [
  //                     SizedBox(
  //                       height: MediaQuery.of(context).size.height * 0.025,
  //                     ),
  //                     Flexible(
  //                       child: ListView.builder(
  //                           physics: AlwaysScrollableScrollPhysics(),
  //                           controller: _scrollController,
  //                           //shrinkWrap: true,
  //                           itemCount: list.length,
  //                           itemBuilder: ((context, index) => ListItemPost(
  //                               documentSnapshot: list[index],
  //                               index: index,
  //                               user: _user,
  //                               currentuser: _user))),
  //                     ),
  //                   ],
  //                 ));
  //           }
  //           return SizedBox(
  //               width: screenSize.width,
  //               height: screenSize.height * 0.3,
  //               child: NoPost());
  //         }
  //       });
  // }

  // Widget eventImagesWidget() {
  //   var screenSize = MediaQuery.of(context).size;
  //   return FutureBuilder(
  //       future: _eventFuture,
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(child: shimmerEvent());
  //         } else {
  //           if (snapshot.data.length > 0) {
  //             return SizedBox(
  //               height: MediaQuery.of(context).size.height,
  //               child: Column(
  //                 children: [
  //                   SizedBox(
  //                     height: MediaQuery.of(context).size.height * 0.025,
  //                   ),
  //                   Flexible(
  //                     child: ListView.builder(
  //                         physics: AlwaysScrollableScrollPhysics(),
  //                         controller: _scrollController1,
  //                         itemCount: listEvent.length,
  //                         itemBuilder: ((context, index) => ListItemEvent(
  //                             documentSnapshot: listEvent[index],
  //                             index: index,
  //                             user: _user,
  //                             currentuser: _user))),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           } else {
  //             return SizedBox(
  //                 width: screenSize.width,
  //                 height: screenSize.height * 0.3,
  //                 child: NoEvent());
  //           }
  //         }
  //       });
  // }

  // Widget promotionImagesWidget() {
  //   return FutureBuilder(
  //       future: _promotionFuture,
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(child: shimmerEvent());
  //         } else {
  //           return SizedBox(
  //               height: MediaQuery.of(context).size.height,
  //               child: ListView.builder(
  //                   physics: AlwaysScrollableScrollPhysics(),
  //                   controller: _scrollController2,
  //                   itemCount: listPromotion.length,
  //                   itemBuilder: ((context, index) => ListItemPromotion(
  //                       documentSnapshot: listPromotion[index],
  //                       index: index,
  //                       user: _user,
  //                       currentuser: _user))));
  //         }
  //       });
  // }

  Widget overviewProfile() {
    return ListView(
      controller: _scrollController1,
      //  physics: NeverScrollableScrollPhysics(),
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xffffffff),
          ),
          child: Column(
            //    shrinkWrap: true,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bio',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textHeader(context),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(widget.profileUser.bio,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    //        fontSize: textHeader(context),
                    //      fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Color(0xffffffff),
            ),
            child: userBody(widget.profileUser)),
      ],
    );
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      children: strings
          .map((items) => Padding(
                padding: EdgeInsets.all(screenSize.height * 0.01),
                child: chip(items, Colors.deepPurple[100]),
              ))
          .toList(),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      labelPadding: EdgeInsets.all(screenSize.height * 0.005),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: FontNameDefault,
          // fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: textbody2(context),
        ),
      ),
      backgroundColor: color,
      elevation: 0.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(screenSize.height * 0.01),
    );
  }

  Widget userBody(User _user) {
    var screenSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _user.bio.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Info',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: textSubTitle(context),
                        ),
                      ),
                      Divider(),
                      _user.rank.isNotEmpty && _user.rank != 'Select a Rank'
                          ? Wrap(
                              children: [
                                Text(
                                  'Rank  :  ',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSubTitle(context),
                                  ),
                                ),
                                Text(
                                  _user.rank,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      _user.medal != null &&
                              _user.medal.isNotEmpty &&
                              _user.medal != 'Select a Medal'
                          ? Wrap(
                              children: [
                                Text(
                                  'Medal  :  ',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSubTitle(context),
                                  ),
                                ),
                                Text(
                                  _user.medal,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      _user.regiment.isNotEmpty &&
                              _user.regiment != 'Select a Regiment'
                          ? Wrap(
                              children: [
                                Text(
                                  'Regiment  :  ',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSubTitle(context),
                                  ),
                                ),
                                Text(
                                  _user.regiment,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      _user.command.isNotEmpty &&
                              _user.command != 'Select a Command'
                          ? Wrap(
                              children: [
                                Text(
                                  'Command  :  ',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSubTitle(context),
                                  ),
                                ),
                                Text(
                                  _user.command,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      _user.department.isNotEmpty &&
                              _user.department != 'Select a Department'
                          ? Wrap(
                              children: [
                                Text(
                                  'Department  :  ',
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSubTitle(context),
                                  ),
                                ),
                                Text(
                                  _user.department,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: screenSize.height * 0.01,
                      ),
                      //  Divider(),
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: screenSize.width / 30),
                //   child: Text(
                //     'About',
                //     style: TextStyle(
                //       fontFamily: FontNameDefault,
                //       color: Colors.black,
                //       fontWeight: FontWeight.bold,
                //       fontSize: textSubTitle(context),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: screenSize.width / 30,
                //       right: screenSize.width / 30,
                //       top: screenSize.height * 0.005),
                //   child: Text(
                //     _user.bio,
                //     style: TextStyle(
                //         fontFamily: FontNameDefault,
                //         fontSize: textBody1(context),
                //         color: Colors.black54),
                //   ),
                // ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      // _user.university.isNotEmpty ||
      //         _user.college.isNotEmpty ||
      //         _user.school.isNotEmpty
      //     // ||
      //     // _user.certification1.isNotEmpty
      //     ? Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.only(left: screenSize.width / 30),
      //             child: Text(
      //               'Education & Qualification',
      //               style: TextStyle(
      //                 fontFamily: FontNameDefault,
      //                 color: Colors.black,
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: textSubTitle(context),
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding:
      //                 EdgeInsets.symmetric(horizontal: screenSize.width / 30),
      //             child: Divider(),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.only(left: screenSize.width / 30),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 _user.university == ''
      //                     ? Container()
      //                     : Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Padding(
      //                             padding: EdgeInsets.symmetric(
      //                                 vertical: screenSize.height * 0.012),
      //                             child: Text(
      //                               'University',
      //                               style: TextStyle(
      //                                 fontFamily: FontNameDefault,
      //                                 color: Colors.black,
      //                                 fontWeight: FontWeight.bold,
      //                                 fontSize: textSubTitle(context),
      //                               ),
      //                             ),
      //                           ),
      //                           Row(
      //                             children: [
      //                               Text(
      //                                 _user.university,
      //                                 style: TextStyle(
      //                                   fontFamily: FontNameDefault,
      //                                   fontSize: textBody1(context),
      //                                   color: Colors.black54,
      //                                 ),
      //                               ),
      //                               Text(
      //                                 ', '
      //                                 //    + _user.endUniversity
      //                                 ,
      //                                 style: TextStyle(
      //                                   fontFamily: FontNameDefault,
      //                                   fontSize: textBody1(context),
      //                                   color: Colors.black54,
      //                                 ),
      //                               )
      //                             ],
      //                           ),
      //                           Text(
      //                             _user.stream,
      //                             style: TextStyle(
      //                               fontSize: screenSize.height * 0.018,
      //                               color: Colors.black54,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                 _user.college == ''
      //                     ? Container()
      //                     : Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Padding(
      //                             padding: EdgeInsets.symmetric(
      //                                 vertical: screenSize.height * 0.012),
      //                             child: Text(
      //                               'College',
      //                               style: TextStyle(
      //                                 fontFamily: FontNameDefault,
      //                                 color: Colors.black,
      //                                 fontWeight: FontWeight.bold,
      //                                 fontSize: textSubTitle(context),
      //                               ),
      //                             ),
      //                           ),
      //                           Row(
      //                             children: [
      //                               Text(
      //                                 _user.college,
      //                                 style: TextStyle(
      //                                   fontFamily: FontNameDefault,
      //                                   fontSize: textBody1(context),
      //                                   color: Colors.black54,
      //                                 ),
      //                               ),
      //                               Text(
      //                                 ', ' + _user.endCollege,
      //                                 style: TextStyle(
      //                                   fontFamily: FontNameDefault,
      //                                   fontSize: textBody1(context),
      //                                   color: Colors.black54,
      //                                 ),
      //                               ),
      //                             ],
      //                           )
      //                         ],
      //                       ),
      //                 _user.school == ''
      //                     ? Container()
      //                     : Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Padding(
      //                             padding: EdgeInsets.symmetric(
      //                                 vertical: screenSize.height * 0.012),
      //                             child: Text(
      //                               'School',
      //                               style: TextStyle(
      //                                 fontFamily: FontNameDefault,
      //                                 color: Colors.black,
      //                                 fontWeight: FontWeight.bold,
      //                                 fontSize: textSubTitle(context),
      //                               ),
      //                             ),
      //                           ),
      //                           Row(
      //                             children: [
      //                               Text(
      //                                 _user.school,
      //                                 style: TextStyle(
      //                                   fontFamily: FontNameDefault,
      //                                   fontSize: textBody1(context),
      //                                   color: Colors.black54,
      //                                 ),
      //                               ),
      //                               Text(
      //                                 ', ' + _user.endSchool,
      //                                 style: TextStyle(
      //                                   fontFamily: FontNameDefault,
      //                                   fontSize: textBody1(context),
      //                                   color: Colors.black54,
      //                                 ),
      //                               ),
      //                             ],
      //                           )
      //                         ],
      //                       ),
      //                 _user.certification1.isEmpty ||
      //                         _user.certification2.isEmpty ||
      //                         _user.certification3.isEmpty
      //                     ? Container()
      //                     : Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Padding(
      //                             padding: EdgeInsets.symmetric(
      //                                 vertical: screenSize.height * 0.012),
      //                             child: Text(
      //                               'Certifications',
      //                               style: TextStyle(
      //                                 fontFamily: FontNameDefault,
      //                                 color: Colors.black,
      //                                 fontWeight: FontWeight.bold,
      //                                 fontSize: textSubTitle(context),
      //                               ),
      //                             ),
      //                           ),
      //                           _user.certification1.isNotEmpty
      //                               ? Text(
      //                                   _user.certification1,
      //                                   style: TextStyle(
      //                                     fontFamily: FontNameDefault,
      //                                     fontSize: textBody1(context),
      //                                     color: Colors.black54,
      //                                   ),
      //                                 )
      //                               : Container(),
      //                           _user.certification2.isNotEmpty
      //                               ? Text(
      //                                   _user.certification2,
      //                                   style: TextStyle(
      //                                     fontFamily: FontNameDefault,
      //                                     fontSize: textBody1(context),
      //                                     color: Colors.black54,
      //                                   ),
      //                                 )
      //                               : Container(),
      //                           _user.certification3.isNotEmpty
      //                               ? Text(
      //                                   _user.certification3,
      //                                   style: TextStyle(
      //                                     fontFamily: FontNameDefault,
      //                                     fontSize: textBody1(context),
      //                                     color: Colors.black54,
      //                                   ),
      //                                 )
      //                               : Container(),
      //                         ],
      //                       ),
      //               ],
      //             ),
      //           ),
      //           Padding(
      //             padding:
      //                 EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
      //             child: Container(
      //               height: screenSize.height * 0.02,
      //               color: Colors.grey[200],
      //             ),
      //           ),
      //         ],
      //       )
      //     : Container(),
      // _user.company1.isNotEmpty
      //     ? Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.only(left: screenSize.width / 30),
      //             child: Text(
      //               'Experience',
      //               style: TextStyle(
      //                 fontFamily: FontNameDefault,
      //                 color: Colors.black,
      //                 fontWeight: FontWeight.bold,
      //                 fontSize: textSubTitle(context),
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding:
      //                 EdgeInsets.symmetric(horizontal: screenSize.width / 30),
      //             child: Divider(),
      //           ),
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Padding(
      //                 padding: EdgeInsets.only(
      //                   left: screenSize.width / 30,
      //                   top: screenSize.height * 0.012,
      //                 ),
      //                 child: Text(
      //                   '',
      //                   // _user.company1 +
      //                   //     '   (' +
      //                   //     _user.startCompany1 +
      //                   //     ' ' +
      //                   //     '- ' +
      //                   //     _user.endCompany1 +
      //                   //     ')   ',
      //                   style: TextStyle(
      //                     fontFamily: FontNameDefault,
      //                     fontSize: textBody1(context),
      //                     color: Colors.black54,
      //                   ),
      //                 ),
      //               ),
      //               _user.company2.isNotEmpty
      //                   ? Padding(
      //                       padding: EdgeInsets.only(
      //                         left: screenSize.width / 30,
      //                         top: screenSize.height * 0.012,
      //                       ),
      //                       child: Text(
      //                         '',
      //                         // _user.company2 +
      //                         //     '   (' +
      //                         //     _user.startCompany2 +
      //                         //     ' ' +
      //                         //     '- ' +
      //                         //     _user.endCompany2 +
      //                         //     ')   ',
      //                         style: TextStyle(
      //                           fontFamily: FontNameDefault,
      //                           fontSize: textBody1(context),
      //                           color: Colors.black54,
      //                         ),
      //                       ),
      //                     )
      //                   : Container(),
      //               _user.company3.isNotEmpty
      //                   ? Padding(
      //                       padding: EdgeInsets.only(
      //                         left: screenSize.width / 30,
      //                         top: screenSize.height * 0.012,
      //                       ),
      //                       child: Text(
      //                         '',
      //                         // _user.company3 +
      //                         //     '   (' +
      //                         //     _user.startCompany3 +
      //                         //     ' ' +
      //                         //     '- ' +
      //                         //     _user.endCompany3 +
      //                         //     ')   ',
      //                         style: TextStyle(
      //                           fontFamily: FontNameDefault,
      //                           fontSize: textBody1(context),
      //                           color: Colors.black54,
      //                         ),
      //                       ),
      //                     )
      //                   : Container(),
      //             ],
      //           ),
      //           Padding(
      //             padding:
      //                 EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
      //             child: Container(
      //               height: screenSize.height * 0.02,
      //               color: Colors.grey[200],
      //             ),
      //           ),
      //         ],
      //       )
      //     : Container(),
      _user.skills.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Skills',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Wrap(
                    children: [
                      // _user != null
                      //     ? getTextWidgets(_user.skills)
                      //     : Text(
                      //         '',
                      //         style: TextStyle(
                      //           fontFamily: FontNameDefault,
                      //           fontSize: textBody1(context),
                      //           color: Colors.black54,
                      //         ),
                      //       ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.interests.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Interest',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Wrap(
                    children: [
                      _user != null
                          ? getTextWidgets(_user.interests)
                          : Text(
                              '',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.purpose.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Purpose',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Wrap(
                    children: [
                      _user != null
                          ? getTextWidgets(_user.purpose)
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.phone.isNotEmpty ||
              _user.website.isNotEmpty ||
              _user.email.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Contact Details',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
                ),
                _user.phone.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              _user.gender == 'Female' || _user.isPrivate
                                  ? 'Private'
                                  : _user.phone,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                _user.website.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              'Portfolio',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              _user.website,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                _user.email.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              _user.email,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      InkWell(
        // onTap: () {
        //   if (isPrivate && !isFollowing) {
        //     return;
        //   } else {
        //     Navigator.of(context).push(MaterialPageRoute(
        //         builder: (context) => FriendActivity(
        //               followingUser: currentuser,
        //               user: _user,
        //             )));
        //   }
        // },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 30,
            vertical: screenSize.height * 0.012,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.black,
                  fontSize: textSubTitle(context),
                ),
              ),
              Row(
                children: [
                  // isPrivate && !isFollowing
                  //     ? Icon(
                  //         MdiIcons.lockOutline,
                  //         color: Colors.black54,
                  //         //  size: screenSize.height * 0.05,
                  //       )
                  //     :
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black54,
                    size: screenSize.height * 0.05,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      Divider(
        height: 0,
      ),
      InkWell(
        // onTap: () {
        //   if (isPrivate && !isFollowing) {
        //     return;
        //   } else {
        //     Navigator.of(context).push(MaterialPageRoute(
        //         builder: (context) => FriendInformationDetail(
        //               user: _user,
        //             )));
        //   }
        // },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 30,
            vertical: screenSize.height * 0.012,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Information',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.black,
                  fontSize: textSubTitle(context),
                ),
              ),
              Row(
                children: [
                  // isPrivate && !isFollowing
                  //     ? Icon(
                  //         Icons.lock_outline,
                  //         color: Colors.black54,
                  //         //    size: screenSize.height * 0.05,
                  //       )
                  //     :
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black54,
                    size: screenSize.height * 0.05,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      Divider(
        height: 0,
      ),
      InkWell(
        // onTap: () {
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => FriendActivityApplications(
        //             followingUser: currentuser,
        //             user: _user,
        //           )));
        // },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 30,
            vertical: screenSize.height * 0.012,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Work Applications',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.black,
                  fontSize: textSubTitle(context),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.02,
          color: Colors.grey[200],
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: screenSize.height * 0.05,
        ),
      ]),
    ]);
  }

  Widget skillProfile() {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skills',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textHeader(context),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              widget.profileUser.skills == []
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.25,
                          vertical: screenSize.height * 0.01),
                      child: Text(
                        'Nothing to see here',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return SkillEventRow(SkillEvent(
                            skill: widget.profileUser.skills[index]['skill'],
                            level: widget.profileUser.skills[index]['level']
                                .toDouble()));
                      },
                      // separatorBuilder:
                      //     (BuildContext context, int index) {
                      //   return SizedBox(
                      //     height: 2,
                      //   );
                      // },
                      itemCount: widget.profileUser.skills.length),
            ],
          ),
        ),
      ],
    );
  }

  Widget expProfile() {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Experience',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textHeader(context),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              _user.experience != []
                  ? Card(
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
                                    employmentType: widget.profileUser
                                        .experience[index]['employmentType'],
                                    isPresent: widget.profileUser
                                        .experience[index]['isPresent'],
                                    industry: widget.profileUser.experience[index]
                                        ['industry'],
                                    company: widget.profileUser.experience[index]
                                        ['company'],
                                    designation: widget.profileUser
                                        .experience[index]['designation'],
                                    startDate: widget.profileUser
                                        .experience[index]['startCompany'],
                                    endDate: widget.profileUser.experience[index]
                                        ['endCompany']));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 2,
                                );
                              },
                              itemCount: widget.profileUser.experience.length)
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.25,
                          vertical: screenSize.height * 0.01),
                      child: Text(
                        'Nothing to see',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget newsImageWidget() {
  //   var screenSize = MediaQuery.of(context).size;
  //   return FutureBuilder(
  //       future: _newsFuture,
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(child: shimmerNews());
  //         } else {
  //           if (snapshot.data.length > 0) {
  //             return SizedBox(
  //                 height: MediaQuery.of(context).size.height,
  //                 child: Column(
  //                   children: [
  //                     SizedBox(
  //                       height: MediaQuery.of(context).size.height * 0.025,
  //                     ),
  //                     Flexible(
  //                       child: ListView.builder(
  //                           physics: AlwaysScrollableScrollPhysics(),
  //                           controller: _scrollController3,
  //                           itemCount: listNews.length,
  //                           itemBuilder: ((context, index) => ListItemNews(
  //                               documentSnapshot: listNews[index],
  //                               index: index,
  //                               user: _user,
  //                               currentuser: _user))),
  //                     ),
  //                   ],
  //                 ));
  //           }
  //           return SizedBox(
  //               width: screenSize.width,
  //               height: screenSize.height * 0.3,
  //               child: NoNews());
  //         }
  //       });
  // }

}
