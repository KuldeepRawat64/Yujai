import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/friend_activity.dart';
import 'package:Yujai/pages/friend_following.dart';
import 'package:Yujai/pages/friend_follower.dart';

class FriendInformationDetail extends StatefulWidget {
  final UserModel user;
  FriendInformationDetail({this.user});
  @override
  _FriendInformationDetailState createState() =>
      _FriendInformationDetailState();
}

class _FriendInformationDetailState extends State<FriendInformationDetail> {
  bool isCompany = false;
  var _repository = Repository();
  UserModel _user;
  IconData icon;
  Color color;
  bool isUser = false;

  Widget detailsWidget(String count, String label) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => FriendActivity(
        //           user: widget.user,
        //         )));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[100],
                offset: Offset(1.0, 1.0),
                spreadRadius: 1.0,
                blurRadius: 1.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset.zero,
                spreadRadius: 0.0,
                blurRadius: 0.0,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                count,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textSubTitle(context),
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(label,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsFollowingWidget(String count, String label) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                FriendFollowing(followingUser: _user, user: widget.user)));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[100],
                offset: Offset(1.0, 1.0),
                spreadRadius: 1.0,
                blurRadius: 1.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset.zero,
                spreadRadius: 0.0,
                blurRadius: 0.0,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                count,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textSubTitle(context),
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(label,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsFollowerWidget(String count, String label) {
    var screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FriendFollower(
                  followingUser: _user,
                  user: widget.user,
                )));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[100],
                offset: Offset(1.0, 1.0),
                spreadRadius: 1.0,
                blurRadius: 1.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset.zero,
                spreadRadius: 0.0,
                blurRadius: 0.0,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                count,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontWeight: FontWeight.bold,
                  fontSize: textSubTitle(context),
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(label,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                        color: Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: new Color(0xfff6f6f6),
      appBar: AppBar(
        elevation: 0.5,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        //    centerTitle: true,
        backgroundColor: const Color(0xffffffff),
        title: Text(
          'Details',
          style: TextStyle(
              fontFamily: FontNameDefault,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: textAppTitle(context)),
        ),
      ),
      body: widget.user != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: screenSize.height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        offset: Offset(2.0, 2.0),
                        spreadRadius: 2.0,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: screenSize.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        StreamBuilder(
                          stream: _repository
                              .fetchStats(uid: widget.user.uid, label: 'posts')
                              .asStream(),
                          builder: ((context,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.hasData) {
                              return detailsWidget(
                                  snapshot.data.length.toString(), 'posts');
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
                                  uid: widget.user.uid, label: 'followers')
                              .asStream(),
                          builder: ((context,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: detailsFollowerWidget(
                                    snapshot.data.length.toString(),
                                    'followers'),
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
                                  uid: widget.user.uid, label: 'following')
                              .asStream(),
                          builder: ((context,
                              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: detailsFollowingWidget(
                                    snapshot.data.length.toString(),
                                    'following'),
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
                    SizedBox(
                      height: screenSize.height * 0.03,
                    ),
                  ],
                ),
              ))
          : Text(''),
    ));
  }
}
