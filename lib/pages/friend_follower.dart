import 'package:Yujai/style.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Yujai/widgets/list_Followers.dart';

class FriendFollower extends StatefulWidget {
  final UserModel user;
  final UserModel followingUser;

  const FriendFollower({Key key, this.user, this.followingUser})
      : super(key: key);
  @override
  _FriendFollowerState createState() => _FriendFollowerState();
}

class _FriendFollowerState extends State<FriendFollower> {
  var _repository = Repository();
  UserModel _user = UserModel();
  List<UserModel> usersList = [];
  List<DocumentSnapshot> listFriendFollowers = [];
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
    setState(() {
      _user = widget.user;
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
                          user: widget.followingUser,
                          currentuser: widget.user,
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
          body: widget.user != null
              ? postImagesWidget()
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
