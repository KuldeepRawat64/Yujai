import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Yujai/widgets/list_followers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Follower extends StatefulWidget {
  @override
  _FollowerState createState() => _FollowerState();
}

class _FollowerState extends State<Follower> {
  var _repository = Repository();
  User _user = User();
  List<User> usersList = List<User>();
  List<DocumentSnapshot> listFollowers = List<DocumentSnapshot>();
  Future<List<DocumentSnapshot>> _future;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    _future = _repository.retreiveUserFollowers(_user.uid);
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
                    itemCount: snapshot.data.length,
                    itemBuilder: ((context, index) => ListItemFollowers(
                          documentSnapshot: snapshot.data[index],
                          index: index,
                          user: _user,
                          currentuser: _user,
                        ))));
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
            //  centerTitle: true,
            backgroundColor: const Color(0xffffffff),
            title: Text(
              'Followers',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: textAppTitle(context)),
            ),
          ),
          body: _user != null
              ? postImagesWidget()
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
