import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/notification_requests.dart';
import 'dart:async';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/widgets/list_activity_feed.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  var _repository = Repository();
  User currentUser, user, followingUser;
  List<String> followingUIDs = List<String>();
  List<User> usersList = List<User>();
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
          elevation: 0.5,
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
          //    centerTitle: true,
          title: Text(
            'Activity Feeds',
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .collection('items')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
              height: screenSize.height,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: ShapeDecoration(
                          color: const Color(0xffffffff),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActivityFeedRequests()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              overflow: Overflow.visible,
                              alignment: Alignment.topRight,
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                        'assets/images/group_no-image.png')),
                                Positioned(
                                  right: -10.0,
                                  top: -10.0,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ActivityFeedRequests()));
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: screenSize.width / 30,
                            ),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Requests and Invites',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      // color: Colors.black54,
                                      fontSize: textBody1(context),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: screenSize.height * 0.045,
                                  color: Colors.black54,
                                )
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: ((context, index) => ListItemActivityFeed(
                            documentSnapshot: snapshot.data.docs[index],
                            index: index,
                          ))),
                ],
              ));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
