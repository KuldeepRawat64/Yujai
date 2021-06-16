import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/comments.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class ListItemUser extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;
  final int index;
  final String gid;
  final String name;
  final Group group;
  final Team team;
  ListItemUser(
      {this.user,
      this.index,
      this.currentuser,
      this.documentSnapshot,
      this.gid,
      this.name,
      this.group,
      this.team});

  @override
  _ListItemUserState createState() => _ListItemUserState();
}

class _ListItemUserState extends State<ListItemUser> {
  var _repository = Repository();
  bool _isInvited;

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} comments',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                  color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _isInvited = false;
    _repository
        .checkIsMember(widget.documentSnapshot['ownerUid'], widget.gid)
        .then((value) {
      print("value:$value");
      if (!mounted) return;
      setState(() {
        _isInvited = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            //  side: BorderSide(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: ListTile(
          subtitle: Text(
            widget.documentSnapshot['accountType'],
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textBody1(context),
            ),
          ),
          title: Text(
            widget.documentSnapshot['ownerName'],
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textSubTitle(context),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                widget.documentSnapshot['ownerPhotoUrl']),
          ),
          trailing: _isInvited
              ? IconButton(
                  icon: Icon(Icons.check_circle_outline,
                      color: Theme.of(context).accentColor,
                      size: screenSize.height * 0.045),
                  onPressed: null)
              : IconButton(
                  icon: Icon(Icons.add_circle,
                      color: Theme.of(context).accentColor,
                      size: screenSize.height * 0.045),
                  onPressed: () {
                    setState(() {
                      _isInvited = true;
                      widget.team != null
                          ? addMember(widget.documentSnapshot)
                          : inviteUser();
                    });
                  }),
        ),
      ),
    );
  }

  addMember(DocumentSnapshot snapshot) {
    _repository.addTeamMember(
        currentTeam: widget.team,
        followerId: snapshot['ownerUid'],
        followerName: snapshot['ownerName'],
        followerAccountType: '${widget.team.teamName} Member',
        followerPhotoUrl: snapshot['ownerPhotoUrl']);
    addInviteToActivityFeed();
  }

  inviteUser() {
    print('User Invited');
    _repository.inviteUser(
        currentGroupId: widget.gid,
        followingUserId: widget.documentSnapshot['ownerUid']);
    addInviteToActivityFeed();
  }

  void addInviteToActivityFeed() {
    if (widget.group != null) {
      var _feed = Feed(
        ownerName: widget.currentuser.displayName,
        ownerUid: widget.currentuser.uid,
        type: 'group invite',
        ownerPhotoUrl: widget.currentuser.photoUrl,
        gid: widget.group.uid,
        gname: widget.group.groupName,
        groupProfilePhoto: widget.group.groupProfilePhoto,
        timestamp: FieldValue.serverTimestamp(),
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.documentSnapshot['ownerUid'])
          .collection('requests')
          // .document(currentUser.uid)
          // .collection('likes')
          .doc(widget.currentuser.uid)
          .set(_feed.toMap(_feed))
          .then((value) {
        print('Group Invite sent');
      });
    } else {
      var _feed = Feed(
        ownerName: widget.currentuser.displayName,
        ownerUid: widget.currentuser.uid,
        type: 'team invite',
        ownerPhotoUrl: widget.currentuser.photoUrl,
        gid: widget.team.uid,
        gname: widget.team.teamName,
        groupProfilePhoto: widget.team.teamProfilePhoto,
        timestamp: FieldValue.serverTimestamp(),
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.documentSnapshot['ownerUid'])
          .collection('requests')
          // .document(currentUser.uid)
          // .collection('likes')
          .doc(widget.currentuser.uid)
          .set(_feed.toMap(_feed))
          .then((value) {
        print('Team Invite sent');
      });
    }
  }

  deleteInvite() {
    print('Invite deleted');
    _repository.deleteInvite(
        currentGroupId: widget.gid,
        followingUserId: widget.documentSnapshot['ownerUid']);
    removeInviteToActivityFeed();
  }

  void removeInviteToActivityFeed() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.documentSnapshot['ownerUid'])
        .collection('requests')
        // .document(currentUser.uid)
        // .collection('likes')
        .doc(widget.currentuser.uid)
        .delete()
        .then((value) {
      print('Group Invite sent');
    });
  }
}
