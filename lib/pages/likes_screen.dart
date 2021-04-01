import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/profile.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class LikesScreen extends StatefulWidget {
  final DocumentReference documentReference;
  final User user;
  LikesScreen({this.documentReference, this.user});

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  var _repository = Repository();
  ScrollController _scrollController = ScrollController();

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
            'Likes',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: FutureBuilder(
          future: _repository.fetchPostLikes(widget.documentReference),
          builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width / 30,
                      top: screenSize.height * 0.012,
                      right: screenSize.width / 30,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[200],
                              offset: Offset(1.0, 1.0),
                              spreadRadius: 1.0,
                              blurRadius: 1.0,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset.zero,
                              spreadRadius: 0,
                              blurRadius: 0,
                            )
                          ]),
                      child: ListTile(
                        title: GestureDetector(
                          onTap: () {
                            snapshot.data[index].data['ownerName'] ==
                                    widget.user.displayName
                                ? Container()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            InstaFriendProfileScreen(
                                              uid: snapshot
                                                  .data[index].data['ownerUid'],
                                              name: snapshot.data[index]
                                                  .data['ownerName'],
                                            ))));
                          },
                          child: Text(
                            snapshot.data[index].data['ownerName'],
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: FontNameDefault,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context)),
                          ),
                        ),
                        leading: GestureDetector(
                          onTap: () {
                            snapshot.data[index].data['ownerName'] ==
                                    widget.user.displayName
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            InstaProfileScreen())))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            InstaFriendProfileScreen(
                                              name: snapshot.data[index]
                                                  .data['ownerName'],
                                            ))));
                          },
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                snapshot.data[index].data['ownerPhotoUrl']),
                            radius: screenSize.height * 0.02,
                          ),
                        ),
                        // trailing:
                        //     snapshot.data[index].data['ownerUid'] != widget.user.uid
                        //         ? buildProfileButton(snapshot.data[index].data['ownerName'])
                        //         : null,
                      ),
                    ),
                  );
                }),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'No Likes found',
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                    color: Colors.black54,
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
    );
  }
}
