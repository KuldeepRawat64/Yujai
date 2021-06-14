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

Widget mediaPreview;
String activityItemText;

class ListItemActivityRequest extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final User user, currentuser;
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
  static User _user, currentuser;
  IconData icon;
  Color color;
  bool isFollowing = false;
  bool isPrivate = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository
        .fetchUidBySearchedName(widget.documentSnapshot.data['ownerUid']);
    if (!mounted) return;
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
  }

  fetchUserDetailsById(String userId) async {
    User user = await _repository
        .fetchUserDetailsById(widget.documentSnapshot.data['ownerUid']);
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
    fetchUidBySearchedName(widget.documentSnapshot.data['ownerUid']);
  }

  configureMediaPreview(context) {
    var screenSize = MediaQuery.of(context).size;
    if (widget.documentSnapshot.data['type'] == 'request') {
      mediaPreview = Wrap(
        children: [
          FlatButton(
            onPressed: followUser,
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
            onPressed: removeRequestFromActivityFeed,
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
    } else if (widget.documentSnapshot.data['type'] == 'group invite') {
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
    } else if (widget.documentSnapshot.data['type'] == 'team invite') {
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
                widget.documentSnapshot.data['gname'],
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
    if (widget.documentSnapshot.data['type'] == 'request') {
      activityItemText = 'requested to follow you';
    } else if (widget.documentSnapshot.data['type'] == 'group invite') {
      activityItemText = 'invited you to join group';
    } else if (widget.documentSnapshot.data['type'] == 'team invite') {
      activityItemText = 'added you to team';
    } else {
      activityItemText =
          'Error:Unknown type ${widget.documentSnapshot.data['type']}';
    }
  }

  showPost(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostScreen(
            userId: widget.documentSnapshot.data['ownerUid'],
            postId: widget.documentSnapshot.data['postId'])));
  }

  showProfile(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FriendProfileScreen(
              name: widget.documentSnapshot.data['ownerName'],
              uid: widget.documentSnapshot.data['ownerUid'],
            )));
  }

  showGroup(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GroupPage(
              isMember: false,
              currentUser: currentuser,
              name: widget.documentSnapshot.data['gname'],
              gid: widget.documentSnapshot.data['gid'],
            )));
  }

  showTeam(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TeamPage(
              isMember: false,
              currentUser: currentuser,
              name: widget.documentSnapshot.data['gname'],
              gid: widget.documentSnapshot.data['gid'],
            )));
  }

  followUser() {
    print('following user');
    _repository.followUser(
        currentUserId: currentUserId,
        followingUserId: followingUserId,
        followingUser: _user,
        currentUser: currentuser);
    addFollowToActivityFeed();
    removeRequestFromActivityFeed();
  }

  joinTeam() async {
    var _member = Member(
      ownerName: currentuser.displayName,
      ownerUid: currentuser.uid,
      ownerPhotoUrl: currentuser.photoUrl,
      accountType: '',
      timestamp: FieldValue.serverTimestamp(),
    );
    Firestore.instance
        .collection('teams')
        .document(widget.documentSnapshot.data['gid'])
        .collection('members')
        .document(currentuser.uid)
        .setData(_member.toMap(_member));
    var _team = Team(
      uid: widget.documentSnapshot.data['gid'],
      teamName: widget.documentSnapshot.data['gname'],
    );
    Firestore.instance
        .collection('users')
        .document(currentuser.uid)
        .collection('teams')
        .document(widget.documentSnapshot.data['gid'])
        .setData(_team.toMap(_team));
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

    Firestore.instance
        .collection('groups')
        .document(widget.documentSnapshot.data['gid'])
        .collection('members')
        .document(currentuser.uid)
        .setData(_member.toMap(_member));

    await Firestore.instance
        .collection('groups')
        .document(widget.documentSnapshot.data['gid'])
        .updateData({
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

  void addFollowToActivityFeed() {
    var _feed = Feed(
      ownerName: _user.displayName,
      ownerUid: _user.uid,
      type: 'follow',
      ownerPhotoUrl: _user.photoUrl,
      timestamp: FieldValue.serverTimestamp(),
      commentData: '',
    );
    Firestore.instance
        .collection('users')
        .document(currentuser.uid)
        .collection('items')
        .document(_user.uid)
        .setData(_feed.toMap(_feed))
        .then((value) {
      print('Feed added');
    });
  }

  void removeRequestFromActivityFeed() {
    Firestore.instance
        .collection('users')
        .document(currentuser.uid)
        .collection('requests')
        .document(_user.uid)
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
                          widget.documentSnapshot.data['ownerPhotoUrl']),
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
                                    text: widget
                                        .documentSnapshot.data['ownerName'],
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
                        Chip(
                            backgroundColor: Colors.white,
                            avatar: CircleAvatar(
                              radius: screenSize.height * 0.02,
                              backgroundColor: Colors.white,
                              backgroundImage: CachedNetworkImageProvider(widget
                                  .documentSnapshot.data['groupProfilePhoto']),
                            ),
                            label: Text(widget.documentSnapshot.data['gname'],
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textBody1(context),
                                    fontWeight: FontWeight.bold))),
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
                    widget.documentSnapshot.data['timestamp'] != null
                        ? Padding(
                            padding:
                                EdgeInsets.only(left: screenSize.width / 30),
                            child: Text(
                              timeago.format(widget
                                  .documentSnapshot.data['timestamp']
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
