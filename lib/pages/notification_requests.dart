import 'package:Yujai/models/user.dart';
import 'dart:async';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/list_activity_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivityFeedRequests extends StatefulWidget {
  @override
  _ActivityFeedRequestsState createState() => _ActivityFeedRequestsState();
}

class _ActivityFeedRequestsState extends State<ActivityFeedRequests> {
  var _repository = Repository();
  User currentUser, user, followingUser;
  List<String> followingUIDs = List<String>();
  List<User> usersList = List<User>();
  DocumentReference reference;
  User _user = User();
  StreamSubscription<DocumentSnapshot> subscription;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    _scrollController?.dispose();
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });

  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
       backgroundColor:const Color(0xfff6f6f6),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black54,
              size: screenSize.height * 0.045,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xffffffff),
          elevation: 0.5,
          title: Text(
            'Requests and Invites',
           style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textAppTitle(context),
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
          ),
        ),
        body: _user.uid != null
            ? Padding(
                padding: const EdgeInsets.all(0.0),
                child: postImagesWidget(),
              )
            : Container(),
      ),
    );
  }

  Widget postImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(_user.uid)
          .collection('requests')
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
              height: screenSize.height,
              child: ListView.builder(
                controller: _scrollController,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: ((context, index) => ListItemActivityRequest(
                        documentSnapshot: snapshot.data.documents[index],
                        index: index,
                        user: _user,
                        currentuser: _user,
                      ))));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
