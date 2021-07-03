import 'dart:async';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/list_job.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../style.dart';

class JobUpdates extends StatefulWidget {
  // JobUpdates();

  @override
  _JobUpdatesState createState() => _JobUpdatesState();
}

class _JobUpdatesState extends State<JobUpdates> {
  var _repository = Repository();
  UserModel _user;
  IconData icon;
  Color color;
  Future<List<DocumentSnapshot>> _future;
  final TextStyle style =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    icon = MdiIcons.heart;
  }

  retrieveUserDetails() async {
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    _future = _repository.retreiveUserJobs(_user.uid);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
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
          //  centerTitle: true,
          backgroundColor: const Color(0xffffffff),
          title: Text(
            'Jobs',
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
                padding: const EdgeInsets.only(top: 4.0),
                child: postImagesWidget(),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget postImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .collection('jobs')
          .snapshots(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        // if (snapshot.hasData) {
        //   //     if (snapshot.connectionState == ConnectionState.done) {
        //   return SizedBox(
        //       height: screenSize.height,
        //       child: ListView.builder(
        //           controller: _scrollController,
        //           //shrinkWrap: true,
        //           itemCount: snapshot.data.docs.length,
        //           itemBuilder: ((context, index) => ListItemPost(
        //                 documentSnapshot: snapshot.data.docs[index],
        //                 index: index,
        //                 user: _user,
        //                 currentuser: _user,
        //               ))));
        //   //   } else {
        //   //     return Center(
        //   //       child: shimmer(),
        //   //      );
        //   //      }
        // } else {
        //   return Center(
        //     child: shimmer(),
        //   );
        // }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData && snapshot.data.docs.length > 0) {
            return ListView.builder(
                //   controller: _scrollController,
                //shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) => ListItemJob(
                      documentSnapshot: snapshot.data.docs[index],
                      index: index,
                      user: _user,
                      currentuser: _user,
                    )));
          } else {
            return NoContent('No jobs', 'assets/images/suitcase.png',
                'You have not posted any jobs yet', '');
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
