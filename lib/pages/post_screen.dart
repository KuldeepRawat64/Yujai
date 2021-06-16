import 'package:Yujai/models/user.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/list_post.dart';
import 'package:Yujai/widgets/no_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final postsRef = FirebaseFirestore.instance.collection('posts');

class PostScreen extends StatefulWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var _repository = Repository();
  String currentUserId, followingUserId;
  static UserModel _user;
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
    User currentUser = await _repository.getCurrentUser();
    UserModel user = await _repository.retreiveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    _future = _repository.retreiveUserPosts(_user.uid);
  }

  Widget postImagesWidget() {
    var screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data.length > 0) {
            return SizedBox(
                height: screenSize.height,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: ((context, index) =>
                        snapshot.data[index]['postId'] == widget.postId
                            ? ListItemPost(
                                documentSnapshot: snapshot.data[index],
                                index: index,
                                user: _user,
                                currentuser: _user,
                              )
                            : Container())));
          }
        }
        return Center(
          child: Text('Post not available'),
        );
      }),
    );
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
                  Navigator.of(context).pop();
                }),
            elevation: 0.5,
            backgroundColor: const Color(0xffffffff),
            title: Text(
              'Post',
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
