import 'dart:async';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/list_job.dart';
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
  User _user;
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
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
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
            ? ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: postImagesWidget(),
                ),
              ])
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget postImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
                height: screenSize.height,
                child: ListView.builder(
                    controller: _scrollController,
                    //shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: ((context, index) => ListItemJob(
                        currentuser: _user,
                        documentSnapshot: snapshot.data[index],
                        index: index,
                        user: _user))));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
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
