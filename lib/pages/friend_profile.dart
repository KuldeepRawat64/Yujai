import 'dart:async';

import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_activity_events.dart';
import 'package:Yujai/pages/friend_activity_jobs.dart';
import 'package:Yujai/pages/friend_activity_news.dart';
import 'package:Yujai/pages/send_mail.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:Yujai/widgets/flow_widget.dart';
import 'package:Yujai/widgets/nested_tab_bar_profile.dart';
import 'package:Yujai/widgets/skill_widgets.dart';
import 'package:Yujai/widgets/sliver_persistent_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/chat_detail_screen.dart';
import 'package:Yujai/pages/friend_activity.dart';
import 'package:Yujai/pages/friend_info.dart';
import 'package:Yujai/pages/friend_activity_applications.dart';
import 'package:Yujai/pages/home.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FriendProfileScreen extends StatefulWidget {
  final String name;
  final String uid;
  FriendProfileScreen({this.name, this.uid});

  @override
  _FriendProfileScreenState createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen>
    with TickerProviderStateMixin {
  String currentUserId, followingUserId;
  var _repository = Repository();
  TabController _tabController;
  static UserModel _user, currentuser;
  IconData icon;
  Color color;
  bool isFollowing = false;
  bool isPrivate = false;
  bool isRequested = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  String selectedSubject;
  final _bodyController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  //Offset state <-------------------------------------
  double offset = 0.0;
  var _tabs = ["Overview", "Skills", "Experience"];
  Completer<GoogleMapController> _gpsController = Completer();
  // inititalize _center
  Position _center;
  final Set<Marker> _markers = {};
  //GeoPoint geopint;

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text +
          '\n Owner ID : ${_user.uid}' +
          '\n Sent from Yujai',
      subject: selectedSubject,
      recipients: ['animusitmanagement@gmail.com'],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(platformResponse),
    // ));
    Navigator.pop(context);
  }

  Widget getTextWidgets(List<dynamic> strings) {
    var screenSize = MediaQuery.of(context).size;
    return Wrap(
      children: strings
          .map((items) => Padding(
                padding: EdgeInsets.all(screenSize.height * 0.005),
                child: chip(items, Colors.deepPurple[50]),
              ))
          .toList(),
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
          // fontWeight: FontWeight.bold,
          color: Colors.deepPurple[400],
          fontSize: 14,
        ),
      ),
      backgroundColor: color,
      elevation: 0.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(screenSize.height * 0.005),
    );
  }

  fetchUidBySearchedName(String name) async {
    print("NAME : $name");
    String uid = await _repository.fetchUidBySearchedName(name);
    if (!mounted) return;
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
    // _future = _repository.retreiveUserPosts(uid);
  }

  fetchUserDetailsById(String userId) async {
    UserModel user = await _repository.fetchUserDetailsById(widget.uid);
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
      _repository.checkIsFollowing(widget.uid, user.uid).then((value) {
        print("VALUE : $value");
        if (!mounted) return;
        setState(() {
          isFollowing = value;
        });
      });

      _repository.checkIsRequested(user.uid, widget.uid).then((value) {
        print("Request : $value");
        if (!mounted) return;
        setState(() {
          isRequested = value;
        });
      });

      if (!mounted) return;
      setState(() {
        currentUserId = widget.uid;
      });
    });
    fetchUidBySearchedName(widget.uid);
    selectedSubject = 'Spam';
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

  setSelectedSubject(String val) {
    setState(() {
      selectedSubject = val;
    });
  }

  followUser() {
    print('following user');
    _repository.followUser(
        currentUserId: currentUserId,
        followingUserId: followingUserId,
        followingUser: currentuser,
        currentUser: _user);
    addFollowToActivityFeed();
    if (!mounted) return;
    setState(() {
      isFollowing = true;
      followButtonClicked = true;
      isRequested = false;
    });
  }

  void addFollowToActivityFeed() {
    var _feed = Feed(
      ownerName: currentuser.displayName,
      ownerUid: currentuser.uid,
      type: 'follow',
      ownerPhotoUrl: currentuser.photoUrl,
      timestamp: FieldValue.serverTimestamp(),
      commentData: '',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('items')
        // .document(currentUser.uid)
        // .collection('likes')
        .doc(currentuser.uid)
        .set(_feed.toMap(_feed))
        .then((value) {
      print('Feed added');
    });
  }

  addRequestToActivityFeed() {
    var _feed = Feed(
      ownerName: currentuser.displayName,
      ownerUid: currentuser.uid,
      type: 'request',
      ownerPhotoUrl: currentuser.photoUrl,
      timestamp: FieldValue.serverTimestamp(),
      commentData: '',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('requests')
        // .document(currentUser.uid)
        // .collection('likes')
        .doc(currentuser.uid)
        .set(_feed.toMap(_feed))
        .then((value) {
      print('Follow request sent');
    });
    setState(() {
      isRequested = true;
      followButtonClicked = true;
      isFollowing = false;
    });
  }

  unfollowUser() {
    _repository.unFollowUser(
        currentUserId: currentUserId,
        followingUserId: followingUserId,
        followingUser: currentuser,
        currentUser: _user);
    removeFollowFromActivityFeed();
    if (!mounted) return;
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
      isRequested = false;
    });
  }

  void removeFollowFromActivityFeed() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('items')
        //.where('postId',isEqualTo:snapshot['postId'])
        // .document(currentuser.uid)
        // .collection('likes')
        .doc(currentuser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  void removeRequestFromActivityFeed() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('requests')
        //.where('postId',isEqualTo:snapshot['postId'])
        // .document(currentuser.uid)
        // .collection('likes')
        .doc(currentuser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    setState(() {
      isRequested = false;
      followButtonClicked = true;
    });
  }

  showReport() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  'Report profile',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  _showFormDialog(context)
                      .then((value) => Navigator.pop(context));
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  _showFormDialog(BuildContext context) async {
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                        title: Text('Spam'),
                        groupValue: selectedSubject,
                        value: 'Spam',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text('Pornographic'),
                        groupValue: selectedSubject,
                        value: 'Pornographic',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text('Misleading'),
                        groupValue: selectedSubject,
                        value: 'Misleading',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text('Hacked'),
                        groupValue: selectedSubject,
                        value: 'Hacked',
                        onChanged: (val) {
                          setState(() {
                            selectedSubject = val;
                          });
                        }),
                    RadioListTile(
                        title: Text('Offensive'),
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

  Widget buildButton(
      {String text,
      Color backgroundcolor,
      Color textColor,
      Color borderColor,
      Function function}) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: function,
      child: Container(
        width: screenSize.width * 0.25,
        height: screenSize.height * 0.05,
        decoration: BoxDecoration(
            color: backgroundcolor,
            borderRadius: BorderRadius.circular(60.0),
            border: Border.all(color: borderColor)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: FontNameDefault,
              color: textColor,
              //     fontSize: textSubTitle(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileButton() {
    //check owner id
    bool ownerId = currentuser.uid == widget.uid;

    if (!ownerId) {
      // already following user - should show unfollow button
      if (isFollowing) {
        return buildButton(
          text: "Unfollow",
          backgroundcolor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey,
          function: unfollowUser,
        );
      }

      // does not follow user - should show follow button
      if (!isFollowing && !isRequested) {
        return buildButton(
          text: "Follow",
          backgroundcolor: Colors.deepPurple,
          textColor: Colors.white,
          borderColor: Colors.white,
          function: isPrivate ? addRequestToActivityFeed : followUser,
        );
      }
      // if request sent
      if (isRequested && !isFollowing) {
        return buildButton(
          text: "Requested",
          backgroundcolor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey,
          function: removeRequestFromActivityFeed,
        );
      }
    }

    return Container();
    // buildButton(
    //     text: "Edit",
    //     backgroundcolor: Colors.white,
    //     textColor: Colors.black,
    //     borderColor: Colors.grey);
  }

  Widget buildButtonRow() {
    var screenSize = MediaQuery.of(context).size;
    //check owner id
    //   bool ownerId = false;
    //  ownerId = currentuser.uid == widget.uid;
    if (widget.uid != null && currentuser.uid != widget.uid) {
      return Padding(
        padding: EdgeInsets.only(
          left: screenSize.width / 30,
        ),
        child: Row(
          children: [
            buildProfileButton(),
            SizedBox(
              width: screenSize.width / 30,
            ),
            IconButton(
              icon: Icon(
                Icons.message_outlined,
                size: screenSize.height * 0.035,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ChatDetailScreen(
                              photoUrl: _user.photoUrl,
                              name: _user.displayName,
                              receiverUid: _user.uid,
                            ))));
              },
            ),
            SizedBox(
              width: screenSize.width / 30,
            ),
            IconButton(
              icon: Icon(
                Icons.mail_outline,
                size: screenSize.height * 0.035,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SendMail(
                          email: _user.email,
                        )));
              },
            ),
            SizedBox(
              width: screenSize.width / 30,
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.more_horiz_outlined,
            //     size: screenSize.height * 0.035,
            //     color: Colors.black54,
            //   ),
            //   onPressed: () {
            //     showReport();
            //   },
            // ),
          ],
        ),
      );
    }
    return Container();
  }

  checkMilitaryType() {
    if (_user.military == 'Indian Army') {
      return armyImage();
    } else if (_user.military == 'Indian Air Force') {
      return airforceImage();
    } else if (_user.military == 'Indian Navy') {
      return navyImage();
    } else
      backgroundImage();
  }

  Widget backgroundImage() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.orange,
          Colors.white,
          Colors.green,
        ])),
      ),
    );
  }

  Widget armyImage() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/army_flag.png'),
          ),
        ),
      ),
    );
  }

  Widget airforceImage() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/airforce_flag.png'),
          ),
        ),
      ),
    );
  }

  Widget navyImage() {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/naval_flag.png'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Material(
        child: _user == null
            ? Container()
            : _user.accountType == 'Company'
                ? Scaffold(
                    appBar: AppBar(
                      elevation: 0.5,
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz_outlined,
                            size: screenSize.height * 0.035,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            showReport();
                          },
                        ),
                      ],
                      title: Text(
                        'Profile',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: textHeader(context),
                        ),
                      ),
                      backgroundColor: Color(0xffffffff),
                      leading: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black54,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    body: ListView(
                      children: <Widget>[
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
                                      color: Color(0xff251F34),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: screenSize.width / 30,
                                    top: screenSize.height * 0.12,
                                  ),
                                  child: CircleAvatar(
                                    radius: screenSize.height * 0.07,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(
                                      _user.photoUrl,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.width / 30,
                                top: screenSize.height * 0.012,
                              ),
                              child: Text(
                                _user.displayName,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                            ),
                            buildButtonRow(),
                          ],
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       vertical: screenSize.height * 0.012),
                        //   child: Container(
                        //     height: screenSize.height * 0.01,
                        //     color: Colors.grey[200],
                        //   ),
                        // ),
                        SizedBox(
                          height: screenSize.height * 0.02,
                        ),
                        companyBody(),
                      ],
                    ))
                : DefaultTabController(
                    length: _tabs.length,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                            sliver: SliverAppBar(
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: buildProfileButton(),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.black54,
                                  ),
                                  onPressed: showReport,
                                )
                              ],
                              leading: IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              backgroundColor: Color(0xffffffff),
                              title: const Text(
                                'Profile',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //   pinned: true,
                              flexibleSpace: FlexibleSpaceBar(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: ListTile(
                                    minVerticalPadding: 2,
                                    contentPadding: EdgeInsets.zero,
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.message_outlined,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatDetailScreen(
                                                      photoUrl: _user.photoUrl,
                                                      name: _user.displayName,
                                                      receiverUid: _user.uid,
                                                    )));
                                      },
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 15,
                                      backgroundImage:
                                          NetworkImage(_user.photoUrl),
                                    ),
                                    title: Text(
                                      _user.displayName,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      _user.designation,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: 10,
                                        //   fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              elevation: 0,
                              floating: true,
                              snap: true,
                              expandedHeight: screenSize.height * 0.22,
                              collapsedHeight: screenSize.height * 0.1,
                              forceElevated: innerBoxIsScrolled,
                              bottom: TabBar(
                                unselectedLabelStyle: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                  fontWeight: FontWeight.bold,
                                ),
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                //controller: _nestedTabController,
                                indicatorColor: Colors.purpleAccent,
                                labelColor: Theme.of(context).primaryColor,
                                unselectedLabelColor: Colors.black54,
                                labelStyle: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textSubTitle(context),
                                  fontWeight: FontWeight.bold,
                                ),
                                isScrollable: true,
                                tabs: _tabs
                                    .map((String name) => Tab(
                                          text: name,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          // SliverAppBar(
                          //   actions: [
                          //     IconButton(
                          //         onPressed: null,
                          //         icon: Icon(
                          //           Icons.more_horiz,
                          //           color: Colors.black,
                          //         ))
                          //   ],
                          //   floating: true,
                          //   //      pinned: true,
                          //   elevation: 0.5,
                          //   leading: IconButton(
                          //       icon: Icon(Icons.keyboard_arrow_left,
                          //           color: Colors.black54, size: screenSize.height * 0.045),
                          //       onPressed: () {
                          //         Navigator.pop(context);
                          //       }),
                          //   backgroundColor: Color(0xFFffffff),
                          //   expandedHeight: screenSize.height * 0.2,
                          //   collapsedHeight: kToolbarHeight,
                          //   flexibleSpace: FlexibleSpaceBar(
                          //     stretchModes: [
                          //       StretchMode.zoomBackground,
                          //       StretchMode.fadeTitle,
                          //       StretchMode.blurBackground
                          //     ],
                          //     title: ListTile(
                          //       leading: CircleAvatar(
                          //         backgroundColor: Colors.white,
                          //         radius: screenSize.height * 0.03,
                          //         backgroundImage: NetworkImage(_user.photoUrl),
                          //       ),
                          //       title: Padding(
                          //         padding: EdgeInsets.only(left: screenSize.width / 30),
                          //         child: Text(
                          //           _user.displayName,
                          //           style: TextStyle(
                          //               fontSize: screenSize.height * 0.018,
                          //               color: Colors.black54,
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //       ),
                          //     ),
                          //     background: DecoratedBox(
                          //       position: DecorationPosition.foreground,
                          //       decoration: BoxDecoration(
                          //         gradient: LinearGradient(
                          //           begin: Alignment.bottomCenter,
                          //           end: Alignment.center,
                          //           colors: <Color>[
                          //             Colors.deepPurple[300],
                          //             Colors.transparent,
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ];
                      },
                      // backgroundColor: new Color(0xffffffff),
                      // appBar: AppBar(
                      //   elevation: 0.5,
                      //   actions: [
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(
                      //         vertical: screenSize.height * 0.02,
                      //         horizontal: screenSize.width / 50,
                      //       ),
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           Navigator.of(context)
                      //               .push(MaterialPageRoute(builder: (context) => Home()));
                      //         },
                      //         child: Container(
                      //           height: screenSize.height * 0.055,
                      //           width: screenSize.width * 0.15,
                      //           child: Center(child: Icon(Icons.home_outlined)),
                      //           decoration: ShapeDecoration(
                      //             color: Theme.of(context).primaryColor,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(60.0),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      //   leading: IconButton(
                      //       icon: Icon(
                      //         Icons.keyboard_arrow_left,
                      //         color: Colors.black54,
                      //         size: screenSize.height * 0.045,
                      //       ),
                      //       onPressed: () => Navigator.pop(context)),
                      //   //  centerTitle: true,
                      //   backgroundColor: Colors.white,
                      //   title: Text(
                      //     'Profile',
                      //     style: TextStyle(
                      //       fontFamily: FontNameDefault,
                      //       fontSize: textAppTitle(context),
                      //       color: Colors.black54,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      body: _user != null
                          ? TabBarView(children: [
                              overviewProfile(),
                              skillProfile(),
                              expProfile()
                            ])
                          //CustomScrollView(
                          //   physics: NeverScrollableScrollPhysics(),
                          //    controller: _scrollController,
                          //   slivers: [
                          // SliverAppBar(
                          //   actions: [
                          //     IconButton(
                          //         onPressed: null,
                          //         icon: Icon(
                          //           Icons.more_horiz,
                          //           color: Colors.black,
                          //         ))
                          //   ],
                          //   floating: true,
                          //   //      pinned: true,
                          //   elevation: 0.5,
                          //   leading: IconButton(
                          //       icon: Icon(Icons.keyboard_arrow_left,
                          //           color: Colors.black54,
                          //           size: screenSize.height * 0.045),
                          //       onPressed: () {
                          //         Navigator.pop(context);
                          //       }),
                          //   backgroundColor: Color(0xFFffffff),
                          //   expandedHeight: screenSize.height * 0.2,
                          //   collapsedHeight: kToolbarHeight,
                          //   flexibleSpace: FlexibleSpaceBar(
                          //     stretchModes: [
                          //       StretchMode.zoomBackground,
                          //       StretchMode.fadeTitle,
                          //       StretchMode.blurBackground
                          //     ],
                          //     title: ListTile(
                          //       leading: CircleAvatar(
                          //         backgroundColor: Colors.white,
                          //         radius: screenSize.height * 0.03,
                          //         backgroundImage: NetworkImage(_user.photoUrl),
                          //       ),
                          //       title: Padding(
                          //         padding: EdgeInsets.only(left: screenSize.width / 30),
                          //         child: Text(
                          //           _user.displayName,
                          //           style: TextStyle(
                          //               fontSize: screenSize.height * 0.018,
                          //               color: Colors.black54,
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //       ),
                          //     ),
                          //     background: DecoratedBox(
                          //       position: DecorationPosition.foreground,
                          //       decoration: BoxDecoration(
                          //         gradient: LinearGradient(
                          //           begin: Alignment.bottomCenter,
                          //           end: Alignment.center,
                          //           colors: <Color>[
                          //             Colors.deepPurple[300],
                          //             Colors.transparent,
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SliverPersistentHeader(
                          //   pinned: true,
                          //   floating: true,
                          //   delegate: ProfileHeader(
                          //       minExtent: 110,
                          //       maxExtent: 110,
                          //       name: _user.displayName,
                          //       photo: _user.photoUrl,
                          //       designation: _user.designation,
                          //       location: _user.location),
                          // ),
                          // SliverList(
                          //     delegate: SliverChildListDelegate(
                          //         [_user != null ? buildButtonBar() : Container()]))

                          : Center(child: CircularProgressIndicator()),
                    ),
                  ),
      ),
    );
  }

  Widget overviewProfile() {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      //   controller: _scrollController1,
      //  physics: NeverScrollableScrollPhysics(),
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xffffffff),
          ),
          child: Column(
            //    shrinkWrap: true,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bio',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textHeader(context),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(_user.bio,
                  style: TextStyle(
                    fontFamily: FontNameDefault,
                    //        fontSize: textHeader(context),
                    //      fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Color(0xffffffff),
            ),
            child: userBody()),
        Container(
            margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Color(0xffffffff),
            ),
            child: userActivityButtons()),
      ],
    );
  }

  buildButtonBar() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          NestedTabBarProfile(
            currentUser: currentuser,
            profileUser: _user,
          ),
        ],
        controller: _tabController,
      ),
    );
  }

  Widget userActivityButtons() {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (isPrivate && !isFollowing) {
              return;
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FriendActivity(
                        followingUser: currentuser,
                        user: _user,
                      )));
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width / 30,
              vertical: screenSize.height * 0.012,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontSize: textSubTitle(context),
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    isPrivate && !isFollowing
                        ? Icon(
                            MdiIcons.lockOutline,
                            color: Colors.black54,
                            //  size: screenSize.height * 0.05,
                          )
                        : Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black54,
                            size: screenSize.height * 0.05,
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (isPrivate && !isFollowing) {
              return;
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FriendInformationDetail(
                        user: _user,
                      )));
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width / 30,
              vertical: screenSize.height * 0.012,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Information',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontSize: textSubTitle(context),
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    isPrivate && !isFollowing
                        ? Icon(
                            Icons.lock_outline,
                            color: Colors.black54,
                            //    size: screenSize.height * 0.05,
                          )
                        : Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black54,
                            size: screenSize.height * 0.05,
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FriendActivityApplications(
                      followingUser: currentuser,
                      user: _user,
                    )));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width / 30,
              vertical: screenSize.height * 0.012,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Work Applications',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontSize: textSubTitle(context),
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black54,
                  size: screenSize.height * 0.05,
                )
              ],
            ),
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            height: screenSize.height * 0.05,
          ),
        ]),
      ],
    );
  }

  Widget skillProfile() {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skills',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textHeader(context),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              _user.skills == []
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.25,
                          vertical: screenSize.height * 0.01),
                      child: Text(
                        'Nothing to see here',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return SkillEventRow(SkillEvent(
                            skill: _user.skills[index]['skill'],
                            level: _user.skills[index]['level'].toDouble()));
                      },
                      // separatorBuilder:
                      //     (BuildContext context, int index) {
                      //   return SizedBox(
                      //     height: 2,
                      //   );
                      // },
                      itemCount: _user.skills.length),
            ],
          ),
        ),
      ],
    );
  }

  Widget expProfile() {
    var screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Experience',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textHeader(context),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              _user.experience != []
                  ? Card(
                      elevation: 0,
                      // margin: EdgeInsets.symmetric(
                      //     horizontal: screenSize.width * 0.2,
                      //     vertical: screenSize.height * 0.02
                      //     ),
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          Positioned(
                              left: 21,
                              top: 15,
                              bottom: 15,
                              child: VerticalDivider(
                                width: 1,
                                color: Colors.black54,
                              )),
                          ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) {
                                return FlowEventRow(FlowEvent(
                                    employmentType: _user.experience[index]
                                        ['employmentType'],
                                    isPresent: _user.experience[index]
                                        ['isPresent'],
                                    industry: _user.experience[index]
                                        ['industry'],
                                    company: _user.experience[index]['company'],
                                    designation: _user.experience[index]
                                        ['designation'],
                                    startDate: _user.experience[index]
                                        ['startCompany'],
                                    endDate: _user.experience[index]
                                        ['endCompany']));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 2,
                                );
                              },
                              itemCount: _user.experience.length)
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.25,
                          vertical: screenSize.height * 0.01),
                      child: Text(
                        'Nothing to see',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget companyBody() {
    _user.geoPoint != null
        ? _markers.add(
            Marker(
              // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId(_center.toString()),
              position:
                  LatLng(_user.geoPoint.latitude, _user.geoPoint.longitude),

              icon: BitmapDescriptor.defaultMarker,
            ),
          )
        : _markers.clear();
    var screenSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(left: screenSize.width / 30),
        child: Text(
          'About us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            fontSize: textHeader(context),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: screenSize.width / 30, top: screenSize.height * 0.012),
        child: Wrap(
          children: [
            Text(
              _user.bio,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                  color: Colors.black54),
            ),
          ],
        ),
      ),
      SizedBox(
        height: screenSize.height * 0.02,
      ),
      Padding(
        padding: EdgeInsets.only(left: screenSize.width / 30),
        child: Text(
          'Organization Info',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            fontSize: textHeader(context),
          ),
        ),
      ),
      _user.employees != ''
          ? Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employees',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                  Text(
                    _user.employees + ' employees',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                    ),
                  )
                ],
              ),
            )
          : Container(),
      _user.establishYear != ''
          ? Padding(
              padding: EdgeInsets.only(
                left: screenSize.width / 30,
                top: screenSize.height * 0.012,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Year of establishment',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                  Text(
                    _user.establishYear,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                    ),
                  )
                ],
              ),
            )
          : Container(),
      Padding(
        padding: EdgeInsets.only(
          left: screenSize.width / 30,
          top: screenSize.height * 0.012,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Industry',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontWeight: FontWeight.bold,
                fontSize: textSubTitle(context),
              ),
            ),
            Text(
              _user.industry,
              style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                  color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: screenSize.width / 30,
          top: screenSize.height * 0.012,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products and services',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontWeight: FontWeight.bold,
                fontSize: textSubTitle(context),
              ),
            ),
            Wrap(
              children: [
                Text(
                  _user.products,
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textBody1(context),
                      color: Theme.of(context).primaryColor),
                ),
              ],
            )
          ],
        ),
      ),
      SizedBox(
        height: screenSize.height * 0.02,
      ),
      _user.geoPoint != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.2,
                    vertical: screenSize.height * 0.005,
                  ),
                  child: Text(
                    _user.location,
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                      //  fontSize: textBody1(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: screenSize.width / 30,
                    left: screenSize.width / 30,
                    //top: screenSize.height * 0.012
                  ),
                  child: Container(
                    height: screenSize.height * 0.13,
                    width: screenSize.width,
                    margin: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.02),
                    child: GoogleMap(
                      markers: _markers,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(_user.geoPoint.latitude,
                              _user.geoPoint.longitude),
                          zoom: 12),
                      onMapCreated: (GoogleMapController controller) {
                        _gpsController.complete();
                      },
                    ),
                  ),
                ),
              ],
            )
          : Container(),
      SizedBox(
        height: screenSize.height * 0.02,
      ),
      Padding(
        padding: EdgeInsets.only(left: screenSize.width / 30),
        child: Text(
          'Contact',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            fontSize: textHeader(context),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: screenSize.width / 30,
          top: screenSize.height * 0.012,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontWeight: FontWeight.bold,
                fontSize: textSubTitle(context),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SendMail(
                          email: _user.email,
                        )));
              },
              child: Text(
                _user.email,
                style: TextStyle(
                  fontFamily: FontNameDefault,
                  fontSize: textBody1(context),
                ),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.012,
            ),
            _user.phone != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontWeight: FontWeight.bold,
                          fontSize: textSubTitle(context),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // launch(_user.phone.toString());
                        },
                        child: Text(
                          _user.phone,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.012,
                      ),
                    ],
                  )
                : Container(),
            _user.website != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Website',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontWeight: FontWeight.bold,
                          fontSize: textSubTitle(context),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyWebView(
                                    title: 'Company Website',
                                    selectedUrl: _user.website,
                                  )));
                        },
                        child: Text(
                          _user.website,
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: textBody1(context),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FriendActivity(
                    followingUser: currentuser,
                    user: _user,
                  )));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 30,
            vertical: screenSize.height * 0.012,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Posts',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FriendActivityNews(
                    followingUser: currentuser,
                    user: _user,
                  )));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 30,
            vertical: screenSize.height * 0.012,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Articles',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FriendActivityEvents(
                    followingUser: currentuser,
                    user: _user,
                  )));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 30,
            vertical: screenSize.height * 0.012,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FriendActivityJobs(
                    followingUser: currentuser,
                    user: _user,
                  )));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 30,
            vertical: screenSize.height * 0.012,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jobs',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FriendInformationDetail(
                    user: _user,
                  )));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width / 30,
            vertical: screenSize.height * 0.012,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Information',
                style: TextStyle(
                    fontFamily: FontNameDefault,
                    fontSize: textSubTitle(context),
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black54,
                size: screenSize.height * 0.05,
              )
            ],
          ),
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: screenSize.height * 0.05,
        ),
      ]),
    ]);
  }

  Widget userBody() {
    var screenSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _user.accountType == 'Military'
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Info',
                      style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textHeader(context),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    _user.rank.isNotEmpty && _user.rank != 'Select a Rank'
                        ? Wrap(
                            children: [
                              Text(
                                'Rank  :  ',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              Text(
                                _user.rank,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    _user.medal != null &&
                            _user.medal.isNotEmpty &&
                            _user.medal != 'Select a Medal'
                        ? Wrap(
                            children: [
                              Text(
                                'Medal  :  ',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              Text(
                                _user.medal,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    _user.regiment.isNotEmpty &&
                            _user.regiment != 'Select a Regiment'
                        ? Wrap(
                            children: [
                              Text(
                                'Regiment  :  ',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              Text(
                                _user.regiment,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    _user.command.isNotEmpty &&
                            _user.command != 'Select a Command'
                        ? Wrap(
                            children: [
                              Text(
                                'Command  :  ',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              Text(
                                _user.command,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    _user.department.isNotEmpty &&
                            _user.department != 'Select a Department'
                        ? Wrap(
                            children: [
                              Text(
                                'Department  :  ',
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textSubTitle(context),
                                ),
                              ),
                              Text(
                                _user.department,
                                style: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontSize: textBody1(context),
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    //  Divider(),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
              ],
            )
          : Container(),
      _user.interests.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interest',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Wrap(
                    children: [
                      _user != null
                          ? getTextWidgets(_user.interests)
                          : Text(
                              '',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            )
          : Container(),
      SizedBox(
        height: screenSize.height * 0.02,
      ),
      _user.purpose.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purpose',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Wrap(
                    children: [
                      _user != null
                          ? getTextWidgets(_user.purpose)
                          : Container(),
                    ],
                  ),
                ),
              ],
            )
          : Container(),
      SizedBox(
        height: screenSize.height * 0.02,
      ),
      _user.phone.isNotEmpty ||
              _user.website.isNotEmpty ||
              _user.email.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Details',
                  style: TextStyle(
                      fontFamily: FontNameDefault,
                      fontSize: textHeader(context),
                      fontWeight: FontWeight.bold),
                ),
                _user.phone.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              _user.gender == 'Female' || _user.isPrivate
                                  ? 'Private'
                                  : _user.phone,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                _user.website.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              'Portfolio',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              _user.website,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                _user.email.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: textSubTitle(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              _user.email,
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            )
          : Container(),
    ]);
  }
}
