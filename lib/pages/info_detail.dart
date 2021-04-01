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

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    _repository.getCurrentUser().then((user) {});
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
      child: Container(
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
      child: Container(
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
      child: Container(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
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
        body: _user != null
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
                        padding: EdgeInsets.only(top: screenSize.height * 0.05),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            StreamBuilder(
                              stream: _repository
                                  .fetchStats(uid: _user.uid, label: 'posts')
                                  .asStream(),
                              builder: ((context,
                                  AsyncSnapshot<List<DocumentSnapshot>>
                                      snapshot) {
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
                                      uid: _user.uid, label: 'followers')
                                  .asStream(),
                              builder: ((context,
                                  AsyncSnapshot<List<DocumentSnapshot>>
                                      snapshot) {
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
                                      uid: _user.uid, label: 'following')
                                  .asStream(),
                              builder: ((context,
                                  AsyncSnapshot<List<DocumentSnapshot>>
                                      snapshot) {
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
                      ),
                    ],
                  ),
                ),
              )
            : Text(''),
      ),
    );
  }
}
