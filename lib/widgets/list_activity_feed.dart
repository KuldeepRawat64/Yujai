import 'package:Yujai/pages/article_screen.dart';
import 'package:Yujai/pages/event_screen.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/post_screen.dart';
import 'package:Yujai/pages/team_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../style.dart';

Widget mediaPreview;
String activityItemText;

class ListItemActivityFeed extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final int index;

  ListItemActivityFeed({this.index, this.documentSnapshot});

  configureMediaPreview(context) {
    if (documentSnapshot.data['type'] == 'like' ||
        documentSnapshot.data['type'] == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    documentSnapshot.data['imgUrl'],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (documentSnapshot.data['type'] == 'commentEvent') {
      mediaPreview = GestureDetector(
        onTap: () => showEvent(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    documentSnapshot.data['imgUrl'],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (documentSnapshot.data['type'] == 'commentArticle') {
      mediaPreview = GestureDetector(
        onTap: () => showArticle(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    documentSnapshot.data['imgUrl'],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (documentSnapshot.data['type'] == 'like') {
      activityItemText = 'liked your post';
    } else if (documentSnapshot.data['type'] == 'follow') {
      activityItemText = 'is following you';
    } else if (documentSnapshot.data['type'] == 'comment') {
      activityItemText = 'commented on your post';
    } else if (documentSnapshot.data['type'] == 'commentEvent') {
      activityItemText = 'commented on your event';
    } else if (documentSnapshot.data['type'] == 'commentArticle') {
      activityItemText = 'commented on your article';
    } else {
      activityItemText = 'Error:Unknown type ${documentSnapshot.data['type']}';
    }
  }

  showPost(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostScreen(
            userId: documentSnapshot.data['ownerUid'],
            postId: documentSnapshot.data['postId'])));
  }

  showEvent(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventScreen(
            userId: documentSnapshot.data['ownerUid'],
            postId: documentSnapshot.data['postId'])));
  }

  showArticle(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ArticleScreen(
            userId: documentSnapshot.data['ownerUid'],
            postId: documentSnapshot.data['postId'])));
  }

  showProfile(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InstaFriendProfileScreen(
              name: documentSnapshot.data['ownerName'],
              uid: documentSnapshot.data['ownerUid'],
            )));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Container(
          decoration: ShapeDecoration(
            color: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              //   side: BorderSide(color: Colors.grey[300]),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenSize.height * 0.012,
                    left: screenSize.width / 30),
                child: Wrap(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          documentSnapshot.data['ownerPhotoUrl']),
                    ),
                    SizedBox(
                      width: screenSize.height * 0.01,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => showProfile(context),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                style: TextStyle(
                                  fontSize: screenSize.height * 0.018,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: documentSnapshot.data['ownerName'],
                                    style: TextStyle(
                                        fontSize: textSubTitle(context),
                                        fontFamily: FontNameDefault,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: ' $activityItemText',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        documentSnapshot.data['timestamp'] != null
                            ? Text(
                                timeago.format(documentSnapshot
                                    .data['timestamp']
                                    .toDate()),
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.grey,
                                    fontSize: textbody2(context)),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: screenSize.width / 30,
                    bottom: screenSize.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    mediaPreview,
                  ],
                ),
              )
            ],
          )),
    );
  }
}
