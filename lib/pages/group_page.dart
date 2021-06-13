import 'dart:io';
import 'package:Yujai/models/group.dart';
import 'package:Yujai/models/member.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/group_activity.dart';
import 'package:Yujai/pages/group_chat.dart';
import 'package:Yujai/pages/group_inbox.dart';
import 'package:Yujai/pages/group_settings.dart';
import 'package:Yujai/pages/group_upload_ad.dart';
import 'package:Yujai/pages/group_upload_discussion.dart';
import 'package:Yujai/pages/group_upload_forum.dart';
import 'package:Yujai/pages/group_upload_poll.dart';
import 'package:Yujai/pages/home.dart';
import 'package:Yujai/pages/new_poll_form.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/nested_tab_bar_group_home.dart';
import 'package:Yujai/widgets/new_ad_screen.dart';
import 'package:Yujai/widgets/new_poll_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';
import 'package:Yujai/pages/group_upload_event.dart';
import 'package:Yujai/widgets/new_post_screen.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:Yujai/widgets/new_event_screen.dart';

class GroupPage extends StatefulWidget {
  final String gid;
  final String name;
  final bool isMember;
  final User currentUser;

  const GroupPage({
    this.gid,
    this.name,
    this.isMember,
    this.currentUser,
  });
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  TabController _tabController;
  var _repository = Repository();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Group _group;
  IconData icon;
  Color color;
  final TextStyle style =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  ScrollController _scrollController;
  //Offset state <-------------------------------------
  double offset = 0.0;
  String currentUserId, followingUserId;
  File imageFile;
  bool isCompany = false;
  static User currentuser;
  bool isMember;
  bool userAgreed = false;
  bool valueFirst = false;
  bool isFollowing = false;
  bool isPrivate = false;
  bool isRequested;
  bool followButtonClicked = false;
  String selectedSubject;
  bool scrollVisible = true;

