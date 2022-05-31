import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/post_screen.dart';
import 'package:Yujai/pages/post_screen_dept.dart';
import 'package:Yujai/pages/post_screen_project.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../style.dart';

Widget mediaPreview;
String activityItemText;

class ListItemInboxTeam extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final int index;

  ListItemInboxTeam({this.index, this.documentSnapshot});
/* team: admin added new project in this dept, admin closed this project in this dept,
   project activities , new project creation , deletion
   dept: dept member project activities in dept , new task creations and completions
   project: task creations , deletions , task assignments, completions for member
*/
  configureMediaPreview(context) {
    var screenSize = MediaQuery.of(context).size;
    if (documentSnapshot.data()['type'] == 'like' ||
        documentSnapshot.data()['type'] == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => documentSnapshot.data()['projectId'] == ''
            ? showDeptPost(context)
            : showProjectPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: documentSnapshot.data()['imgUrl'] != null
                      ? NetworkImage(documentSnapshot.data()['imgUrl'])
                      : AssetImage('assets/images/placeholder.png'),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (documentSnapshot.data()['type'] == 'projectAdded' ||
        documentSnapshot.data()['type'] == 'projectDeleted') {
      mediaPreview = GestureDetector(
        //   onTap: () => showPost(context),
        child: Row(
          children: [
            Container(
              width: screenSize.width * 0.1,
              height: screenSize.height * 0.06,
              child: Padding(
                padding: EdgeInsets.all(screenSize.height * 0.01),
                child: Icon(
                  Icons.assignment_outlined,
                  //  IconData(widget.dIcon, fontFamily: 'MaterialIcons'),
                  color: Colors.white,
                ),
              ),
              decoration: ShapeDecoration(
                color: Color(documentSnapshot.data()['color']),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenSize.height * 0.01),
                ),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              documentSnapshot.data()['gName'],
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    } else if (documentSnapshot.data()['type'] == 'taskAdded' ||
        documentSnapshot.data()['type'] == 'taskCompleted') {
      mediaPreview = GestureDetector(
        //   onTap: () => showPost(context),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: documentSnapshot.data()['type'] == 'taskCompleted'
                  ? Colors.greenAccent
                  : Colors.black54,
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              documentSnapshot.data()['taskName'],
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textAppTitle(context),
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (documentSnapshot.data()['type'] == 'like') {
      activityItemText = 'liked your post';
    } else if (documentSnapshot.data()['type'] == 'follow') {
      activityItemText = 'is following you';
    } else if (documentSnapshot.data()['type'] == 'comment') {
      activityItemText = 'commented on your post';
    } else if (documentSnapshot.data()['type'] == 'projectAdded') {
      activityItemText = 'added this project';
    } else if (documentSnapshot.data()['type'] == 'projectDeleted') {
      activityItemText = 'deleted this project';
    } else if (documentSnapshot.data()['type'] == 'taskAdded') {
      activityItemText = 'added this task';
    } else if (documentSnapshot.data()['type'] == 'taskCompleted') {
      activityItemText = 'marked this task completed';
    } else {
      activityItemText =
          'Error:Unknown type ${documentSnapshot.data()['type']}';
    }
  }

  showPost(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostScreen(
            userId: documentSnapshot.data()['ownerUid'],
            postId: documentSnapshot.data()['postId'])));
  }

  showDeptPost(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostScreenDept(
            deptId: documentSnapshot.data()['deptId'],
            teamId: documentSnapshot.data()['gid'],
            userId: documentSnapshot.data()['ownerUid'],
            postId: documentSnapshot.data()['postId'])));
  }

  showProjectPost(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostScreenProject(
            projectId: documentSnapshot.data()['projectId'],
            deptId: documentSnapshot.data()['deptId'],
            teamId: documentSnapshot.data()['gid'],
            userId: documentSnapshot.data()['ownerUid'],
            postId: documentSnapshot.data()['postId'])));
  }

  showProfile(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FriendProfileScreen(
              name: documentSnapshot.data()['ownerName'],
              uid: documentSnapshot.data()['ownerUid'],
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
                          documentSnapshot.data()['ownerPhotoUrl']),
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
                                    text: documentSnapshot.data()['ownerName'],
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
                        documentSnapshot.data()['timestamp'] != null
                            ? Text(
                                timeago.format(documentSnapshot
                                    .data()['timestamp']
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
