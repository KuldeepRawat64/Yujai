import 'package:Yujai/models/user.dart';
import 'dart:async';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/list_activity_request.dart';
import 'package:Yujai/widgets/no_content.dart';
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
  List<String> followingUIDs = [];
  List<User> usersList = [];
  DocumentReference reference;
  UserModel _user = UserModel();
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
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .collection('requests')
          .snapshots(),
      builder: ((context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData && snapshot.data.docs.length > 0) {
            return ListView.builder(
                // controller: _scrollController,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) => ListItemActivityRequest(
                      documentSnapshot: snapshot.data.docs[index],
                      index: index,
                      user: _user,
                      currentuser: _user,
                    )));
          } else {
            return NoContent('No requests or invites yet',
                'assets/images/notification.png', '', '');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      }),
    );
  }
}