  Future<void> send() async {
    final Email email = Email(
      body: '\n Group ID : ${widget.gid}' + '\n Sent from Yujai',
      subject: selectedSubject,
      recipients: ['animusitmanagement@gmail.com'],
      //attachmentPaths: [widget.documentSnapshot.data['imgUrl']],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
    print('$platformResponse');
    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(platformResponse),
    // ));
    Navigator.pop(context);
  }

  // fetchUidBySearchedName(String name) async {
  //   print("NAME : $name");
  //   String uid = await _repository.fetchUidBySearchedName(name);
  //   if (!mounted) return;
  //   setState(() {
  //     followingUserId = uid;
  //   });
  //   fetchUserDetailsById(uid);
  // }

  // fetchUserDetailsById(String userId) async {
  //   Group group = await _repository.fetchGroupDetailsById(widget.gid);
  //   if (!mounted) return;
  //   setState(() {
  //     _group = group;
  //   });
  // }
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
    isMember = false;
    isRequested = false;
    //fetchUidBySearchedName(widget.gid);
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
      _repository
          .checkIsMember(widget.currentUser.uid, widget.gid)
          .then((value) {
        print("VALUE : $value");
        if (!mounted) return;
        setState(() {
          isMember = value;
        });
      });

      _repository
          .checkIsRequestedGroup(widget.currentUser.uid, widget.gid)
          .then((value) {
        print("Request : $value");
        if (!mounted) return;
        setState(() {
          isRequested = value;
        });
      });
    });

    _tabController = TabController(length: 1, vsync: this);
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          //<----------------
          offset = _scrollController.offset;
          //force arefresh so the app bar can be updated
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  BoomMenu buildBoomMenu() {
    return BoomMenu(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        //child: Icon(Icons.add),
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        scrollVisible: scrollVisible,
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        children: [
          MenuItem(
//          child: Icon(Icons.accessibility, color: Colors.black, size: 40,),
            child: Image.asset('assets/images/picture.png',
                color: Colors.grey[850]),
            title: "Discussion",
            titleColor: Colors.grey[850],
            subtitle: "Upload post or start a discussion ",
            subTitleColor: Colors.grey[850],
            backgroundColor: Colors.grey[100],
            onTap: () {
              //  Navigator.pop(context);
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0))),
                  backgroundColor: Colors.white,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: NewPostScreen(
                          group: _group, currentUser: currentuser)));
            },
          ),
          MenuItem(
            child: Image.asset('assets/images/calendar.png',
                color: Colors.grey[850]),
            title: "Event",
            titleColor: Colors.grey[850],
            subtitle: "Start an offline or online event",
            subTitleColor: Colors.grey[850],
            backgroundColor: Colors.grey[300],
            onTap: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0))),
                  backgroundColor: Colors.white,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: NewEventScreen(
                          group: _group, currentUser: currentuser)));
            },
          ),
          MenuItem(
              child: Image.asset('assets/images/poll.png', color: Colors.white),
              title: "Poll",
              titleColor: Colors.white,
              subtitle: "Create a group poll or ask a question",
              subTitleColor: Colors.white,
              backgroundColor: Colors.grey[600],
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: NewPollScreen(
                            group: _group, currentUser: currentuser)));
              }),
          MenuItem(
            child: Image.asset('assets/images/marketplace.png',
                color: Colors.white70),
            title: "Ad",
            titleColor: Colors.white70,
            subtitle: "Create an ad for selling product",
            subTitleColor: Colors.white70,
            backgroundColor: Colors.grey[800],
            onTap: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0))),
                  backgroundColor: Colors.white,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: NewAdScreen(
                          group: _group, currentUser: currentuser)));
            },
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: new Color(0xffffffff),
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              elevation: 0.5,
              title: Row(
                children: <Widget>[
                  _group != null
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: screenSize.height * 0.03,
                          backgroundImage: NetworkImage(_group
                                          .groupProfilePhoto !=
                                      null &&
                                  _group.groupProfilePhoto != ''
                              ? _group.groupProfilePhoto
                              : 'https://firebasestorage.googleapis.com/v0/b/socialnetwork-cbb55.appspot.com/o/group_no-image.png?alt=media&token=7c646dd5-5ec4-467d-9639-09f97c6dc5f0'),
                        )
                      : Container(),
                  _group != null
                      ? Padding(
                          padding: EdgeInsets.only(left: screenSize.width / 30),
                          child: Text(
                            _group.groupName,
                            style: TextStyle(
                                fontSize: textHeader(context),
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(),
                ],
              ),
              leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left,
                      color: Colors.black54, size: screenSize.height * 0.045),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: [
                widget.currentUser.uid != null && _group != null && isMember
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: screenSize.height * 0.023,
                          child: InkWell(
                            onTap:
                                widget.currentUser.uid == _group.currentUserUid
                                    ? _onButtonPressedAdmin
                                    : _onButtonPressedUser,
                            child: Icon(
                              Icons.add,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                isMember
                    ? InkWell(
                        onTap: () => _scaffoldKey.currentState.openEndDrawer(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.menu,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            _showFormDialog();
                          },
                          child: Text(
                            'Join',
                            style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textButton(context),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )

                // widget.isMember == false && isMember == false
                //     ? isRequested == true
                //         ? Padding(
                //             padding: EdgeInsets.symmetric(
                //               vertical: screenSize.height * 0.015,
                //               horizontal: screenSize.width / 50,
                //             ),
                //             child: GestureDetector(
                //               onTap: () {},
                //               child: Container(
                //                 height: screenSize.height * 0.055,
                //                 width: screenSize.width / 5,
                //                 child: Center(
                //                   child: Text(
                //                     'Pending',
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: screenSize.height * 0.018,
                //                     ),
                //                   ),
                //                 ),
                //                 decoration: ShapeDecoration(
                //                   color: Theme.of(context).primaryColor,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(60.0),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           )
                //         : Padding(
                //             padding: EdgeInsets.symmetric(
                //               vertical: screenSize.height * 0.015,
                //               horizontal: screenSize.width / 50,
                //             ),
                //             child: GestureDetector(
                //               onTap: _showFormDialog,
                //               child: Container(
                //                 height: screenSize.height * 0.055,
                //                 width: screenSize.width / 5,
                //                 child: Center(
                //                   child: Text(
                //                     'Join',
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: screenSize.height * 0.018,
                //                     ),
                //                   ),
                //                 ),
                //                 decoration: ShapeDecoration(
                //                   color: Theme.of(context).primaryColor,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(60.0),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           )
                //     : widget.currentUser.uid == _group.currentUserUid
                //         ? Padding(
                //             padding: EdgeInsets.symmetric(
                //               vertical: screenSize.height * 0.015,
                //               horizontal: screenSize.width / 50,
                //             ),
                //             child: GestureDetector(
                //               onTap: () {},
                //               child: Container(
                //                 height: screenSize.height * 0.055,
                //                 width: screenSize.width / 5,
                //                 child: Center(
                //                   child: Text(
                //                     'Admin',
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: screenSize.height * 0.018,
                //                     ),
                //                   ),
                //                 ),
                //                 decoration: ShapeDecoration(
                //                   color: Theme.of(context).primaryColor,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(60.0),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           )
                //         : Padding(
                //             padding: EdgeInsets.symmetric(
                //               vertical: screenSize.height * 0.015,
                //               horizontal: screenSize.width / 50,
                //             ),
                //             child: GestureDetector(
                //               onTap: leaveGroup,
                //               child: Container(
                //                 height: screenSize.height * 0.055,
                //                 width: screenSize.width / 5,
                //                 child: Center(
                //                   child: Text(
                //                     'Leave',
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: screenSize.height * 0.018,
                //                     ),
                //                   ),
                //                 ),
                //                 decoration: ShapeDecoration(
                //                   color: Theme.of(context).primaryColor,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(60.0),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
              ],
              backgroundColor: Color(0xFFffffff),
              // expandedHeight: screenSize.height * 0.2,
              // flexibleSpace: FlexibleSpaceBar(
              //   background: Image.asset(
              //     'assets/images/work.jpg',
              //     fit: BoxFit.cover,
              //   ),
              // ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                    [_group != null ? buildButtonBar() : Container()]))
          ],
        ),
        //   floatingActionButton: buildBoomMenu(),
        //  FloatingActionButton(
        //   heroTag: null,
        //   child: Icon(
        //     Icons.add,
        //     size: screenSize.height * 0.05,
        //   ),
        //   onPressed:
        //       widget.currentUser != null && _group != null ? checkUser : null,
        // ),
        endDrawer: widget.currentUser.uid != null &&
                _group != null &&
                widget.currentUser.uid == _group.currentUserUid
            ? Drawer(
                child: Container(
                  color: const Color(0xff251F34),
                  child: Column(
                    children: [
                      UserAccountsDrawerHeader(
                        arrowColor: Colors.white,
                        decoration: BoxDecoration(
                          color: const Color(0xff251F34),
                        ),
                        currentAccountPicture: Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.02),
                          child: CircleAvatar(
                            radius: screenSize.height * 0.04,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(_group
                                            .groupProfilePhoto !=
                                        null &&
                                    _group.groupProfilePhoto != ''
                                ? _group.groupProfilePhoto
                                : 'https://firebasestorage.googleapis.com/v0/b/socialnetwork-cbb55.appspot.com/o/group_no-image.png?alt=media&token=7c646dd5-5ec4-467d-9639-09f97c6dc5f0'),
                          ),
                        ),
                        accountName: Text(
                          _group != null ? _group.groupName : '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: FontNameDefault,
                              color: Colors.white,
                              fontSize: textSubTitle(context)),
                        ),
                        accountEmail: _group != null
                            ? _group.isPrivate
                                ? Icon(
                                    Icons.lock_outline,
                                    color: Colors.white,
                                  )
                                : Icon(Icons.public_outlined,
                                    color: Colors.white)
                            : Icon(Icons.public_outlined, color: Colors.white),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GroupChat(
                                              recieverGroup: _group,
                                              name: widget.currentUser.uid,
                                            )));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.message_outlined,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Group Chat',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GroupActivity(
                                              currentUser: widget.currentUser,
                                              isMember: false,
                                              gid: _group.uid,
                                              name: _group.groupName,
                                            )));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.assistant_photo_outlined,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'My Activity',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GroupInbox(
                                            gid: _group.uid,
                                            name: _group.groupName,
                                            group: _group,
                                            currentuser: currentuser)));
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Inbox',
                                  style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.white,
                                      fontSize: textSubTitle(context)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Column(
                                children: <Widget>[
                                  Divider(
                                    color: Colors.white,
                                    thickness: 0.1,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupSettings(
                                                      gid: widget.gid,
                                                      name: widget.name,
                                                      group: _group,
                                                      currentuser: currentuser,
                                                      isPrivate:
                                                          _group.isPrivate,
                                                      isHidden: _group.isHidden,
                                                    )));
                                      },
                                      child: ListTile(
                                          leading: Icon(
                                            Icons.settings,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            'Settings',
                                            style: TextStyle(
                                                fontFamily: FontNameDefault,
                                                color: Colors.white,
                                                fontSize:
                                                    textSubTitle(context)),
                                          ))),
                                  InkWell(
                                    onTap: () {},
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.account_circle_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Invite member',
                                          style: TextStyle(
                                              fontFamily: FontNameDefault,
                                              color: Colors.white,
                                              fontSize: textSubTitle(context)),
                                        )),
                                  )
                                ],
                              ))),
                    ],
                  ),
                ),
              )
            : isMember
                ? Drawer(
                    child: Container(
                      color: const Color(0xff251F34),
                      child: Column(
                        children: [
                          UserAccountsDrawerHeader(
                            arrowColor: Colors.white,
                            decoration: BoxDecoration(
                              color: const Color(0xff251F34),
                            ),
                            currentAccountPicture: Padding(
                              padding: EdgeInsets.only(
                                  top: screenSize.height * 0.02),
                              child: CircleAvatar(
                                radius: screenSize.height * 0.04,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(_group
                                                .groupProfilePhoto !=
                                            null &&
                                        _group.groupProfilePhoto != ''
                                    ? _group.groupProfilePhoto
                                    : 'https://firebasestorage.googleapis.com/v0/b/socialnetwork-cbb55.appspot.com/o/group_no-image.png?alt=media&token=7c646dd5-5ec4-467d-9639-09f97c6dc5f0'),
                              ),
                            ),
                            accountName: Text(
                              _group != null ? _group.groupName : '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontNameDefault,
                                  color: Colors.white,
                                  fontSize: textSubTitle(context)),
                            ),
                            accountEmail: _group != null
                                ? _group.isPrivate
                                    ? Icon(
                                        Icons.lock_outline,
                                        color: Colors.white,
                                      )
                                    : Icon(Icons.public_outlined,
                                        color: Colors.white)
                                : Icon(Icons.public_outlined,
                                    color: Colors.white),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupChat(
                                                  recieverGroup: _group,
                                                  name: widget.currentUser.uid,
                                                )));
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.message_outlined,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Group Chat',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context)),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupActivity(
                                                  currentUser:
                                                      widget.currentUser,
                                                  isMember: false,
                                                  gid: _group.uid,
                                                  name: _group.groupName,
                                                )));
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.assistant_photo_outlined,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'My Activity',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context)),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupInbox(
                                                gid: _group.uid,
                                                name: _group.groupName,
                                                group: _group,
                                                currentuser: currentuser)));
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Inbox',
                                      style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          color: Colors.white,
                                          fontSize: textSubTitle(context)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Column(
                                    children: <Widget>[
                                      Divider(
                                        color: Colors.white,
                                        thickness: 0.1,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            showReport(widget.gid, context);
                                          },
                                          child: ListTile(
                                              leading: Icon(
                                                Icons.report_outlined,
                                                color: Colors.white,
                                              ),
                                              title: Text(
                                                'Report group',
                                                style: TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    color: Colors.white,
                                                    fontSize:
                                                        textSubTitle(context)),
                                              ))),
                                      InkWell(
                                        onTap: leaveGroup,
                                        child: ListTile(
                                            leading: Icon(
                                              Icons.exit_to_app_rounded,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                              'Leave group',
                                              style: TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  color: Colors.white,
                                                  fontSize:
                                                      textSubTitle(context)),
                                            )),
                                      )
                                    ],
                                  ))),
                        ],
                      ),
                    ),
                  )
                : Container(),
      ),
    );
  }

  checkUser() {
    if (widget.currentUser.uid == _group.currentUserUid) {
      return _onButtonPressedAdmin();
    } else if (widget.isMember == true || isMember == true) {
      return _onButtonPressedUser();
    } else {
      return _onButtonPressedJoin();
    }
  }

  showReport(String id, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Report this group',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context),
                      color: Colors.redAccent),
                ),
                onPressed: () {
                  _showReportDialog(context);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _showReportDialog(BuildContext context) async {
    var screenSize = MediaQuery.of(context).size;
    return await showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: ((BuildContext context, setState) {
            return AlertDialog(
              content: SizedBox(
                height: screenSize.height * 0.5,
                child: Wrap(
                  //  mainAxisSize: MainAxisSize.min,
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(
                          fontSize: textHeader(context),
                          fontFamily: FontNameDefault,
                          fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                        title: Text(
                          'Spam',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context)),
                        ),
                        groupValue: selectedSubject,
                        value: 'Spam',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Pornographic',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context)),
                        ),
                        groupValue: selectedSubject,
                        value: 'Pornographic',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Misleading',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context)),
                        ),
                        groupValue: selectedSubject,
                        value: 'Misleading',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Hacked',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context)),
                        ),
                        groupValue: selectedSubject,
                        value: 'Hacked',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Offensive',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: textSubTitle(context)),
                        ),
                        groupValue: selectedSubject,
                        value: 'Offensive',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: screenSize.height * 0.01,
                    //       horizontal: screenSize.width / 30),
                    //   child: Text('Comment'),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: screenSize.height * 0.01,
                    //       horizontal: screenSize.width / 30),
                    //   child: TextFormField(
                    //     controller: _bodyController,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.01,
                          horizontal: screenSize.width / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    fontSize: textSubTitle(context),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () {
                              send().then((value) => Navigator.pop(context));
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: textSubTitle(context),
                                  fontFamily: FontNameDefault,
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }));
        }));
  }

  void _onButtonPressedUser() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: -18,
                right: 6,
                child: InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.28,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.chat_bubble_outline,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Discussion',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: NewPostScreen(
                                    group: _group, currentUser: currentuser)));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        MdiIcons.shoppingOutline,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Ad',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: NewAdScreen(
                                    group: _group, currentUser: currentuser)));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.poll_outlined,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Poll',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: NewPollScreen(
                                    group: _group, currentUser: currentuser)));
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => GroupUploadPoll(
                        //               group: _group,
                        //               gid: widget.gid,
                        //               name: widget.name,
                        //             )));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void _onButtonPressedJoin() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: screenSize.height * 0.18,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    MdiIcons.receipt,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Report Group',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: _showImageDialogAd,
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    size: screenSize.height * 0.04,
                  ),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textSubTitle(context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  _showFormDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Wrap(
                            children: [
                              Text(
                                'Group Rules',
                                style: TextStyle(
                                    fontSize: screenSize.height * 0.03,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.06,
                        ),
                        Text(
                          _group.rules.join('\n\n'),
                        ),
                        Text(_group.customRules),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.deepPurpleAccent,
                              value: this.valueFirst,
                              onChanged: (bool value) {
                                setState(() {
                                  //  _openAgreeDialog(context);
                                  this.valueFirst = value;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                //_openAgreeDialog(context);
                              },
                              child: Text(
                                'Accept Group Rules & Conditions',
                                style: TextStyle(
                                    fontSize: screenSize.height * 0.022),
                              ),
                            ),
                          ],
                        ),
                        valueFirst
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width / 50,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    joinGroup();
                                  },
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width / 5,
                                    child: Center(
                                      child: Text(
                                        'Join',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenSize.height * 0.022,
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height * 0.015,
                                  horizontal: screenSize.width / 50,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: screenSize.height * 0.055,
                                    width: screenSize.width / 5,
                                    child: Center(
                                      child: Text(
                                        'Join',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenSize.height * 0.022,
                                        ),
                                      ),
                                    ),
                                    decoration: ShapeDecoration(
                                      color: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }));
  }

  joinGroup() async {
    if (_group.isPrivate == false) {
      var _member = Member(
        ownerName: currentuser.displayName,
        ownerUid: currentuser.uid,
        ownerPhotoUrl: currentuser.photoUrl,
        accountType: '',
        timestamp: FieldValue.serverTimestamp(),
      );
      await Firestore.instance
          .collection('groups')
          .document(_group.uid)
          .collection('members')
          .document(currentuser.uid)
          .setData(_member.toMap(_member));

      var group = Group(
        uid: _group.uid,
        groupName: _group.groupName,
        groupProfilePhoto: _group.groupProfilePhoto,
        isPrivate: isPrivate,
      );
      return Firestore.instance
          .collection('users')
          .document(currentuser.uid)
          .collection('groups')
          .document(_group.uid)
          .setData(group.toMap(group))
          .then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupPage(
                        currentUser: currentuser,
                        isMember: false,
                        gid: _group.uid,
                        name: _group.groupName,
                      ))));
    } else {
      var _member = Member(
        ownerName: currentuser.displayName,
        ownerUid: currentuser.uid,
        ownerPhotoUrl: currentuser.photoUrl,
        accountType: '',
        timestamp: FieldValue.serverTimestamp(),
      );
      Firestore.instance
          .collection('groups')
          .document(_group.uid)
          .collection('requests')
          .document(currentuser.uid)
          .setData(_member.toMap(_member))
          .then((value) {
        setState(() {
          isRequested = true;
        });
      });
    }
  }

  leaveGroup() async {
    if (isMember == true) {
      await Firestore.instance
          .collection('groups')
          .document(_group.uid)
          .collection('members')
          .document(currentuser.uid)
          .delete()
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });

      return Firestore.instance
          .collection('users')
          .document(currentuser.uid)
          .collection('groups')
          .document(_group.uid)
          .delete()
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  void _onButtonPressedAdmin() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Stack(
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: -18,
                right: 6,
                child: InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Container(
                height: screenSize.height * 0.36,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.chat_bubble_outline,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Discussion',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: NewPostScreen(
                                    group: _group, currentUser: currentuser)));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.event_outlined,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Event',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);

                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: NewEventScreen(
                                    group: _group, currentUser: currentuser)));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        MdiIcons.shoppingOutline,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Ad',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: NewAdScreen(
                                    group: _group, currentUser: currentuser)));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.poll_outlined,
                        size: screenSize.height * 0.04,
                      ),
                      title: Text(
                        'Poll',
                        style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textSubTitle(context)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: NewPollScreen(
                                    group: _group, currentUser: currentuser)));
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => GroupUploadPoll(
                        //               group: _group,
                        //               gid: widget.gid,
                        //               name: widget.name,
                        //             )));
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  buildButtonBar() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          NestedTabBarGroupHome(
            group: _group,
            currentUser: widget.currentUser,
            isMember: isMember,
            gid: _group.uid,
            name: _group.groupName,
          ),
        ],
        controller: _tabController,
      ),
    );
  }

  Future<File> _pickImage(String action) async {
    PickedFile selectedImage;
    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().getImage(source: ImageSource.gallery)
        : await ImagePicker().getImage(source: ImageSource.camera);
    return File(selectedImage.path);
  }

  _showImageDialog() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupUploadForum(
                                  group: _group,
                                  gid: widget.gid,
                                  name: widget.name,
                                  imageFile: imageFile,
                                )));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  _showImageDialogEvent() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Upload event cover photo',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => GroupUploadEvent(
                    //               group: _group,
                    //               gid: widget.gid,
                    //               name: widget.name,
                    //               imageFile: imageFile,
                    //             ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  _showImageDialogAd() {
    var screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => GroupUploadAd(
                    //               group: _group,
                    //               gid: widget.gid,
                    //               name: widget.name,
                    //               imageFile: imageFile,
                    //             )));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textSubTitle(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }
}
