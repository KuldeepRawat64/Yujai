import 'dart:io';
import 'dart:math';
import 'package:Yujai/pages/group_settings.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as Im;
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/edit_photoUrl.dart';
import 'package:Yujai/pages/friend_profile.dart';
import 'package:Yujai/pages/group_invite.dart';
import 'package:Yujai/pages/group_post_review.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/widgets/list_post_forum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import '../style.dart';
import 'list_ad.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Yujai/widgets/list_event_forum.dart';
import 'package:Yujai/pages/group_requests.dart';
import 'package:Yujai/widgets/no_content.dart';

class NestedTabBarGroupHome extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final User currentUser;
  final Group group;
  const NestedTabBarGroupHome({
    this.gid,
    this.name,
    this.isMember,
    this.currentUser,
    this.group,
  });
  @override
  _NestedTabBarGroupHomeState createState() => _NestedTabBarGroupHomeState();
}

class _NestedTabBarGroupHomeState extends State<NestedTabBarGroupHome>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  var _repository = Repository();
  User currentuser, user, followingUser;
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  List<DocumentSnapshot> listEvent = List<DocumentSnapshot>();
  List<DocumentSnapshot> listNews = List<DocumentSnapshot>();
  List<DocumentSnapshot> listJob = List<DocumentSnapshot>();
  List<DocumentSnapshot> listPromotion = List<DocumentSnapshot>();
  User _user = User();
  Group _group = Group();
  User currentUser;
  List<User> usersList = List<User>();
  List<User> companyList = List<User>();
  String query = '';
  ScrollController _scrollController;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  ScrollController _scrollController3 = ScrollController();
  ScrollController _scrollController4 = ScrollController();
  ScrollController _scrollController5 = ScrollController();
  ScrollController _scrollController6 = ScrollController();
  List<String> followingUIDs = List<String>();
  bool _enabled = true;
  //Offset state <-------------------------------------
  double offset = 0.0;
  String currentUserId, followingUserId;
  StreamSubscription<DocumentSnapshot> subscription;
  bool isPrivate = false;

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository.fetchUidBySearchedName(name);
    if (!mounted) return;
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
  }

  fetchUserDetailsById(String userId) async {
    Group group = await _repository.fetchGroupDetailsById(widget.gid);
    if (!mounted) return;
    setState(() {
      _group = group;
      // isPrivate = user.isPrivate;
      print("USER : ${_user.displayName}");
    });
  }

  retrieveGroupDetails() async {
    //FirebaseUser currentUser = await _repository.getCurrentUser();
    Group group = await _repository.retreiveGroupDetails(widget.gid);
    if (!mounted) return;
    setState(() {
      _group = group;
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveGroupDetails();
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
    });
    fetchUidBySearchedName(widget.gid);
    _nestedTabController =
        new TabController(length: 5, vsync: this, initialIndex: 0);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
    _scrollController1 = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController1.offset;
          //force arefresh so the app bar can be updated
        });
      });
    _scrollController2 = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController2.offset;
          //force arefresh so the app bar can be updated
        });
      });
  }

  @override
  void dispose() {
    _nestedTabController?.dispose();
    _scrollController?.dispose();
    _scrollController1?.dispose();
    _scrollController2?.dispose();
    _scrollController3?.dispose();
    _scrollController4?.dispose();
    _scrollController5?.dispose();
    _scrollController6?.dispose();
    subscription?.cancel();
    super.dispose();
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: strings != null && strings.isNotEmpty
          ? strings
              .map((items) => Padding(
                    padding: EdgeInsets.all(screenSize.height * 0.01),
                    child: chip(items, Colors.white),
                  ))
              .toList()
          : Container(),
    );
  }

  Widget chip(String label, Color color) {
    var screenSize = MediaQuery.of(context).size;
    return Chip(
      labelPadding: EdgeInsets.all(screenSize.height * 0.005),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: FontNameDefault,
          color: Colors.black,
          fontSize: textbody2(context),
        ),
      ),
      backgroundColor: color,
      elevation: 0.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(screenSize.height * 0.01),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabBar(
          unselectedLabelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            fontWeight: FontWeight.bold,
          ),
          controller: _nestedTabController,
          indicatorColor: Colors.purpleAccent,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.black54,
          labelStyle: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
            fontWeight: FontWeight.bold,
          ),
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: 'Forum',
            ),
            Tab(
              text: 'Members',
            ),
            Tab(
              text: 'Events',
            ),
            Tab(
              text: 'Marketplace',
            ),
            Tab(
              text: 'Group info',
            ),
          ],
        ),
        Container(
          color: const Color(0xfff6f6f6),
          height: screenHeight * 0.8,
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              widget.isMember == true || _group.isPrivate == false
                  ? forumWidget()
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'This group is private',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.01,
                        ),
                        Icon(Icons.lock_outline),
                      ],
                    )),
              widget.isMember == true || _group.isPrivate == false
                  ? groupMemberWidget()
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'This group is private',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.01,
                        ),
                        Icon(Icons.lock_outline),
                      ],
                    )),
              widget.isMember == true || _group.isPrivate == false
                  ? eventWidget()
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'This group is private',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.01,
                        ),
                        Icon(Icons.lock_outline),
                      ],
                    )),
              widget.isMember == true || _group.isPrivate == false
                  ? _group != null
                      ? marketPlaceWidget()
                      : Container()
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'This group is private',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textBody1(context),
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.01,
                        ),
                        Icon(Icons.lock_outline),
                      ],
                    )),
              _group.isPrivate == false
                  ? groupInfoPublic()
                  : widget.isMember == true
                      ? widget.isMember == true
                          ? groupInfoPublic()
                          : groupInfoPrivate()
                      : groupInfoPrivate(),
              //postImagesWidgetFuture(),
            ],
          ),
        )
      ],
    );
  }

  Widget forumWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('groups')
          .document(widget.gid)
          .collection('posts')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: shimmerPromotion(),
          );
        } else {
          if (snapshot.data.documents.isEmpty) {
            return _group.members.contains(currentuser.uid)
                ? NoContent('No posts', 'assets/images/picture.png', true,
                    'Create a Post', '')
                : NoContent('No posts', 'assets/images/picture.png', false,
                    'When a post is created it will show up in this tab', '');
          }
          return SizedBox(
            height: screenSize.height * 0.9,
            child: ListView.builder(
              controller: _scrollController,
              //shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) => ListPostForum(
                  documentSnapshot: snapshot.data.documents[index],
                  index: index,
                  currentuser: widget.currentUser,
                  group: _group,
                  gid: widget.gid,
                  name: widget.name)),
            ),
          );
        }
      }),
    );
  }

  Widget eventWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('groups')
          .document(widget.gid)
          .collection('events')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: shimmerPromotion(),
          );
        } else {
          if (snapshot.data.documents.length > 0) {
            return SizedBox(
              height: screenSize.height * 0.9,
              child: ListView.builder(
                controller: _scrollController1,
                //shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: ((context, index) => ListItemEventForum(
                    group: _group,
                    documentSnapshot: snapshot.data.documents[index],
                    index: index,
                    currentuser: currentuser,
                    gid: widget.gid,
                    name: widget.name)),
              ),
            );
          }
          return currentuser.uid == _group.currentUserUid
              ? NoContent('No events', 'assets/images/calendar.png', true,
                  'Create an Event', '')
              : NoContent('No events', 'assets/images/calendar.png', false,
                  'When an event is created it will show up in this tab', '');
        }
      }),
    );
  }

  Widget marketPlaceWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('groups')
          .document(widget.gid)
          .collection('marketplace')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: shimmerPromotion(),
          );
        } else {
          if (snapshot.data.documents.isEmpty) {
            return _group.members.contains(currentuser.uid)
                ? NoContent('No products', 'assets/images/marketplace.png',
                    true, 'Post an ad', '')
                : NoContent(
                    'No products',
                    'assets/images/marketplace.png',
                    false,
                    'When the products are added for selling it will show up in this tab',
                    '');
          }
          return SizedBox(
            height: screenSize.height * 0.9,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: screenSize.height * 0.00075,
                  maxCrossAxisExtent: 300,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0),
              controller: _scrollController2,
              //shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: ((context, index) => ListAd(
                  documentSnapshot: snapshot.data.documents[index],
                  index: index,
                  currentuser: currentuser,
                  gid: widget.gid,
                  name: widget.name)),
            ),
          );
        }
      }),
    );
  }

  Widget shimmerPromotion() {
    return Container(
        color: const Color(0xffffffff),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            child: Shimmer.fromColors(
              child: ListView.builder(
                controller: _scrollController3,
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40.0)),
                              width: 60.0,
                              height: 60.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80.0,
                                    height: 12.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 120.0,
                                    height: 12.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0)),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0)),
                      Divider(thickness: 4.0, color: Colors.white)
                    ],
                  ),
                ),
                itemCount: 6,
              ),
              enabled: _enabled,
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
            ),
          ),
        ]));
  }

  Widget groupMemberWidget() {
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('groups')
          .document(widget.gid)
          .collection('members')
          .orderBy('accountType', descending: true)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: screenSize.height * 0.9,
            child: Column(
              children: [
                widget.currentUser.uid == _group.currentUserUid
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0)),
                                //   disabledColor: Theme.of(context).accentColor,
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GroupRequest(
                                              group: _group,
                                              currentuser: currentuser,
                                              gid: widget.gid,
                                              name: widget.name)));
                                },
                                child: Text(
                                  'Requests',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: textBody1(context),
                                      color: Colors.white),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0)),
                                disabledColor: Theme.of(context).accentColor,
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => GroupPostReview(
                                          group: _group,
                                          currentuser: currentuser,
                                          gid: widget.gid,
                                          name: widget.name)));
                                },
                                child: Text('Review',
                                    style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.white))),
                          )
                        ],
                      )
                    : widget.isMember
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0)),
                                    //       disabledColor: Theme.of(context).accentColor,
                                    color: Theme.of(context).accentColor,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GroupInvite(
                                                  group: _group,
                                                  currentuser: currentuser,
                                                  gid: widget.gid,
                                                  name: widget.name)));
                                    },
                                    child: Text(
                                      'Invite',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.white),
                                    )),
                              ),
                            ],
                          )
                        : Container(),
                ListView.builder(
                  controller: _scrollController4,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: ((context, index) => InkWell(
                      onTap: () {
                        if (currentuser.uid !=
                            snapshot.data.documents[index].data['ownerUid']) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InstaFriendProfileScreen(
                                          uid: snapshot.data.documents[index]
                                              .data['ownerUid'],
                                          name: snapshot.data.documents[index]
                                              .data['ownerName'])));
                        }
                      },
                      child: Padding(
                        child: Container(
                          decoration: ShapeDecoration(
                            color: const Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              // side: BorderSide(color: Colors.grey[300]),
                            ),
                          ),
                          child: ListTile(
                            trailing: Text(
                              snapshot
                                  .data.documents[index].data['accountType'],
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                              ),
                            ),
                            leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data.documents[index]
                                        .data['ownerPhotoUrl'])),
                            title: Text(
                                snapshot
                                    .data.documents[index].data['ownerName'],
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                )),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                      ))),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: shimmerPromotion(),
          );
        }
      }),
    );
  }

  Widget groupInfoPublic() {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      controller: _scrollController5,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              fit: StackFit.loose,
              alignment: Alignment.topLeft,
              children: [
                Container(
                  height: screenSize.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xff251F34),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenSize.width / 30,
                        top: screenSize.height * 0.07,
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: screenSize.height * 0.07,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(_group
                                          .groupProfilePhoto !=
                                      null
                                  ? _group.groupProfilePhoto
                                  : 'https://firebasestorage.googleapis.com/v0/b/socialnetwork-cbb55.appspot.com/o/group_no-image.png?alt=media&token=7c646dd5-5ec4-467d-9639-09f97c6dc5f0'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.currentUser.uid == _group.currentUserUid
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroupSettings(
                                            gid: _group.uid,
                                            name: _group.groupName,
                                            description: _group.description,
                                            rules: _group.rules,
                                            isPrivate: _group.isPrivate,
                                            isHidden: _group.isHidden,
                                            group: _group,
                                            currentuser: currentuser,
                                          ))).then((val) {
                                retrieveGroupDetails();
                                if (!mounted) return;
                                setState(() {
                                  _group = _group;
                                });
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: screenSize.width / 30,
                                top: screenSize.height * 0.15,
                              ),
                              child: Container(
                                height: screenSize.height * 0.045,
                                width: screenSize.width / 6,
                                child: Center(
                                    child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontNameDefault,
                                    color: Colors.black,
                                    fontSize: textButton(context),
                                  ),
                                )),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.5, color: Colors.black54),
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                //  right: screenSize.width / 30,
                // top: screenSize.height * 0.012,
              ),
              child: Chip(
                backgroundColor: Colors.white,
                avatar: Icon(Icons.public),
                label: Text(
                  _group.groupName != null ? _group.groupName : '',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                //  top: screenSize.height * 0.012,
              ),
              child: Chip(
                backgroundColor: Colors.white,
                avatar: Icon(Icons.location_on),
                label: Text(
                  _group.location != null ? _group.location : '',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenSize.width / 30, top: screenSize.height * 0.012),
              child: Text(
                _group.description != null ? _group.description : '',
                style: TextStyle(fontSize: screenSize.height * 0.022),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
              ),
              child: Container(
                height: screenSize.height * 0.01,
                color: Colors.grey[200],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenSize.width / 30, top: screenSize.height * 0.012),
              child: Text(
                'Group Rules',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                ),
              ),
            ),
            _group.rules != null && _group.rules.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width / 4,
                        vertical: screenSize.height * 0.01),
                    child: Text(
                      'No rules added',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      _group != null
                          ? getTextWidgets(_group.rules)
                          : Container(),
                    ],
                  ),
            Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.01,
              ),
              child: Container(
                height: screenSize.height * 0.01,
                color: Colors.grey[200],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenSize.width / 30, top: screenSize.height * 0.012),
              child: Text(
                'Admin',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textSubTitle(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
            InkWell(
              onTap: () {
                if (currentuser.uid != _group.currentUserUid) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstaFriendProfileScreen(
                              uid: _group.currentUserUid,
                              name: _group.groupOwnerName)));
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            offset: Offset(1.0, 1.0),
                            spreadRadius: 1.0,
                            blurRadius: 1.0),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset.zero,
                            spreadRadius: 0.0,
                            blurRadius: 0.0)
                      ]),
                  child: ListTile(
                    title: Text(
                      _group.groupOwnerName != null
                          ? _group.groupOwnerName
                          : '',
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          CachedNetworkImageProvider(_group.groupOwnerPhotoUrl),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.2,
            ),
          ],
        ),
      ],
    );
  }

  Widget groupInfoPrivate() {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      controller: _scrollController6,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              fit: StackFit.loose,
              alignment: Alignment.topLeft,
              children: [
                Container(
                  height: screenSize.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepPurple,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenSize.width / 30,
                    top: screenSize.height * 0.12,
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: screenSize.height * 0.07,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(_group
                                          .groupProfilePhoto !=
                                      null &&
                                  _group.groupProfilePhoto != ''
                              ? _group.groupProfilePhoto
                              : 'https://firebasestorage.googleapis.com/v0/b/socialnetwork-cbb55.appspot.com/o/group_no-image.png?alt=media&token=7c646dd5-5ec4-467d-9639-09f97c6dc5f0'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
              ),
              child: Chip(
                backgroundColor: Colors.white,
                avatar: Icon(Icons.public),
                label: Text(
                  _group.groupName != null ? _group.groupName : '',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.height * 0.018),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
              ),
              child: Chip(
                backgroundColor: Colors.white,
                avatar: Icon(Icons.location_on),
                label: Text(
                  _group.location != null ? _group.location : '',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    fontFamily: FontNameDefault,
                    fontSize: textBody1(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenSize.width / 30, top: screenSize.height * 0.012),
              child: Text(
                _group.description != null ? _group.description : '',
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                ),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.1,
            ),
          ],
        ),
      ],
    );
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _repository.uploadImageToStorage(imageFile).then((url) {
                      _repository.updatePhoto(url, _group.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              // SimpleDialogOption(
              //   child: Text('Take Photo'),
              //   onPressed: () {
              //     _pickImage('Camera').then((selectedImage) {
              //       setState(() {
              //         imageFile = selectedImage;
              //       });
              //       compressImage();
              //       _repository.uploadImageToStorage(imageFile).then((url) {
              //         _repository.updatePhoto(url, _group.uid).then((v) {
              //           Navigator.pop(context);
              //         });
              //       });
              //     });
              //   },
              // ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  File imageFile;
  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);

    return File(selectedImage.path);
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    //Im.copyResize(image, 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }
}
