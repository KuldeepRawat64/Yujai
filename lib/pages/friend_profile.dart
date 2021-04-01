import 'package:Yujai/models/feed.dart';
import 'package:Yujai/models/user.dart';
import 'package:Yujai/pages/friend_activity_events.dart';
import 'package:Yujai/pages/friend_activity_jobs.dart';
import 'package:Yujai/pages/friend_activity_news.dart';
import 'package:Yujai/pages/send_mail.dart';
import 'package:Yujai/pages/webview.dart';
import 'package:Yujai/resources/repository.dart';
import 'package:Yujai/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Yujai/pages/chat_detail_screen.dart';
import 'package:Yujai/pages/friend_activity.dart';
import 'package:Yujai/pages/friend_info.dart';
import 'package:Yujai/pages/friend_activity_applications.dart';
import 'package:Yujai/pages/home.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InstaFriendProfileScreen extends StatefulWidget {
  final String name;
  final String uid;
  InstaFriendProfileScreen({this.name, this.uid});

  @override
  _InstaFriendProfileScreenState createState() =>
      _InstaFriendProfileScreenState();
}

class _InstaFriendProfileScreenState extends State<InstaFriendProfileScreen> {
  String currentUserId, followingUserId;
  var _repository = Repository();
  static User _user, currentuser;
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
                padding: EdgeInsets.all(screenSize.height * 0.01),
                child: chip(items, Colors.deepPurple[100]),
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
    User user = await _repository.fetchUserDetailsById(widget.uid);
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
    Firestore.instance
        .collection('users')
        .document(_user.uid)
        .collection('items')
        // .document(currentUser.uid)
        // .collection('likes')
        .document(currentuser.uid)
        .setData(_feed.toMap(_feed))
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
    Firestore.instance
        .collection('users')
        .document(_user.uid)
        .collection('requests')
        // .document(currentUser.uid)
        // .collection('likes')
        .document(currentuser.uid)
        .setData(_feed.toMap(_feed))
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
    Firestore.instance
        .collection('users')
        .document(_user.uid)
        .collection('items')
        //.where('postId',isEqualTo:snapshot['postId'])
        // .document(currentuser.uid)
        // .collection('likes')
        .document(currentuser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  void removeRequestFromActivityFeed() {
    Firestore.instance
        .collection('users')
        .document(_user.uid)
        .collection('requests')
        //.where('postId',isEqualTo:snapshot['postId'])
        // .document(currentuser.uid)
        // .collection('likes')
        .document(currentuser.uid)
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
        width: screenSize.width / 2,
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
              fontSize: textSubTitle(context),
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
      child: Scaffold(
        backgroundColor: new Color(0xffffffff),
        appBar: AppBar(
          elevation: 0.5,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width / 50,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Home()));
                },
                child: Container(
                  height: screenSize.height * 0.055,
                  width: screenSize.width * 0.15,
                  child: Center(
                      child: Text(
                    'Home',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontNameDefault,
                      color: Colors.white,
                      fontSize: textButton(context),
                    ),
                  )),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
          leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black54,
                size: screenSize.height * 0.045,
              ),
              onPressed: () => Navigator.pop(context)),
          //  centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Profile',
            style: TextStyle(
              fontFamily: FontNameDefault,
              fontSize: textAppTitle(context),
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _user != null
            ? ListView(
                children: <Widget>[
                  _user.accountType != 'Company'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _user.accountType == 'Military'
                                ? Stack(
                                    fit: StackFit.loose,
                                    alignment: Alignment.topLeft,
                                    children: [
                                      checkMilitaryType(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: screenSize.width / 30,
                                          top: screenSize.height * 0.155,
                                        ),
                                        child: CircleAvatar(
                                          radius: screenSize.height * 0.07,
                                          backgroundColor: Colors.grey,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  _user.photoUrl),
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    fit: StackFit.loose,
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Container(
                                        height: screenSize.height * 0.17,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                          top: screenSize.height * 0.09,
                                        ),
                                        child: CircleAvatar(
                                          radius: screenSize.height * 0.07,
                                          backgroundColor: Colors.grey,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            _user.photoUrl,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.width / 30,
                                top: screenSize.height * 0.01,
                              ),
                              child: Text(_user.displayName,
                                  style: TextStyle(
                                    fontFamily: FontNameDefault,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: textSubTitle(context),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.width / 30,
                                top: screenSize.height * 0.01,
                              ),
                              child: _user.accountType == 'Military'
                                  ? Text(
                                      _user.military,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    )
                                  : _user.accountType.isNotEmpty
                                      ? Text(
                                          _user.accountType,
                                          style: TextStyle(
                                            fontFamily: FontNameDefault,
                                            fontSize: textBody1(context),
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Container(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.width / 30,
                                top: screenSize.height * 0.01,
                              ),
                              child: _user.location.isNotEmpty
                                  ? Text(
                                      _user.location,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Container(),
                            ),
                            buildButtonRow(),
                          ],
                        )
                      : Column(
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.012),
                    child: Container(
                      height: screenSize.height * 0.01,
                      color: Colors.grey[200],
                    ),
                  ),
                  _user.accountType != 'Company' ? userBody() : companyBody(),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget companyBody() {
    var screenSize = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(left: screenSize.width / 30),
        child: Text(
          'About us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: Divider(),
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
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.01,
          color: Colors.grey[200],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: screenSize.width / 30),
        child: Text(
          'Organization Info',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontNameDefault,
            fontSize: textSubTitle(context),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: Divider(),
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
              'Employees',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontWeight: FontWeight.bold,
                fontSize: textSubTitle(context),
              ),
            ),
            Text(
              _user.companySize + ' employees',
              style: TextStyle(
                fontFamily: FontNameDefault,
                fontSize: textBody1(context),
              ),
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
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.01,
          color: Colors.grey[200],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: screenSize.width / 30),
        child: Text(
          'Location',
          style: TextStyle(
            fontFamily: FontNameDefault,
            fontWeight: FontWeight.bold,
            fontSize: textSubTitle(context),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: Divider(),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: screenSize.width / 30, top: screenSize.height * 0.012),
        child: Text(
          _user.location,
          style: TextStyle(
            fontFamily: FontNameDefault,
            fontSize: textBody1(context),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.01,
          color: Colors.grey[200],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: screenSize.width / 30),
        child: Text(
          'Contact',
          style: TextStyle(
            fontFamily: FontNameDefault,
            fontWeight: FontWeight.bold,
            fontSize: textSubTitle(context),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width / 30),
        child: Divider(),
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
      Padding(
        padding: EdgeInsets.only(top: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.01,
          color: Colors.grey[200],
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
                ),
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
      Divider(
        thickness: 0.4,
        height: 0,
        color: Colors.grey[500],
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
                ),
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
      Divider(
        thickness: 0.4,
        height: 0,
        color: Colors.grey[500],
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
                  fontSize: textSubTitle(context),
                ),
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
      Divider(
        thickness: 0.4,
        height: 0,
        color: Colors.grey[500],
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
                ),
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
      Divider(
        thickness: 0.4,
        height: 0,
        color: Colors.grey[500],
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
                ),
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
      Padding(
        padding: EdgeInsets.only(bottom: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.01,
          color: Colors.grey[200],
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
      _user.bio.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Info',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: textSubTitle(context),
                        ),
                      ),
                      Divider(),
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
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'About',
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
                      right: screenSize.width / 30,
                      top: screenSize.height * 0.005),
                  child: Text(
                    _user.bio,
                    style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: textBody1(context),
                        color: Colors.black54),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.university.isNotEmpty ||
              _user.college.isNotEmpty ||
              _user.school.isNotEmpty
          // ||
          // _user.certification1.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Education & Qualification',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _user.university == ''
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenSize.height * 0.012),
                                  child: Text(
                                    'University',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _user.university,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      ', ' + _user.endUniversity,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.black54,
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  _user.stream,
                                  style: TextStyle(
                                    fontSize: screenSize.height * 0.018,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                      _user.college == ''
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenSize.height * 0.012),
                                  child: Text(
                                    'College',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _user.college,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      ', ' + _user.endCollege,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                      _user.school == ''
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenSize.height * 0.012),
                                  child: Text(
                                    'School',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _user.school,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      ', ' + _user.endSchool,
                                      style: TextStyle(
                                        fontFamily: FontNameDefault,
                                        fontSize: textBody1(context),
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                      _user.certification1.isEmpty ||
                              _user.certification2.isEmpty ||
                              _user.certification3.isEmpty
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenSize.height * 0.012),
                                  child: Text(
                                    'Certifications',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: textSubTitle(context),
                                    ),
                                  ),
                                ),
                                _user.certification1.isNotEmpty
                                    ? Text(
                                        _user.certification1,
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.black54,
                                        ),
                                      )
                                    : Container(),
                                _user.certification2.isNotEmpty
                                    ? Text(
                                        _user.certification2,
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.black54,
                                        ),
                                      )
                                    : Container(),
                                _user.certification3.isNotEmpty
                                    ? Text(
                                        _user.certification3,
                                        style: TextStyle(
                                          fontFamily: FontNameDefault,
                                          fontSize: textBody1(context),
                                          color: Colors.black54,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.company1.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Experience',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenSize.width / 30,
                        top: screenSize.height * 0.012,
                      ),
                      child: Text(
                        _user.company1 +
                            '   (' +
                            _user.startCompany1 +
                            ' ' +
                            '- ' +
                            _user.endCompany1 +
                            ')   ',
                        style: TextStyle(
                          fontFamily: FontNameDefault,
                          fontSize: textBody1(context),
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    _user.company2.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              _user.company2 +
                                  '   (' +
                                  _user.startCompany2 +
                                  ' ' +
                                  '- ' +
                                  _user.endCompany2 +
                                  ')   ',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : Container(),
                    _user.company3.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width / 30,
                              top: screenSize.height * 0.012,
                            ),
                            child: Text(
                              _user.company3 +
                                  '   (' +
                                  _user.startCompany3 +
                                  ' ' +
                                  '- ' +
                                  _user.endCompany3 +
                                  ')   ',
                              style: TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: textBody1(context),
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.skills.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Skills',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Wrap(
                    children: [
                      _user != null
                          ? getTextWidgets(_user.skills)
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.interests.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Interest',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.purpose.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Purpose',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
      _user.phone.isNotEmpty ||
              _user.website.isNotEmpty ||
              _user.email.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width / 30),
                  child: Text(
                    'Contact Details',
                    style: TextStyle(
                      fontFamily: FontNameDefault,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: textSubTitle(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width / 30),
                  child: Divider(),
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
                  child: Container(
                    height: screenSize.height * 0.02,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            )
          : Container(),
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
                ),
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
      Divider(
        height: 0,
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
                ),
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
      Divider(
        height: 0,
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
                ),
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
      Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
        child: Container(
          height: screenSize.height * 0.02,
          color: Colors.grey[200],
        ),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: screenSize.height * 0.05,
        ),
      ]),
    ]);
  }
}
