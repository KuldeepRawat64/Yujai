import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/team.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/group_page.dart';
import 'package:Yujai/pages/post_screen.dart';
import 'package:Yujai/pages/team_page.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/models/feed.dart';

class ListItemActivityRequest extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final UserModel user, currentuser;
  final int index;

  ListItemActivityRequest({
    this.user,
    this.index,
    this.currentuser,
    this.documentSnapshot,
  });

  @override
  _ListItemActivityRequestState createState() =>
      _ListItemActivityRequestState();
}

class _ListItemActivityRequestState extends State<ListItemActivityRequest> {
  String currentUserId, followingUserId;
  var _repository = Repository();
  bool isCompany = false;
  static UserModel _user, currentuser;
  IconData icon;
  Color color;
  bool isFollowing = false;
  bool isPrivate = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  Widget mediaPreview;
  String activityItemText;
  bool isChecked = false;

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository
        .fetchUidBySearchedName(widget.documentSnapshot['ownerUid']);
    if (!mounted) return;
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
  }

  fetchUserDetailsById(String userId) async {
    UserModel user = await _repository
        .fetchUserDetailsById(widget.documentSnapshot['ownerUid']);
    if (!mounted) return;
    setState(() {
      _user = user;
      isPrivate = user.isPrivate;
      print("USER : ${_user.displayName}");
    });
  }

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      if (!mounted) return;
      setState(() {
        user = user;
      });
      _repository.fetchUserDetailsById(user.uid).then((currentUser) {
        if (!mounted) return;
        setState(() {
          currentuser = currentUser;
        });
      });
      if (!mounted) return;
      setState(() {
        currentUserId = widget.user.uid;
      });
    });
    fetchUidBySearchedName(widget.documentSnapshot['ownerUid']);
  }

  configureMediaPreview(context) {
    var screenSize = MediaQuery.of(context).size;
    if (widget.documentSnapshot['type'] == 'request') {
      mediaPreview = Wrap(
        children: [
          FlatButton(
            onPressed: () {
              followUser();
            },
            child: Text(
              'Confirm',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: 2.0,
          ),
          FlatButton(
            onPressed: () {
              removeRequestFromActivityFeed();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.black54),
            ),
            color: Colors.grey[200],
          )
        ],
      );
    } else if (widget.documentSnapshot['type'] == 'group invite') {
      mediaPreview = Wrap(
        children: [
          FlatButton(
            onPressed: () {
              joinGroup();
            },
            child: Text(
              'Join',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: 2.0,
          ),
          FlatButton(
            onPressed: removeRequestFromActivityFeed,
            child: Text(
              'Ignore',
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  color: Colors.black54),
            ),
            color: Colors.grey[200],
          )
        ],
      );
    } else if (widget.documentSnapshot['type'] == 'team invite') {
      mediaPreview = Wrap(
        children: [
          InkWell(
            onTap: () {
              showTeam(context);
              removeRequestFromActivityFeed();
            },
            child: Chip(
              avatar: CircleAvatar(
                radius: screenSize.height * 0.02,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/team_no-image.png'),
              ),
              label: Text(
                widget.documentSnapshot['gname'],
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    color: Colors.black54),
              ),
            ),
          )
        ],
      );
    } else {
      mediaPreview = Text('');
    }
    if (widget.documentSnapshot['type'] == 'request') {
      activityItemText = 'requested to follow you';
    } else if (widget.documentSnapshot['type'] == 'group invite') {
      activityItemText = 'invited you to join group';
    } else if (widget.documentSnapshot['type'] == 'team invite') {
      activityItemText = 'added you to team';
    } else {
      activityItemText =
          'Error:Unknown type ${widget.documentSnapshot['type']}';
    }
  }

  showPost(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostScreen(
            userId: widget.documentSnapshot['ownerUid'],
            postId: widget.documentSnapshot['postId'])));
  }

  showProfile(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FriendProfileScreen(
              name: widget.documentSnapshot['ownerName'],
              uid: widget.documentSnapshot['ownerUid'],
            )));
  }

  showGroup(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GroupPage(
              isMember: false,
              currentUser: currentuser,
              name: widget.documentSnapshot['gname'],
              gid: widget.documentSnapshot['gid'],
            )));
  }

  showTeam(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TeamPage(
              isMember: false,
              currentUser: currentuser,
              name: widget.documentSnapshot['gname'],
              gid: widget.documentSnapshot['gid'],
            )));
  }

  followUser() async {
    print('following user');
    await _repository.followUser(
        currentUserId: widget.documentSnapshot['ownerUid'],
        currentUserName: widget.documentSnapshot['ownerName'],
        currentUserPhotoUrl: widget.documentSnapshot['ownerPhotoUrl'],
        currentUserAccountType: '',
        followingUser: currentuser);
    await addFollowToActivityFeed();
    await removeRequestFromActivityFeed();
    setState(() {
      isChecked = true;
    });
  }

  joinTeam() async {
    var _member = Member(
      ownerName: currentuser.displayName,
      ownerUid: currentuser.uid,
      ownerPhotoUrl: currentuser.photoUrl,
      accountType: '',
      timestamp: FieldValue.serverTimestamp(),
    );
    FirebaseFirestore.instance
        .collection('teams')
        .doc(widget.documentSnapshot['gid'])
        .collection('members')
        .doc(currentuser.uid)
        .set(_member.toMap(_member));
    var _team = Team(
      uid: widget.documentSnapshot['gid'],
      teamName: widget.documentSnapshot['gname'],
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentuser.uid)
        .collection('teams')
        .doc(widget.documentSnapshot['gid'])
        .set(_team.toMap(_team));
    removeRequestFromActivityFeed();
    showTeam(context);
  }

  joinGroup() async {
    var _member = Member(
      ownerName: currentuser.displayName,
      ownerUid: currentuser.uid,
      ownerPhotoUrl: currentuser.photoUrl,
      accountType: '',
      timestamp: FieldValue.serverTimestamp(),
    );

    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.documentSnapshot['gid'])
        .collection('members')
        .doc(currentuser.uid)
        .set(_member.toMap(_member));

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.documentSnapshot['gid'])
        .update({
      'members': FieldValue.arrayUnion([currentuser.uid])
    });
    // var _team = Team(
    //   uid: widget.documentSnapshot.data['gid'],
    //   teamName: widget.documentSnapshot.data['gname'],
    // );
    // Firestore.instance
    //     .collection('users')
    //     .document(currentuser.uid)
    //     .collection('groups')
    //     .document(widget.documentSnapshot.data['gid'])
    //     .setData(_team.toMap(_team));
    removeRequestFromActivityFeed();
    showGroup(context);
  }

  addFollowToActivityFeed() {
    var _feed = Feed(
      ownerName: _user.displayName,
      ownerUid: _user.uid,
      type: 'follow',
      ownerPhotoUrl: _user.photoUrl,
      timestamp: FieldValue.serverTimestamp(),
      commentData: '',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentuser.uid)
        .collection('items')
        .doc(_user.uid)
        .set(_feed.toMap(_feed))
        .then((value) {
      print('Feed added');
    });
  }

  removeRequestFromActivityFeed() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentuser.uid)
        .collection('requests')
        .doc(widget.documentSnapshot['ownerUid'])
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
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
              //  side: BorderSide(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(12.0),
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
                      radius: screenSize.height * 0.04,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.documentSnapshot['ownerPhotoUrl']),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.01,
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
                                    text: widget.documentSnapshot['ownerName'],
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textSubTitle(context),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: ' $activityItemText ',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        widget.documentSnapshot['gid'] != null
                            ? Chip(
                                backgroundColor: Colors.white,
                                avatar: CircleAvatar(
                                  radius: screenSize.height * 0.02,
                                  backgroundColor: Colors.white,
                                  backgroundImage: CachedNetworkImageProvider(
                                      widget.documentSnapshot[
                                          'groupProfilePhoto']),
                                ),
                                label: Text(widget.documentSnapshot['gname'],
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        fontWeight: FontWeight.bold)))
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.documentSnapshot['timestamp'] != null
                        ? Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width / 30),
                            child: Text(
                              timeago.format(widget
                                  .documentSnapshot['timestamp']
                                  .toDate()),
                              style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.grey,
                                  fontSize: textbody2(context)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Container(),
                    mediaPreview,
                  ],
                ),
              )
            ],
          )),
    );
  }
}
