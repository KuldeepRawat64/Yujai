import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Yujai/pages/following.dart';
import 'package:Yujai/pages/follower.dart';
import 'package:Yujai/pages/activity.dart';

import '../style.dart';

class InformationDetail extends StatefulWidget {
  @override
  _InformationDetailState createState() => _InformationDetailState();
}

class _InformationDetailState extends State<InformationDetail> {
  bool isCompany = false;
  var _repository = Repository();
  User _user;
  IconData icon;
  Color color;
  List<User> usersList = List<User>();
  User currentuser, user, followingUser;
  List<User> userList = List<User>();
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;
  List<String> followingUIDs = List<String>();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  List<DocumentSnapshot> listEvent = List<DocumentSnapshot>();
  List<DocumentSnapshot> listNews = List<DocumentSnapshot>();
  List<DocumentSnapshot> listJob = List<DocumentSnapshot>();
  List<DocumentSnapshot> listPromotion = List<DocumentSnapshot>();
  bool _enabled = true;
  ScrollController _scrollController;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3;
  ScrollController _scrollController4 = ScrollController();
  ScrollController _scrollController5 = ScrollController();
  Future<List<DocumentSnapshot>> _eventFuture;
  Future<List<DocumentSnapshot>> _newsFuture;
  Future<List<DocumentSnapshot>> _jobFuture;
  //Offset state <-------------------------------------
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();

    icon = MdiIcons.heart;
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
  }

  Widget detailsWidget(String count, String label) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => Activity()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              count,
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textSubTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget detailsFollowingWidget(String count, String label) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Following()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              count,
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textSubTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget detailsFollowerWidget(String count, String label) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Follower()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              count,
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textSubTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget seperatedWidgets() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Positioned(
            left: 21,
            top: 15,
            bottom: 15,
            child: VerticalDivider(
              width: 1,
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: 4,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0 - 8),
                      child: Container(
                        width: 8.0 * 2,
                        height: 8.0 * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 0, right: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Xyz',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  'time',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(color: Colors.grey),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 1,
                indent: 45,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xfff6f6f6),
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.black54,
                  size: screenSize.height * 0.045,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            //centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'Details',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView(
            children: [
              _user != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: screenSize.height * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200],
                                offset: Offset(1.0, 1.0),
                                spreadRadius: 1.0,
                                blurRadius: 2.0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset.zero,
                                spreadRadius: 0.0,
                                blurRadius: 0.0,
                              )
                            ]),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.05),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  StreamBuilder(
                                    stream: _repository
                                        .fetchStats(
                                            uid: _user.uid, label: 'posts')
                                        .asStream(),
                                    builder: ((context,
                                        AsyncSnapshot<List<DocumentSnapshot>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return detailsWidget(
                                            snapshot.data.length.toString(),
                                            'Posts');
                                      } else {
                                        return Center(
                                          child: Text(''),
                                        );
                                      }
                                    }),
                                  ),
                                  StreamBuilder(
                                    stream: _repository
                                        .fetchStats(
                                            uid: _user.uid, label: 'followers')
                                        .asStream(),
                                    builder: ((context,
                                        AsyncSnapshot<List<DocumentSnapshot>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 24.0),
                                          child: detailsFollowerWidget(
                                              snapshot.data.length.toString(),
                                              'Followers'),
                                        );
                                      } else {
                                        return Center(
                                          child: Text(''),
                                        );
                                      }
                                    }),
                                  ),
                                  StreamBuilder(
                                    stream: _repository
                                        .fetchStats(
                                            uid: _user.uid, label: 'following')
                                        .asStream(),
                                    builder: ((context,
                                        AsyncSnapshot<List<DocumentSnapshot>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: detailsFollowingWidget(
                                              snapshot.data.length.toString(),
                                              'Following'),
                                        );
                                      } else {
                                        return Center(
                                          child: Text(''),
                                        );
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(''),

              //jobImagesWidget(),
              //   seperatedWidgets(),
              SizedBox(height: screenSize.height * 0.1)
            ],
          )),
    );
  }
}
